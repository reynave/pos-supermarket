const pool = require('../config/database');
const crypto = require('crypto');

/**
 * Generate next kioskUuid using auto_number id=302 (name='pos').
 * Format: {terminalId}.{YYMMDD}.{runningNumber padded to digit length}
 * Example: T01.250728.0235
 */
async function generateKioskUuid(terminalId) {
  const autoNumberId = 302;

  // Atomically increment runningNumber and get the new value
  await pool.query(
    `UPDATE auto_number SET runningNumber = runningNumber + 1, updateDate = UNIX_TIMESTAMP() WHERE id = ?`,
    [autoNumberId]
  );

  const [rows] = await pool.query(
    `SELECT digit, runningNumber FROM auto_number WHERE id = ?`,
    [autoNumberId]
  );

  if (!rows[0]) throw new Error('auto_number record not found for pos');

  const { digit, runningNumber } = rows[0];
  const padded = String(runningNumber).padStart(digit, '0');

  // Date part: YYMMDD
  const now = new Date();
  const yy = String(now.getFullYear()).slice(-2);
  const mm = String(now.getMonth() + 1).padStart(2, '0');
  const dd = String(now.getDate()).padStart(2, '0');
  const datePart = `${yy}${mm}${dd}`;

  return `${terminalId}.${datePart}.${padded}`;
}

/**
 * Insert new kiosk_uuid record (create new cart session).
 */
async function createKioskUuid(kioskUuid, cashierId, terminalId, storeOutletId) {
  const nowEpoch = Math.floor(Date.now() / 1000);
  const nowDatetime = new Date().toISOString().slice(0, 19).replace('T', ' ');

  await pool.query(
    `INSERT INTO kiosk_uuid
       (kioskUuid, exchange, cashierId, terminalId, storeOutlesId, memberId, photo, ilock, presence, status, inputDate, startDate, input_date, update_date)
     VALUES (?, '', ?, ?, ?, NULL, NULL, 0, 1, 1, ?, '2023-01-01 00:00:00', ?, ?)`,
    [kioskUuid, cashierId, terminalId, storeOutletId || null, nowEpoch, nowDatetime, nowDatetime]
  );

  // Return the inserted row
  const [rows] = await pool.query(
    `SELECT kioskUuid, cashierId, terminalId, storeOutlesId, status, presence, inputDate, input_date, update_date
     FROM kiosk_uuid WHERE kioskUuid = ?`,
    [kioskUuid]
  );
  return rows[0] || null;
}

/**
 * Find kiosk_uuid by kioskUuid.
 */
async function findByKioskUuid(kioskUuid) {
  const [rows] = await pool.query(
    `SELECT kioskUuid, cashierId, terminalId, storeOutlesId, status, presence, inputDate, input_date, update_date
     FROM kiosk_uuid
     WHERE kioskUuid = ? AND status = 1 AND presence = 1
     LIMIT 1`,
    [kioskUuid]
  );
  return rows[0] || null;
}

/**
 * Get all cart items for a kioskUuid, joined with item table for details.
 * Groups by itemId, aggregates qty, calculates totals.
 */
async function listCartItems(kioskUuid) {
  const [rows] = await pool.query(
    `SELECT
       kc.itemId,
       kc.promotionId,
       kc.promotionItemId,
       p.description AS promotionName,
       i.description,
       i.shortDesc,
       kc.price,
       i.ppnFlag,
       i.itemUomId,
       i.itemCategoryId,
       i.itemTaxId,
       i.images,
       kc.barcode,
       COUNT(kc.id) AS qty,
       SUM(kc.price) AS totalPrice,
       SUM(kc.discount) AS totalDiscount
     FROM kiosk_cart kc
     INNER JOIN item i ON i.id = kc.itemId
     LEFT JOIN promotion p ON p.id = kc.promotionId
     WHERE kc.kioskUuid = ?
       AND kc.presence = 1
       AND kc.void = 0
     GROUP BY kc.itemId, kc.barcode, kc.promotionId, kc.promotionItemId, p.description, i.description, i.shortDesc,
              kc.price, i.ppnFlag, i.itemUomId, i.itemCategoryId,
              i.itemTaxId, i.images
     ORDER BY MIN(kc.inputDate) ASC`,
    [kioskUuid]
  );
  return rows;
}

/**
 * Hard delete all cart data for a kioskUuid.
 * Deletes from: kiosk_cart, kiosk_cart_free_item, kiosk_paid_pos, kiosk_uuid.
 */
async function deleteCartByKioskUuid(kioskUuid) {
  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    await conn.query('DELETE FROM kiosk_cart WHERE kioskUuid = ?', [kioskUuid]);
    await conn.query('DELETE FROM kiosk_cart_free_item WHERE kioskUuid = ?', [kioskUuid]);
    await conn.query('DELETE FROM kiosk_paid_pos WHERE kioskUuid = ?', [kioskUuid]);
    await conn.query('DELETE FROM kiosk_uuid WHERE kioskUuid = ?', [kioskUuid]);

    await conn.commit();
    return true;
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}


/**
 * Void (delete) N qty of an item from kiosk_cart for a given kioskUuid.
 * If barcode is provided, match both itemId and barcode.
 * If qty >= available, delete all rows for that item.
 */
async function voidCartItem(kioskUuid, itemId, barcode, qty, reason) {
  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();
    // Find all matching rows (not voided)
    let q = `SELECT id FROM kiosk_cart WHERE kioskUuid = ? AND itemId = ? AND presence = 1 AND void = 0`;
    const params = [kioskUuid, itemId];
    if (barcode) {
      q += ' AND barcode = ?';
      params.push(barcode);
    }
    q += ' ORDER BY inputDate ASC';
    const [rows] = await conn.query(q, params);
    if (!rows.length) {
      await conn.rollback();
      return false;
    }
    // Only void up to qty requested
    const toVoid = rows.slice(0, qty);
    if (!toVoid.length) {
      await conn.rollback();
      return false;
    }
    const ids = toVoid.map(r => r.id);
    // Mark as voided (void=1), optionally store reason in note
    await conn.query(
      `UPDATE kiosk_cart SET void = 1, note = CONCAT(IFNULL(note,''), ?) WHERE id IN (${ids.map(() => '?').join(',')})`,
      [`[void]${reason ? ' ' + reason : ''}`, ...ids]
    );
    await conn.commit();
    return true;
  } catch (err) {
    await conn.rollback();
    throw err;
  } finally {
    conn.release();
  }
}

module.exports = {
  generateKioskUuid,
  createKioskUuid,
  findByKioskUuid,
  listCartItems,
  deleteCartByKioskUuid,
  verifyPin,
  voidCartItem,
};

/**
 * Verify a supervisor PIN against the user_pin table.
 * Converts plain text to MD5 then compares with stored hash.
 * Returns the matching user_pin row (with userId) if valid, null otherwise.
 */
async function verifyPin(plainPin) {
  const md5Hash = crypto.createHash('md5').update(plainPin).digest('hex');
    const q =   `SELECT id, userId FROM user_pin WHERE pin = '${md5Hash}' LIMIT 1`;

  const [rows] = await pool.query(q );
 // console.log(q, rows);
  return rows[0] || null;
}
