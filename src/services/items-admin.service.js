const pool = require('../config/database');

function toUnixTimestamp() {
  return Math.floor(Date.now() / 1000);
}

function normalizeActorId(actorId) {
  const parsed = Number.parseInt(String(actorId ?? ''), 10);
  return Number.isNaN(parsed) ? null : parsed;
}

function normalizeBarcodes(barcodes = []) {
  return [...new Set(
    barcodes
      .map((barcode) => String(barcode ?? '').trim())
      .filter((barcode) => barcode.length > 0),
  )];
}

function mapListRow(row) {
  return {
    id: row.id,
    description: row.description ?? '',
    shortDesc: row.shortDesc ?? '',
    price1: Number(row.price1 ?? 0),
    itemUomId: row.itemUomId ?? '',
    itemUomName: row.itemUomName ?? '',
    itemCategoryId: row.itemCategoryId ? String(row.itemCategoryId) : '',
    itemCategoryName: row.itemCategoryName ?? '',
    itemTaxId: row.itemTaxId ? String(row.itemTaxId) : '',
    itemTaxName: row.itemTaxName ?? '',
    images: row.images ?? '',
    status: Number(row.status ?? 1),
    presence: Number(row.presence ?? 1),
    inputBy: row.inputBy ?? null,
    inputDate: row.inputDate ?? null,
    updateBy: row.updateBy ?? null,
    updateDate: row.updateDate ?? null,
    primaryBarcode: row.primaryBarcode ?? '',
    barcodeCount: Number(row.barcodeCount ?? 0),
  };
}

function mapBarcodeRow(row) {
  return {
    id: Number(row.id),
    barcode: row.barcode ?? '',
    status: Number(row.status ?? 1),
    presence: Number(row.presence ?? 1),
    inputBy: row.inputBy ?? null,
    inputDate: row.inputDate ?? null,
    updateBy: row.updateBy ?? null,
    updateDate: row.updateDate ?? null,
  };
}

async function getItemById(itemId, executor = pool) {
  const [rows] = await executor.query(
    `SELECT i.id, i.description, i.shortDesc, i.priceFlag, i.ppnFlag,
            i.price1, i.price2, i.price3, i.price4, i.price5,
            i.price6, i.price7, i.price8, i.price9, i.price10,
            i.itemUomId, iu.name AS itemUomName,
            i.itemCategoryId, ic.name AS itemCategoryName,
            i.itemTaxId, it.description AS itemTaxName,
            i.images, i.status, i.presence,
            i.inputBy, i.inputDate, i.updateBy, i.updateDate
     FROM item i
     LEFT JOIN item_uom iu ON iu.id = i.itemUomId
     LEFT JOIN item_category ic ON ic.id = i.itemCategoryId
     LEFT JOIN item_tax it ON it.id = i.itemTaxId
     WHERE i.id = ? AND i.presence = 1
     LIMIT 1`,
    [itemId],
  );

  if (!rows[0]) {
    return null;
  }

  const [barcodeRows] = await executor.query(
    `SELECT id, barcode, status, presence, inputBy, inputDate, updateBy, updateDate
     FROM item_barcode
     WHERE itemId = ? AND presence = 1
     ORDER BY id ASC`,
    [itemId],
  );

  const mappedBarcodes = barcodeRows.map(mapBarcodeRow);

  return {
    ...mapListRow(rows[0]),
    priceFlag: rows[0].priceFlag ?? null,
    ppnFlag: rows[0].ppnFlag ?? null,
    price2: rows[0].price2 ?? null,
    price3: rows[0].price3 ?? null,
    price4: rows[0].price4 ?? null,
    price5: rows[0].price5 ?? null,
    price6: rows[0].price6 ?? null,
    price7: rows[0].price7 ?? null,
    price8: rows[0].price8 ?? null,
    price9: rows[0].price9 ?? null,
    price10: rows[0].price10 ?? null,
    primaryBarcode: mappedBarcodes[0]?.barcode ?? '',
    barcodeCount: mappedBarcodes.length,
    barcodes: mappedBarcodes,
  };
}

