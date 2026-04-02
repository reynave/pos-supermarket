const pool = require('../config/database');

async function getManualCashSummary(terminalId) {
  const [activeRows] = await pool.query(
    `SELECT r.id AS resetId,
            r.userIdStart AS cashierId,
            r.startDate,
            IFNULL(bOpen.cashIn, 0) AS openingBalance
     FROM reset r
     LEFT JOIN balance bOpen
       ON (bOpen.resetId = r.id OR bOpen.transactionId = r.id)
      AND bOpen.kioskUuid = ''
     WHERE r.presence = 1
       AND (r.endDate IS NULL OR r.endDate = '2026-01-01 00:00:00')
       AND (? IS NULL OR ? = '' OR bOpen.terminalId = ?)
     ORDER BY r.startDate DESC
     LIMIT 1`,
    [terminalId || null, terminalId || null, terminalId || null],
  );

  if (!activeRows.length) {
    return null;
  }

  const active = activeRows[0];

  const [balanceRows] = await pool.query(
    `SELECT IFNULL(SUM(cashIn + cashOut), 0) AS currentCashBalance
     FROM balance
     WHERE close = 0
       AND resetId = ?
       AND (? IS NULL OR ? = '' OR terminalId = ?)`,
    [active.resetId, terminalId || null, terminalId || null, terminalId || null],
  );

  return {
    resetId: active.resetId,
    cashierId: active.cashierId,
    startDate: active.startDate,
    openingBalance: Number(active.openingBalance || 0),
    currentCashBalance: Number(balanceRows[0]?.currentCashBalance || 0),
    terminalId: terminalId || '',
  };
}

async function addManualCashIn({ resetId, amount, terminalId, cashierId }) {
  const safeAmount = Number(amount || 0);
  if (!safeAmount || safeAmount <= 0) {
    throw new Error('amount must be greater than 0');
  }

  await pool.query(
    `INSERT INTO balance
       (resetId, cashIn, cashOut, transactionId, kioskUuid, cashierId, terminalId, settlementId, close, input_date)
     VALUES (?, ?, 0, '', '', ?, ?, '', 0, NOW())`,
    [resetId, safeAmount, cashierId, terminalId],
  );

  const summary = await getManualCashSummary(terminalId);
  return {
    resetId,
    addedAmount: safeAmount,
    currentCashBalance: summary?.currentCashBalance || 0,
  };
}

async function getCashBalanceHistory({ terminalId, resetId }) {
  const [resetOptionRows] = await pool.query(
    `SELECT DISTINCT b.resetId
     FROM balance b
     WHERE b.resetId <> ''
       AND (? IS NULL OR ? = '' OR b.terminalId = ?)
     ORDER BY b.resetId DESC
     LIMIT 360`,
    [terminalId || null, terminalId || null, terminalId || null],
  );

  const [rows] = await pool.query(
    `SELECT b.id,
            b.resetId,
            b.transactionId,
            b.kioskUuid,
            b.cashIn,
            ABS(b.cashOut) AS cashOut,
            b.input_date AS dateTime,
            u.name AS cashierName,
            CASE
              WHEN b.kioskUuid = '' AND b.transactionId = b.resetId THEN 'OPENING BALANCE'
              WHEN b.kioskUuid = '' AND (b.transactionId = '' OR b.transactionId IS NULL) THEN 'MANUAL CASH IN'
              ELSE b.transactionId
            END AS billNo,
            CASE
              WHEN b.kioskUuid = '' AND b.transactionId = b.resetId THEN 'OPENING'
              WHEN b.kioskUuid = '' AND (b.transactionId = '' OR b.transactionId IS NULL) THEN 'MANUAL_CASH_IN'
              ELSE 'TRANSACTION'
            END AS rowType
     FROM balance b
     LEFT JOIN user u ON u.id = b.cashierId
     WHERE b.resetId <> ''
       AND (? IS NULL OR ? = '' OR b.terminalId = ?)
       AND (? IS NULL OR ? = '' OR b.resetId = ?)
     ORDER BY b.resetId DESC, b.input_date DESC, b.id DESC
     LIMIT 360`,
    [
      terminalId || null, terminalId || null, terminalId || null,
      resetId || null, resetId || null, resetId || null,
    ],
  );

  const openingBalance = rows
    .filter((row) => row.rowType === 'OPENING')
    .reduce((sum, row) => sum + Number(row.cashIn || 0), 0);

  return {
    openingBalance,
    items: rows,
    total: Number(rows.length || 0),
    resetOptions: resetOptionRows.map((row) => row.resetId),
  };
}

function openCashDrawer() {
  return {
    opened: true,
    message: 'Cash drawer open command accepted',
  };
}

module.exports = {
  getManualCashSummary,
  addManualCashIn,
  getCashBalanceHistory,
  openCashDrawer,
};
