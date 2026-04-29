const pool = require('../config/database');

/**
 * Generate reset ID using auto_number id=220.
 * Format follows auto_number prefix + padded running number (e.g. RST000249).
 */
async function generateResetId() {
  const connection = await pool.getConnection();
  try {
    await connection.beginTransaction();

    const [rows] = await connection.query(
      'SELECT prefix, digit, runningNumber FROM auto_number WHERE id = 220 FOR UPDATE',
    );
    if (!rows.length) throw new Error('auto_number id=220 not found');

    const { prefix, digit, runningNumber } = rows[0];
    const nextNumber = runningNumber + 1;

    await connection.query(
      'UPDATE auto_number SET runningNumber = ?, updateDate = NOW() WHERE id = 220',
      [nextNumber],
    );

    await connection.commit();

    const padded = String(nextNumber).padStart(digit, '0');
    return `${prefix || ''}${padded}`;
  } catch (err) {
    await connection.rollback();
    throw err;
  } finally {
    connection.release();
  }
}

/**
 * Create a new reset row (daily start) and opening balance entry.
 */
async function openShift({ resetId, terminalId, cashierId, storeOutletId, openingBalance }) {
  const connection = await pool.getConnection();
  try {
    await connection.beginTransaction();

    // Daily start inserts reset header with start metadata only.
    await connection.query(
      `INSERT INTO reset
         (id, userIdStart, userIdClose, storeOutlesId, startDate, endDate,
          presence, inputDate, inputBy, updateDate, updateBy)
       VALUES (?, ?, '', ?, NOW(), NULL,
               1, NOW(), ?, NOW(), ?)` ,
      [resetId, cashierId, storeOutletId || null, cashierId, cashierId],
    );

    // Daily start writes opening cash to balance with transactionId = resetId.
    await connection.query(
      `INSERT INTO balance (resetId, cashIn, cashOut, transactionId, kioskUuid, cashierId, terminalId, settlementId, close, input_date)
       VALUES (?, ?, 0, ?, '', ?, ?, '', 0, NOW())`,
      [resetId, openingBalance, resetId, cashierId, terminalId],
    );

    await connection.commit();
    return { resetId };
  } catch (err) {
    await connection.rollback();
    throw err;
  } finally {
    connection.release();
  }
}

/**
 * Check if there is an active daily session.
 * A session is active when reset.endDate is still NULL.
 */
async function findActiveShift(terminalId) {
  const [rows] = await pool.query(
    `SELECT
       r.id AS resetId,
       r.userIdStart AS cashierId,
       IFNULL(b.cashIn, 0) AS openingBalance,
       r.startDate
     FROM reset r
    LEFT JOIN balance b ON (b.resetId = r.id OR b.transactionId = r.id) AND b.kioskUuid = ''
     WHERE r.presence = 1
       AND (? IS NULL OR ? = '' OR b.terminalId = ?)
       AND (r.endDate IS NULL OR r.endDate = '2026-01-01 00:00:00')
     ORDER BY r.startDate DESC
     LIMIT 1`,
    [terminalId || null, terminalId || null, terminalId || null],
  );
  return rows.length ? rows[0] : null;
}

/**
 * Get shift summary for daily close.
 * Aggregates transactions and payments for the given resetId.
 */
async function getShiftSummary(resetId) {
  // Transaction totals
  const [txRows] = await pool.query(
    `SELECT COUNT(*) AS transactionCount,
            IFNULL(SUM(total), 0) AS totalSales,
            IFNULL(SUM(discount), 0) AS totalDiscount,
            IFNULL(SUM(ppn), 0) AS totalTax,
            IFNULL(SUM(finalPrice), 0) AS totalFinalPrice,
            IFNULL(SUM(CASE WHEN total < 0 THEN 1 ELSE 0 END), 0) AS summaryTotalVoid,
            IFNULL(SUM(subTotal), 0) AS summaryTotalCart
     FROM transaction
     WHERE resetId = ? AND presence = 1`,
    [resetId],
  );

  // Payment breakdown
  const [payRows] = await pool.query(
    `SELECT tp.paymentTypeId,
            COUNT(*) AS count,
            IFNULL(SUM(tp.amount), 0) AS totalAmount
     FROM transaction_payment tp
     JOIN transaction t ON tp.transactionId = t.id
     WHERE t.resetId = ? AND t.presence = 1 AND tp.presence = 1
     GROUP BY tp.paymentTypeId`,
    [resetId],
  );

  // Opening balance
  const [balRows] = await pool.query(
    `SELECT cashIn AS openingBalance FROM balance
     WHERE (resetId = ? OR transactionId = ?)
       AND kioskUuid = ''
     LIMIT 1`,
    [resetId, resetId],
  );

  return {
    ...(txRows[0] || {}),
    openingBalance: balRows.length ? balRows[0].openingBalance : 0,
    payments: payRows,
  };
}

