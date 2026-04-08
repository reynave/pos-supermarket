const pool = require('../config/database');

async function createPrintLog(transactionId, inputBy) {
  const nowDatetime = new Date().toISOString().slice(0, 19).replace('T', ' ');

  const [result] = await pool.query(
    `INSERT INTO transaction_printlog (transactionId, inputDate, inputBy)
     VALUES (?, ?, ?)`,
    [transactionId, nowDatetime, inputBy || null],
  );

  return {
    id: result.insertId,
    transactionId,
    inputDate: nowDatetime,
    inputBy: inputBy || null,
  };
}

module.exports = {
  createPrintLog,
};
