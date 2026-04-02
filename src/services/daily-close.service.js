const pool = require('../config/database');

async function getDailyCloseSummary(resetId) {
  const [resetRows] = await pool.query(
    `SELECT id, userIdStart, userIdClose, storeOutlesId, startDate, endDate,
            totalTransaction, summaryTotalVoid, summaryTotalTransaction, summaryTotalCart,
            overalitemSales, overalDiscount, overalNetSales, overalFinalPrice, overalTax, note
     FROM reset
     WHERE id = ? AND presence = 1
     LIMIT 1`,
    [resetId],
  );

  if (!resetRows.length) {
    return null;
  }

  const [paymentRows] = await pool.query(
    `SELECT tp.paymentTypeId,
            COUNT(*) AS qty,
            IFNULL(SUM(tp.amount), 0) AS paidAmount
     FROM transaction_payment tp
     JOIN transaction t ON t.id = tp.transactionId
     WHERE t.resetId = ?
       AND t.presence = 1
       AND tp.presence = 1
     GROUP BY tp.paymentTypeId
     ORDER BY tp.paymentTypeId ASC`,
    [resetId],
  );

  const [openingRows] = await pool.query(
    `SELECT IFNULL(cashIn, 0) AS openingBalance
     FROM balance
     WHERE (resetId = ? OR transactionId = ?)
       AND transactionId = ?
       AND kioskUuid = ''
     LIMIT 1`,
    [resetId, resetId, resetId],
  );

  // Balance table totals (opening + manual cash in + transaction cash) for this reset period
  const [balSumRows] = await pool.query(
    `SELECT
       IFNULL(SUM(cashIn), 0) AS totalCashIn,
       IFNULL(SUM(cashOut), 0) AS totalCashOut
     FROM balance
     WHERE resetId = ?`,
    [resetId],
  );

  return {
    reset: resetRows[0],
    openingBalance: openingRows[0]?.openingBalance || 0,
    payments: paymentRows,
    balanceSummary: {
      totalCashIn: Number(balSumRows[0]?.totalCashIn || 0),
      totalCashOut: Number(balSumRows[0]?.totalCashOut || 0),
    },
  };
}

async function getDailyCloseHistory() {
  const [rows] = await pool.query(
    `SELECT r.id,
            r.userIdStart,
            r.userIdClose,
            r.startDate,
            r.endDate,
            r.totalTransaction,
            r.overalFinalPrice,
            r.overalTax,
            r.summaryTotalVoid,
            r.note,
            u.name AS userStartBy,
            u2.name AS userCloseBy
     FROM reset AS r
     LEFT JOIN user AS u ON u.id = r.userIdStart
     LEFT JOIN user AS u2 ON u2.id = r.userIdClose
     WHERE r.presence = 1
       AND r.endDate IS NOT NULL
     ORDER BY r.startDate DESC
     LIMIT 360`,
  );

  return {
    items: rows,
    total: Number(rows.length || 0),
  };
}

async function saveCashDeclaration(connection, { resetId, userIdClose, note, cashDeclaration }) {
  const declaration = {
    denom_100k: Number(cashDeclaration?.denom_100k || 0),
    denom_50k: Number(cashDeclaration?.denom_50k || 0),
    denom_20k: Number(cashDeclaration?.denom_20k || 0),
    denom_10k: Number(cashDeclaration?.denom_10k || 0),
    denom_5k: Number(cashDeclaration?.denom_5k || 0),
    denom_2k: Number(cashDeclaration?.denom_2k || 0),
    denom_1k: Number(cashDeclaration?.denom_1k || 0),
    coins_other: Number(cashDeclaration?.coins_other || 0),
  };

  const [existingRows] = await connection.query(
    `SELECT id FROM cash_declaration WHERE resetId = ? AND presence = 1 ORDER BY id DESC LIMIT 1`,
    [resetId],
  );

  if (existingRows.length) {
    await connection.query(
      `UPDATE cash_declaration
       SET userId = ?,
           denom_100k = ?,
           denom_50k = ?,
           denom_20k = ?,
           denom_10k = ?,
           denom_5k = ?,
           denom_2k = ?,
           denom_1k = ?,
           coins_other = ?,
           note = ?,
           status = 1,
             updateDate = NOW(),
           updateBy = ?
       WHERE id = ?`,
      [
        userIdClose,
        declaration.denom_100k,
        declaration.denom_50k,
        declaration.denom_20k,
        declaration.denom_10k,
        declaration.denom_5k,
        declaration.denom_2k,
        declaration.denom_1k,
        declaration.coins_other,
        note || '',
        Number(userIdClose) || null,
        existingRows[0].id,
      ],
    );
    return;
  }

  await connection.query(
    `INSERT INTO cash_declaration
       (resetId, userId, denom_100k, denom_50k, denom_20k, denom_10k, denom_5k, denom_2k, denom_1k, coins_other, note, status, presence, inputBy, inputDate)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1, 1, ?, NOW())`,
    [
      resetId,
      userIdClose,
      declaration.denom_100k,
      declaration.denom_50k,
      declaration.denom_20k,
      declaration.denom_10k,
      declaration.denom_5k,
      declaration.denom_2k,
      declaration.denom_1k,
      declaration.coins_other,
      note || '',
      Number(userIdClose) || null,
    ],
  );
}

async function closeDaily({ resetId, userIdClose, terminalId, note, cashDeclaration }) {
  const connection = await pool.getConnection();
  try {
    await connection.beginTransaction();

    const [resetRows] = await connection.query(
      `SELECT id, startDate
       FROM reset
       WHERE id = ? AND presence = 1
       FOR UPDATE`,
      [resetId],
    );

    if (!resetRows.length) {
      throw new Error('resetId not found');
    }

    const startDate = resetRows[0].startDate;

    await connection.query(
      `UPDATE transaction
       SET resetId = ?
       WHERE (resetId IS NULL OR resetId = '')
         AND presence = 1
         AND terminalId = ?
         AND transaction_date >= ?`,
      [resetId, terminalId, startDate],
    );

    const [sumRows] = await connection.query(
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
       WHERE resetId = ?
         AND presence = 1`,
      [resetId],
    );

    const summary = sumRows[0] || {
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

    await connection.query(
      `UPDATE balance
       SET close = 1
       WHERE close = 0
         AND (transactionId = ? OR transactionId IN (
           SELECT id FROM transaction WHERE resetId = ? AND presence = 1
         ))`,
      [resetId, resetId],
    );

    await connection.query('DELETE FROM reset_payment WHERE resetId = ?', [resetId]);

    await connection.query(
      `INSERT INTO reset_payment (resetId, paymentTypeId, qty, paidAmount, presence, inputDate)
       SELECT ?, tp.paymentTypeId, COUNT(*) AS qty, IFNULL(SUM(tp.amount), 0) AS paidAmount, 1, UNIX_TIMESTAMP()
       FROM transaction_payment tp
       JOIN transaction t ON t.id = tp.transactionId
       WHERE t.resetId = ?
         AND t.presence = 1
         AND tp.presence = 1
       GROUP BY tp.paymentTypeId`,
      [resetId, resetId],
    );

    await saveCashDeclaration(connection, {
      resetId,
      userIdClose,
      note,
      cashDeclaration,
    });

    await connection.commit();

    return {
      resetId,
      totalTransaction: Number(summary.totalTransaction || 0),
      totalAmount: Number(summary.overalFinalPrice || 0),
    };
  } catch (err) {
    await connection.rollback();
    throw err;
  } finally {
    connection.release();
  }
}

module.exports = {
  getDailyCloseSummary,
  getDailyCloseHistory,
  closeDaily,
};