/**
 * Close the shift: update reset daily close fields and mark related balances as closed.
 */
async function closeShift(resetId, userIdClose, note) {
  const connection = await pool.getConnection();
  try {
    await connection.beginTransaction();

    // Get summary for daily close fields.
    const [txRows] = await connection.query(
      `SELECT
         COUNT(*) AS totalTransaction,
         IFNULL(SUM(CASE WHEN total < 0 THEN 1 ELSE 0 END), 0) AS summaryTotalVoid,
         IFNULL(SUM(total), 0) AS summaryTotalTransaction,
         IFNULL(SUM(subTotal), 0) AS summaryTotalCart,
         IFNULL(SUM(subTotal), 0) AS overalitemSales,
         IFNULL(SUM(discount), 0) AS overalDiscount,
         IFNULL(SUM(subTotal - discount), 0) AS overalNetSales,
         IFNULL(SUM(finalPrice), 0) AS overalFinalPrice,
         IFNULL(SUM(ppn), 0) AS overalTax
       FROM transaction
       WHERE resetId = ? AND presence = 1`,
      [resetId],
    );

    const summary = txRows[0] || {
      totalTransaction: 0,
      summaryTotalVoid: 0,
      summaryTotalTransaction: 0,
      summaryTotalCart: 0,
      overalitemSales: 0,
      overalDiscount: 0,
      overalNetSales: 0,
      overalFinalPrice: 0,
      overalTax: 0,
    };

    // Daily close updates remaining reset fields.
    await connection.query(
      `UPDATE reset
       SET userIdClose = ?,
           endDate = NOW(),
           totalTransaction = ?,
           summaryTotalVoid = ?,
           summaryTotalTransaction = ?,
           summaryTotalCart = ?,
           overalitemSales = ?,
           overalDiscount = ?,
           overalNetSales = ?,
           overalFinalPrice = ?,
           overalTax = ?,
           note = ?,
           updateDate = NOW(),
           updateBy = ?
       WHERE id = ?`,
      [
        userIdClose,
        summary.totalTransaction,
        summary.summaryTotalVoid,
        summary.summaryTotalTransaction,
        summary.summaryTotalCart,
        summary.overalitemSales,
        summary.overalDiscount,
        summary.overalNetSales,
        summary.overalFinalPrice,
        summary.overalTax,
        note || null,
        userIdClose,
        resetId,
      ],
    );

    // Mark opening balance row as closed.
    await connection.query(
      'UPDATE balance SET close = 1 WHERE resetId = ? AND transactionId = ? AND close = 0',
      [resetId, resetId],
    );

    // Mark all transaction cash movements of this reset as closed.
    await connection.query(
      `UPDATE balance
       SET close = 1
       WHERE close = 0
         AND resetId = ?
         AND transactionId IN (
           SELECT id FROM transaction WHERE resetId = ? AND presence = 1
         )`,
      [resetId, resetId],
    );

    await connection.commit();
    return {
      resetId,
      transactionCount: summary.totalTransaction,
      totalAmount: summary.overalFinalPrice,
    };
  } catch (err) {
    await connection.rollback();
    throw err;
  } finally {
    connection.release();
  }
}

module.exports = {
  generateResetId,
  openShift,
  findActiveShift,
  getShiftSummary,
  closeShift,
};
