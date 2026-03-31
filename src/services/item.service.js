const pool = require('../config/database');

/**
 * Find kiosk_uuid record by kioskUuid.
 */
async function findKioskUuid(kioskUuid) {
  const [rows] = await pool.query(
    `SELECT kioskUuid, cashierId, terminalId, storeOutlesId, memberId
     FROM kiosk_uuid
     WHERE kioskUuid = ?
       AND status = 1 AND presence = 1
     LIMIT 1`,
    [kioskUuid]
  );
  return rows[0] || null;
}

/**
 * Find item by barcode.
 * Looks up item_barcode → gets itemId → fetches item detail.
 */
async function findByBarcode(barcode) {
  const [rows] = await pool.query(
    `SELECT i.id, i.description, i.shortDesc, i.priceFlag, i.ppnFlag,
            i.price1, i.price2, i.price3, i.price4, i.price5,
            i.price6, i.price7, i.price8, i.price9, i.price10,
            i.itemUomId, i.itemCategoryId, i.itemTaxId, i.images,
            ib.barcode
     FROM item_barcode ib
     INNER JOIN item i ON i.id = ib.itemId
     WHERE ib.barcode = ?
       AND ib.status = 1 AND ib.presence = 1
       AND i.status = 1 AND i.presence = 1
     LIMIT 1`,
    [barcode]
  );
  return rows[0] || null;
}

/**
 * Find item by article/SKU ID.
 */
async function findById(itemId) {
  const [rows] = await pool.query(
    `SELECT i.id, i.description, i.shortDesc, i.priceFlag, i.ppnFlag,
            i.price1, i.price2, i.price3, i.price4, i.price5,
            i.price6, i.price7, i.price8, i.price9, i.price10,
            i.itemUomId, i.itemCategoryId, i.itemTaxId, i.images
     FROM item i
     WHERE i.id = ?
       AND i.status = 1 AND i.presence = 1
     LIMIT 1`,
    [itemId]
  );
  return rows[0] || null;
}

/**
 * Search items by description (LIKE query).
 * Returns max 50 results for safety.
 */
async function searchByDescription(query, limit = 50) {
  const [rows] = await pool.query(
    `SELECT i.id, i.description, i.shortDesc,
            i.price1, i.itemUomId, i.itemCategoryId, i.images
     FROM item i
     WHERE i.description LIKE ?
       AND i.status = 1 AND i.presence = 1
     ORDER BY i.description ASC
     LIMIT ?`,
    [`%${query}%`, limit]
  );
  return rows;
}

/**
 * Get all barcodes for a given itemId.
 */
async function getBarcodesByItemId(itemId) {
  const [rows] = await pool.query(
    `SELECT barcode FROM item_barcode
     WHERE itemId = ? AND status = 1 AND presence = 1`,
    [itemId]
  );
  return rows.map(r => r.barcode);
}

/**
 * Insert item into kiosk_cart.
 * Returns the new cart row id.
 */
async function addToCart(kioskUuid, item, barcode) {
  const now = Math.floor(Date.now() / 1000);
  const nowDatetime = new Date().toISOString().slice(0, 19).replace('T', ' ');

  const [result] = await pool.query(
    `INSERT INTO kiosk_cart
       (kioskUuid, itemId, barcode, originPrice, price, presence,   inputDate, updateDate)
     VALUES (?, ?, ?, ?, ?, 1, ?, ?)`,
    [kioskUuid, item.id, barcode || null, item.price1 || 0, item.price1 || 0,   nowDatetime, nowDatetime]
  );
  return result.insertId;
}

module.exports = {
  findKioskUuid,
  findByBarcode,
  findById,
  searchByDescription,
  getBarcodesByItemId,
  addToCart,
};