async function listItems({ q = '', page = 1, limit = 20 }) {
  const safePage = Math.max(1, Number(page) || 1);
  const safeLimit = Math.min(100, Math.max(1, Number(limit) || 20));
  const offset = (safePage - 1) * safeLimit;
  const keyword = String(q ?? '').trim();

  let whereSql = 'WHERE i.presence = 1';
  const params = [];

  if (keyword) {
    const like = `%${keyword}%`;
    whereSql += `
      AND (
        i.id LIKE ?
        OR COALESCE(i.description, '') LIKE ?
        OR COALESCE(i.shortDesc, '') LIKE ?
        OR EXISTS (
          SELECT 1
          FROM item_barcode ibs
          WHERE ibs.itemId = i.id
            AND ibs.presence = 1
            AND ibs.status = 1
            AND ibs.barcode LIKE ?
        )
      )`;
    params.push(like, like, like, like);
  }

  const [countRows] = await pool.query(
    `SELECT COUNT(*) AS total
     FROM item i
     ${whereSql}`,
    params,
  );

  const [rows] = await pool.query(
    `SELECT i.id, i.description, i.shortDesc, i.price1,
            i.itemUomId, iu.name AS itemUomName,
            i.itemCategoryId, ic.name AS itemCategoryName,
            i.itemTaxId, it.description AS itemTaxName,
            i.images, i.status, i.presence,
            i.inputBy, i.inputDate, i.updateBy, i.updateDate,
            (
              SELECT ib1.barcode
              FROM item_barcode ib1
              WHERE ib1.itemId = i.id
                AND ib1.presence = 1
                AND ib1.status = 1
              ORDER BY ib1.id ASC
              LIMIT 1
            ) AS primaryBarcode,
            (
              SELECT COUNT(*)
              FROM item_barcode ib2
              WHERE ib2.itemId = i.id
                AND ib2.presence = 1
                AND ib2.status = 1
            ) AS barcodeCount
     FROM item i
     LEFT JOIN item_uom iu ON iu.id = i.itemUomId
     LEFT JOIN item_category ic ON ic.id = i.itemCategoryId
     LEFT JOIN item_tax it ON it.id = i.itemTaxId
     ${whereSql}
     ORDER BY COALESCE(i.updateDate, i.inputDate, 0) DESC, i.id ASC
     LIMIT ? OFFSET ?`,
    [...params, safeLimit, offset],
  );

  return {
    items: rows.map(mapListRow),
    total: Number(countRows[0]?.total ?? 0),
    page: safePage,
    limit: safeLimit,
    query: keyword,
  };
}

async function getMeta() {
  const [categories] = await pool.query(
    `SELECT id, id_parent, name
     FROM item_category
     WHERE status = 1 AND presence = 1
     ORDER BY name ASC`,
  );

  const [uoms] = await pool.query(
    `SELECT id, name, description
     FROM item_uom
     WHERE status = 1 AND presence = 1
     ORDER BY name ASC`,
  );

  const [taxes] = await pool.query(
    `SELECT id, description
     FROM item_tax
     WHERE status = 1 AND presence = 1
     ORDER BY id ASC`,
  );

  return {
    categories: categories.map((row) => ({
      id: String(row.id),
      parentId: Number(row.id_parent ?? 0),
      name: row.name ?? '',
    })),
    uoms: uoms.map((row) => ({
      id: String(row.id),
      name: row.name ?? '',
      description: row.description ?? '',
    })),
    taxes: taxes.map((row) => ({
      id: String(row.id),
      description: row.description ?? '',
    })),
  };
}

async function ensureBarcodeAvailability(executor, barcodes, excludedItemId = null) {
  if (!barcodes.length) {
    return;
  }

  const placeholders = barcodes.map(() => '?').join(', ');
  const params = [...barcodes];
  let sql = `SELECT barcode, itemId
             FROM item_barcode
             WHERE presence = 1 AND status = 1
               AND barcode IN (${placeholders})`;

  if (excludedItemId) {
    sql += ' AND itemId <> ?';
    params.push(excludedItemId);
  }

  const [rows] = await executor.query(sql, params);
  if (rows.length > 0) {
    throw new Error(`Barcode already used: ${rows[0].barcode}`);
  }
}

async function insertBarcodes(executor, itemId, barcodes, actorId, timestamp) {
  if (!barcodes.length) {
    return;
  }

  const [idRows] = await executor.query(
    `SELECT COALESCE(MAX(id), 0) AS maxId
     FROM item_barcode`,
  );

  let nextId = Number(idRows[0]?.maxId ?? 0) + 1;
  const values = barcodes.map((barcode) => [
    nextId++,
    itemId,
    barcode,
    1,
    1,
    actorId,
    timestamp,
    actorId,
    timestamp,
  ]);

  await executor.query(
    `INSERT INTO item_barcode
       (id, itemId, barcode, status, presence, inputBy, inputDate, updateBy, updateDate)
     VALUES ?`,
    [values],
  );
}

