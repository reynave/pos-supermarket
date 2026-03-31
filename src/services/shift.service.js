const pool = require('../config/database');

/**
 * Generate a new settlementId using auto_number id=301.
 * Format: {terminalId}SET{padded_runningNumber}
 * e.g. T01SET000040
 */
async function generateSettlementId(terminalId) {
  const connection = await pool.getConnection();
  try {
    await connection.beginTransaction();

    const [rows] = await connection.query(
      'SELECT prefix, digit, runningNumber FROM auto_number WHERE id = 301 FOR UPDATE',
    );
    if (!rows.length) throw new Error('auto_number id=301 not found');

    const { prefix, digit, runningNumber } = rows[0];
    const nextNumber = runningNumber + 1;

    await connection.query(
      'UPDATE auto_number SET runningNumber = ?, updateDate = UNIX_TIMESTAMP() WHERE id = 301',
      [nextNumber],
    );

    await connection.commit();

    const padded = String(nextNumber).padStart(digit, '0');
    return `${terminalId}${prefix}${padded}`;
  } catch (err) {
    await connection.rollback();
    throw err;
  } finally {
    connection.release();
  }
}

/**
 * Create a new settlement record and opening balance.
 */
async function openShift({ settlementId, terminalId, cashierId, openingBalance }) {
  const connection = await pool.getConnection();
  try {
    await connection.beginTransaction();

    // Insert settlement record
    await connection.query(
      `INSERT INTO settlement (id, total, amount, input_date, upload, upload_date)
       VALUES (?, 0, 0, NOW(), 0, '2023-01-01 00:00:00')`,
      [settlementId],
    );

    // Insert opening balance row (cashIn = openingBalance, transactionId = '_S1' convention)
    await connection.query(
      `INSERT INTO balance (cashIn, cashOut, transactionId, kioskUuid, cashierId, terminalId, settlementId, close, input_date)
       VALUES (?, 0, '_S1', '', ?, ?, ?, 0, NOW())`,
      [openingBalance, cashierId, terminalId, settlementId],
    );

    await connection.commit();
    return { settlementId };
  } catch (err) {
    await connection.rollback();
    throw err;
  } finally {
    connection.release();
  }
}

/**
 * Check if there is an active (unclosed) settlement for this terminal.
 * An active settlement has at least one balance row with close = 0.
 */
async function findActiveShift(terminalId) {
  const [rows] = await pool.query(
    `SELECT b.settlementId, b.cashierId, b.cashIn AS openingBalance, b.input_date
     FROM balance b
     WHERE b.terminalId = ? AND b.transactionId = '_S1' AND b.close = 0
     ORDER BY b.id DESC LIMIT 1`,
    [terminalId],
  );
  return rows.length ? rows[0] : null;
}

/**
 * Get shift summary for daily close.
 * Aggregates transactions and payments for the given settlementId.
 */
async function getShiftSummary(settlementId) {
  // Transaction totals
  const [txRows] = await pool.query(
    `SELECT COUNT(*) AS transactionCount,
            IFNULL(SUM(total), 0) AS totalSales,
            IFNULL(SUM(discount), 0) AS totalDiscount,
            IFNULL(SUM(ppn), 0) AS totalTax,
            IFNULL(SUM(finalPrice), 0) AS totalFinalPrice
     FROM transaction
     WHERE settlementId = ? AND presence = 1`,
    [settlementId],
  );

  // Payment breakdown
  const [payRows] = await pool.query(
    `SELECT tp.paymentTypeId,
            COUNT(*) AS count,
            IFNULL(SUM(tp.amount), 0) AS totalAmount
     FROM transaction_payment tp
     JOIN transaction t ON tp.transactionId = t.id
     WHERE t.settlementId = ? AND t.presence = 1 AND tp.presence = 1
     GROUP BY tp.paymentTypeId`,
    [settlementId],
  );

  // Opening balance
  const [balRows] = await pool.query(
    `SELECT cashIn AS openingBalance FROM balance
     WHERE settlementId = ? AND transactionId = '_S1'
     LIMIT 1`,
    [settlementId],
  );

  return {
    ...(txRows[0] || {}),
    openingBalance: balRows.length ? balRows[0].openingBalance : 0,
    payments: payRows,
  };
}

/**
 * Close the shift: mark all balance rows as closed, update settlement totals.
 */
async function closeShift(settlementId) {
  const connection = await pool.getConnection();
  try {
    await connection.beginTransaction();

    // Get summary for updating settlement
    const [txRows] = await connection.query(
      `SELECT COUNT(*) AS total, IFNULL(SUM(finalPrice), 0) AS amount
       FROM transaction
       WHERE settlementId = ? AND presence = 1`,
      [settlementId],
    );

    const { total, amount } = txRows[0] || { total: 0, amount: 0 };

    // Update settlement record
    await connection.query(
      'UPDATE settlement SET total = ?, amount = ?, input_date = NOW() WHERE id = ?',
      [total, amount, settlementId],
    );

    // Mark all balance rows for this settlement as closed
    await connection.query(
      'UPDATE balance SET close = 1 WHERE settlementId = ? AND close = 0',
      [settlementId],
    );

    await connection.commit();
    return { settlementId, transactionCount: total, totalAmount: amount };
  } catch (err) {
    await connection.rollback();
    throw err;
  } finally {
    connection.release();
  }
}

module.exports = {
  generateSettlementId,
  openShift,
  findActiveShift,
  getShiftSummary,
  closeShift,
};
