const pool = require('../config/database');

/**
 * List all available payment types (status=1, presence=1).
 */
async function getPaymentTypes() {
  const [rows] = await pool.query(
    `SELECT id, label, name, image, edc, isLock
     FROM payment_type
     WHERE status = 1 AND presence = 1
     ORDER BY name ASC`,
  );
  return rows;
}

/**
 * Add a payment entry to kiosk_paid_pos.
 * Returns the new row id.
 */
async function addPayment({ kioskUuid, paymentTypeId, paid, reference, approvedCode }) {
  const now = new Date().toISOString().slice(0, 19).replace('T', ' ');

  const [result] = await pool.query(
    `INSERT INTO kiosk_paid_pos
       (kioskUuid, paymentTypeId, paid, refCode, approvedCode,
        startDate, input_date, update_date)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
    [kioskUuid, paymentTypeId, paid, reference || '', approvedCode || '', now, now, now],
  );
  return result.insertId;
}

/**
 * Remove a payment entry from kiosk_paid_pos by id.
 */
async function removePayment(id, kioskUuid) {
  const [result] = await pool.query(
    'DELETE FROM kiosk_paid_pos WHERE id = ? AND kioskUuid = ?',
    [id, kioskUuid],
  );
  return result.affectedRows > 0;
}

/**
 * Get all pending payment entries for a given kioskUuid.
 */
async function getPendingPayments(kioskUuid) {
  const [rows] = await pool.query(
    `SELECT kp.id, kp.paymentTypeId, kp.paid, kp.refCode, kp.approvedCode, kp.input_date,
            pt.label AS paymentLabel, pt.name AS paymentName
     FROM kiosk_paid_pos kp
     LEFT JOIN payment_type pt ON pt.id = kp.paymentTypeId
     WHERE kp.kioskUuid = ?
     ORDER BY kp.id ASC`,
    [kioskUuid],
  );
  return rows;
}

/**
 * Get total paid amount for a kioskUuid.
 */
async function getTotalPaid(kioskUuid) {
  const [rows] = await pool.query(
    'SELECT COALESCE(SUM(paid), 0) AS totalPaid FROM kiosk_paid_pos WHERE kioskUuid = ?',
    [kioskUuid],
  );
  return Number(rows[0]?.totalPaid || 0);
}

module.exports = {
  getPaymentTypes,
  addPayment,
  removePayment,
  getPendingPayments,
  getTotalPaid,
};