async function createItem(payload, actorId) {
  const connection = await pool.getConnection();
  const numericActorId = normalizeActorId(actorId);
  const timestamp = toUnixTimestamp();
  const barcodes = normalizeBarcodes(payload.barcodes);

  try {
    await connection.beginTransaction();

    const existing = await getItemById(payload.id, connection);
    if (existing) {
      throw new Error('Item ID already exists');
    }

    await ensureBarcodeAvailability(connection, barcodes);

    await connection.query(
      `INSERT INTO item
         (id, description, shortDesc, priceFlag, ppnFlag, price1, itemUomId, itemCategoryId, itemTaxId, images, presence, status, inputBy, inputDate, updateBy, updateDate)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1, ?, ?, ?, ?, ?)`,
      [
        payload.id,
        payload.description,
        payload.shortDesc || payload.description,
        payload.priceFlag,
        payload.ppnFlag,
        payload.price1,
        payload.itemUomId,
        payload.itemCategoryId,
        payload.itemTaxId,
        payload.images || null,
        payload.status,
        numericActorId,
        timestamp,
        numericActorId,
        timestamp,
      ],
    );

    await insertBarcodes(connection, payload.id, barcodes, numericActorId, timestamp);
    await connection.commit();
  } catch (err) {
    await connection.rollback();
    throw err;
  } finally {
    connection.release();
  }

  return getItemById(payload.id);
}

async function updateItem(itemId, payload, actorId) {
  const connection = await pool.getConnection();
  const numericActorId = normalizeActorId(actorId);
  const timestamp = toUnixTimestamp();
  const barcodes = normalizeBarcodes(payload.barcodes);

  try {
    await connection.beginTransaction();

    const current = await getItemById(itemId, connection);
    if (!current) {
      throw new Error('Item not found');
    }

    await ensureBarcodeAvailability(connection, barcodes, itemId);

    await connection.query(
      `UPDATE item
       SET description = ?,
           shortDesc = ?,
           priceFlag = ?,
           ppnFlag = ?,
           price1 = ?,
           itemUomId = ?,
           itemCategoryId = ?,
           itemTaxId = ?,
           images = ?,
           status = ?,
           updateBy = ?,
           updateDate = ?
       WHERE id = ? AND presence = 1`,
      [
        payload.description,
        payload.shortDesc || payload.description,
        payload.priceFlag,
        payload.ppnFlag,
        payload.price1,
        payload.itemUomId,
        payload.itemCategoryId,
        payload.itemTaxId,
        payload.images || null,
        payload.status,
        numericActorId,
        timestamp,
        itemId,
      ],
    );

    await connection.query(
      `UPDATE item_barcode
       SET status = 0,
           presence = 0,
           updateBy = ?,
           updateDate = ?
       WHERE itemId = ? AND presence = 1`,
      [numericActorId, timestamp, itemId],
    );

    await insertBarcodes(connection, itemId, barcodes, numericActorId, timestamp);
    await connection.commit();
  } catch (err) {
    await connection.rollback();
    throw err;
  } finally {
    connection.release();
  }

  return getItemById(itemId);
}

async function deleteItem(itemId, actorId) {
  const connection = await pool.getConnection();
  const numericActorId = normalizeActorId(actorId);
  const timestamp = toUnixTimestamp();

  try {
    await connection.beginTransaction();

    const current = await getItemById(itemId, connection);
    if (!current) {
      await connection.rollback();
      return false;
    }

    await connection.query(
      `UPDATE item
       SET status = 0,
           presence = 0,
           updateBy = ?,
           updateDate = ?
       WHERE id = ? AND presence = 1`,
      [numericActorId, timestamp, itemId],
    );

    await connection.query(
      `UPDATE item_barcode
       SET status = 0,
           presence = 0,
           updateBy = ?,
           updateDate = ?
       WHERE itemId = ? AND presence = 1`,
      [numericActorId, timestamp, itemId],
    );

    await connection.commit();
    return true;
  } catch (err) {
    await connection.rollback();
    throw err;
  } finally {
    connection.release();
  }
}

module.exports = {
  listItems,
  getItemById,
  getMeta,
  createItem,
  updateItem,
  deleteItem,
};