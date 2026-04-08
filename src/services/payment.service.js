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
 * List all payment types for settings page.
 */
async function getAllPaymentTypes() {
  const [rows] = await pool.query(
    `SELECT *
     FROM payment_type
     ORDER BY id ASC`,
  );
  return rows;
}

/**
 * Get payment type detail by id.
 */
async function getPaymentTypeById(id) {
  const [rows] = await pool.query(
    `SELECT *
     FROM payment_type
     WHERE id = ?
     LIMIT 1`,
    [id],
  );
  return rows[0] || null;
}

/**
 * Update payment type fields by id.
 */
async function updatePaymentTypeById(id, payload) {
  const fields = [];
  const values = [];

  if (payload.label !== undefined) {
    fields.push('label = ?');
    values.push(payload.label);
  }
  if (payload.name !== undefined) {
    fields.push('name = ?');
    values.push(payload.name);
  }
  if (payload.image !== undefined) {
    fields.push('image = ?');
    values.push(payload.image);
  }
  if (payload.edc !== undefined) {
    fields.push('edc = ?');
    values.push(Number(payload.edc));
  }
  if (payload.isLock !== undefined) {
    fields.push('isLock = ?');
    values.push(Number(payload.isLock));
  }
  if (payload.status !== undefined) {
    fields.push('status = ?');
    values.push(Number(payload.status));
  }
  if (payload.connectionType !== undefined) {
    fields.push('connectionType = ?');
    values.push(payload.connectionType);
  }
  if (payload.openCashDrawer !== undefined) {
    fields.push('openCashDrawer = ?');
    values.push(Number(payload.openCashDrawer));
  }
  if (payload.com !== undefined) {
    fields.push('com = ?');
    values.push(payload.com);
  }
  if (payload.ip !== undefined) {
    fields.push('ip = ?');
    values.push(payload.ip);
  }
  if (payload.port !== undefined) {
    fields.push('port = ?');
    values.push(payload.port);
  }
  if (payload.apikey !== undefined) {
    fields.push('apikey = ?');
    values.push(payload.apikey);
  }
  if (payload.mId !== undefined) {
    fields.push('mId = ?');
    values.push(payload.mId);
  }
  if (payload.nmId !== undefined) {
    fields.push('nmId = ?');
    values.push(payload.nmId);
  }
  if (payload.merchant !== undefined) {
    fields.push('merchant = ?');
    values.push(payload.merchant);
  }
  if (payload.timeout !== undefined) {
    fields.push('timeout = ?');
    values.push(Number(payload.timeout));
  }
  if (payload.apiUrl !== undefined) {
    fields.push('apiUrl = ?');
    values.push(payload.apiUrl);
  }
  if (payload.apiUrlStatus !== undefined) {
    fields.push('apiUrlStatus = ?');
    values.push(payload.apiUrlStatus);
  }
  if (payload.presence !== undefined) {
    fields.push('presence = ?');
    values.push(Number(payload.presence));
  }
  if (payload.inputBy !== undefined) {
    fields.push('inputBy = ?');
    values.push(payload.inputBy);
  }
  if (payload.updateBy !== undefined) {
    fields.push('updateBy = ?');
    values.push(payload.updateBy);
  }

  if (!fields.length) return false;

  fields.push('updateDate = NOW()');
  values.push(id);

  const [result] = await pool.query(
    `UPDATE payment_type
     SET ${fields.join(', ')}
     WHERE id = ?`,
    values,
  );

  return result.affectedRows > 0;
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

/**
 * Calculate grand total from kiosk_cart using the same tax formula as transaction creation.
 */
async function getCartGrandTotal(kioskUuid) {
  const [rows] = await pool.query(
    `SELECT kc.price, kc.discount, i.ppnFlag, i.itemTaxId
     FROM kiosk_cart kc
     INNER JOIN item i ON i.id = kc.itemId
     WHERE kc.kioskUuid = ?
       AND kc.presence = 1
       AND kc.void = 0`,
    [kioskUuid],
  );

  if (!rows.length) return 0;

  const PPN_RATE = 11;
  let subTotal = 0;
  let totalDiscount = 0;
  let totalPpn = 0;

  for (const row of rows) {
    const price = Number(row.price || 0);
    const discount = Number(row.discount || 0);
    const netPrice = price - discount;
    const hasTax = Number(row.ppnFlag) === 1 || String(row.itemTaxId) === '2';

    subTotal += price;
    totalDiscount += discount;

    if (hasTax) {
      totalPpn += Math.round(netPrice * (PPN_RATE / 100));
    }
  }

  return subTotal - totalDiscount + totalPpn;
}

/**
 * Check for an active voucher promotion and calculate gift amount.
 *
 * Logic:
 *  - Find promotion WHERE typeOfPromotion = 'voucher', active date/day/status
 *  - If requiredVoucherAllowMultyple = 1:
 *      multiplier = floor(grandTotal / requiredVoucherMinAmount)
 *      giftAmount = multiplier * voucherGiftAmount
 *  - If requiredVoucherAllowMultyple = 0:
 *      giftAmount = (grandTotal >= requiredVoucherMinAmount) ? voucherGiftAmount : 0
 *
 * @param {number} grandTotal
 * @param {string|null} storeOutletId
 * @returns {Promise<{promotionId, promotionDescription, giftAmount, voucherMinAmount, voucherAllowMultyple, voucherGiftAmount, voucherExpDate}|null>}
 */
async function checkVoucherPromotion(grandTotal, storeOutletId) {
  const [rows] = await pool.query(
    `SELECT
       id AS promotionId,
       description AS promotionDescription,
       requiredVoucherMinAmount,
       requiredVoucherAllowMultyple,
       voucherMinAmount,
       voucherAllowMultyple,
       voucherGiftAmount,
       voucherExpDate
     FROM promotion
     WHERE typeOfPromotion = 'voucher'
       AND status = 1
       AND presence = 1
       AND startDate <= NOW()
       AND endDate >= NOW()
       AND requiredVoucherMinAmount > 0
       AND voucherGiftAmount > 0
       AND (storeOutlesId IS NULL OR storeOutlesId = ?)
       AND CASE DAYOFWEEK(NOW())
             WHEN 2 THEN Mon = 1
             WHEN 3 THEN Tue = 1
             WHEN 4 THEN Wed = 1
             WHEN 5 THEN Thu = 1
             WHEN 6 THEN Fri = 1
             WHEN 7 THEN Sat = 1
             WHEN 1 THEN Sun = 1
             ELSE 1
           END
     ORDER BY
       CASE WHEN storeOutlesId = ? THEN 0 ELSE 1 END ASC,
       startDate DESC
     LIMIT 1`,
    [storeOutletId || '', storeOutletId || ''],
  );

  if (!rows.length) return null;

  const promo = rows[0];
  const minAmount = Number(promo.requiredVoucherMinAmount);

  if (grandTotal < minAmount) return null;

  let giftAmount;
  if (promo.requiredVoucherAllowMultyple === 1) {
    const multiplier = Math.floor(grandTotal / minAmount);
    giftAmount = multiplier * Number(promo.voucherGiftAmount);
  } else {
    giftAmount = Number(promo.voucherGiftAmount);
  }

  if (giftAmount <= 0) return null;

  return {
    promotionId: promo.promotionId,
    promotionDescription: promo.promotionDescription,
    giftAmount,
    voucherMinAmount: Number(promo.voucherMinAmount),
    voucherAllowMultyple: Number(promo.voucherAllowMultyple),
    voucherGiftAmount: Number(promo.voucherGiftAmount),
    voucherExpDate: promo.voucherExpDate,
  };
}

module.exports = {
  getPaymentTypes,
  getAllPaymentTypes,
  getPaymentTypeById,
  updatePaymentTypeById,
  addPayment,
  removePayment,
  getPendingPayments,
  getTotalPaid,
  getCartGrandTotal,
  checkVoucherPromotion,
};
