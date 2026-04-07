const pool = require('../config/database');

const DAY_TO_COLUMN = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

function toNumber(value) {
  const num = Number(value);
  return Number.isFinite(num) ? num : 0;
}

function roundMoney(value) {
  return Math.round((toNumber(value) + Number.EPSILON) * 100) / 100;
}

function applyCascadingDiscount(price, disc1 = 0, disc2 = 0, disc3 = 0) {
  let current = toNumber(price);
  for (const disc of [disc1, disc2, disc3]) {
    const percent = Math.max(0, toNumber(disc));
    if (percent <= 0) continue;
    current = current - (current * percent / 100);
  }
  return Math.max(0, roundMoney(current));
}

async function getNextItemQtyInCart(kioskUuid, itemId) {
  const [rows] = await pool.query(
    `SELECT COUNT(*) AS qty
     FROM kiosk_cart
     WHERE kioskUuid = ?
       AND itemId = ?
       AND presence = 1
       AND void = 0`,
    [kioskUuid, itemId]
  );

  const qty = Number(rows[0]?.qty || 0);
  return qty + 1;
}

async function findPromotionItemRule({ itemId, qtyInCartNext, storeOutletId }) {
  const dayColumn = DAY_TO_COLUMN[new Date().getDay()] || 'Mon';
  const outletId = storeOutletId || '';

  const [detailRows] = await pool.query(
    `SELECT
       pi.promotionId,
       pi.id AS promotionItemId,
       pi.qtyFrom,
       pi.qtyTo,
       pi.specialPrice,
       pi.disc1,
       pi.disc2,
       pi.disc3,
       pi.discountPrice
     FROM promotion_item pi
     WHERE pi.status = 1 AND pi.presence = 1
       AND pi.itemId = ?
       AND ? BETWEEN pi.qtyFrom AND pi.qtyTo
     ORDER BY pi.id ASC`,
    [itemId, qtyInCartNext]
  );

  if (!detailRows.length) {
    return null;
  }

  const promotionIds = [...new Set(detailRows.map((row) => row.promotionId))];
  const placeholders = promotionIds.map(() => '?').join(', ');

  const [headerRows] = await pool.query(
    `SELECT
       p.id,
       p.description AS promotionDescription,
       p.discountPercent,
       p.discountAmount,
       p.storeOutlesId,
       p.startDate
     FROM promotion p
     WHERE p.id IN (${placeholders})
       AND p.typeOfPromotion IN ('promotion_item', 'promotion_discount')
       AND p.status = 1 AND p.presence = 1
       AND (p.startDate IS NULL OR p.startDate <= NOW())
       AND (p.endDate IS NULL OR p.endDate >= NOW())
       AND COALESCE(p.${dayColumn}, 0) = 1
       AND (
         p.storeOutlesId IS NULL OR p.storeOutlesId = '' OR p.storeOutlesId = ?
       )`,
    [...promotionIds, outletId]
  );

  if (!headerRows.length) {
    return null;
  }

  const headerById = new Map(headerRows.map((row) => [row.id, row]));

  const candidates = detailRows
    .map((detail) => {
      const header = headerById.get(detail.promotionId);
      if (!header) return null;
      return {
        ...detail,
        promotionDescription: header.promotionDescription,
        discountPercent: header.discountPercent,
        discountAmount: header.discountAmount,
        storeOutlesId: header.storeOutlesId,
        startDate: header.startDate,
      };
    })
    .filter(Boolean);

  if (!candidates.length) {
    return null;
  }

  const toMillis = (value) => {
    if (!value) return 0;
    const ts = new Date(value).getTime();
    return Number.isFinite(ts) ? ts : 0;
  };

  candidates.sort((a, b) => {
    const aOutletPriority = a.storeOutlesId === outletId ? 0 : 1;
    const bOutletPriority = b.storeOutlesId === outletId ? 0 : 1;
    if (aOutletPriority !== bOutletPriority) {
      return aOutletPriority - bOutletPriority;
    }

    const dateDiff = toMillis(b.startDate) - toMillis(a.startDate);
    if (dateDiff !== 0) {
      return dateDiff;
    }

    return Number(a.promotionItemId) - Number(b.promotionItemId);
  });

  return candidates[0] || null;
}

function calculatePromotionItemDiscount(price, rule) {
  const basePrice = Math.max(0, toNumber(price));
  if (!rule) {
    return {
      originPrice: roundMoney(basePrice),
      discount: 0,
      finalPrice: roundMoney(basePrice),
      promotionId: null,
      promotionItemId: null,
      appliedPromotion: null,
    };
  }

  const headerPercent = Math.max(0, toNumber(rule.discountPercent));
  const headerAmount = Math.max(0, toNumber(rule.discountAmount));
  const detailDiscountAmount = Math.max(0, toNumber(rule.discountPrice));
  const detailSpecialPrice = Math.max(0, toNumber(rule.specialPrice));
  const detailDisc1 = Math.max(0, toNumber(rule.disc1));
  const detailDisc2 = Math.max(0, toNumber(rule.disc2));
  const detailDisc3 = Math.max(0, toNumber(rule.disc3));

  let finalPrice = basePrice;
  let discount = 0;
  let source = 'none';

  // Priority 1: global promotion header (percent overrides amount)
  if (headerPercent > 0) {
    discount = roundMoney(basePrice * headerPercent / 100);
    finalPrice = roundMoney(basePrice - discount);
    source = 'header_percent';
  } else if (headerAmount > 0) {
    discount = roundMoney(Math.min(basePrice, headerAmount));
    finalPrice = roundMoney(basePrice - discount);
    source = 'header_amount';
  } else {
    // Priority 2: promotion_item detail rule
    if (detailDisc1 > 0 || detailDisc2 > 0 || detailDisc3 > 0) {
      finalPrice = applyCascadingDiscount(basePrice, detailDisc1, detailDisc2, detailDisc3);
      discount = roundMoney(basePrice - finalPrice);
      source = 'detail_percent';
    } else if (detailDiscountAmount > 0) {
      discount = roundMoney(Math.min(basePrice, detailDiscountAmount));
      finalPrice = roundMoney(basePrice - discount);
      source = 'detail_amount';
    } else if (detailSpecialPrice > 0) {
      finalPrice = roundMoney(Math.min(basePrice, detailSpecialPrice));
      discount = roundMoney(basePrice - finalPrice);
      source = 'detail_special_price';
    }
  }

  finalPrice = Math.max(0, roundMoney(finalPrice));
  discount = Math.max(0, roundMoney(Math.min(basePrice, discount)));

  return {
    originPrice: roundMoney(basePrice),
    discount,
    finalPrice,
    promotionId: rule.promotionId,
    promotionItemId: rule.promotionItemId,
    appliedPromotion: {
      promotionId: rule.promotionId,
      promotionItemId: rule.promotionItemId,
      source,
      header: {
        discountPercent: headerPercent,
        discountAmount: headerAmount,
      },
      detail: {
        qtyFrom: Number(rule.qtyFrom || 0),
        qtyTo: Number(rule.qtyTo || 0),
        disc1: detailDisc1,
        disc2: detailDisc2,
        disc3: detailDisc3,
        discountPrice: detailDiscountAmount,
        specialPrice: detailSpecialPrice,
      },
    },
  };
}

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
  const nowDatetime = new Date().toISOString().slice(0, 19).replace('T', ' ');

  const kiosk   = await findKioskUuid(kioskUuid);
  const nextQty = await getNextItemQtyInCart(kioskUuid, item.id);
  const rule    = await findPromotionItemRule({
    itemId: item.id,
    qtyInCartNext: nextQty,
    storeOutletId: kiosk?.storeOutlesId || null,
  });
  const pricing = calculatePromotionItemDiscount(item.price1 || 0, rule);

  const [result] = await pool.query(
    `INSERT INTO kiosk_cart
       (kioskUuid, promotionId, promotionItemId, itemId, barcode, originPrice, discount, price, presence, inputDate, updateDate)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1, ?, ?)`,
    [
      kioskUuid,
      pricing.promotionId,
      pricing.promotionItemId,
      item.id,
      barcode || null,
      pricing.originPrice,
      pricing.discount,
      pricing.finalPrice,
      nowDatetime,
      nowDatetime,
    ]
  );
  return {
    cartId: result.insertId,
    pricing,
  };
}

/**
 * Duplicate selected item into kiosk_cart based on qty.
 * Inserts one row per qty, preserving selected item id/barcode and current item price.
 */
async function addQtyBySelected(kioskUuid, item, barcode, qty) {
  const nowDatetime = new Date().toISOString().slice(0, 19).replace('T', ' ');
  const kiosk = await findKioskUuid(kioskUuid);
  const values = [];
  const appliedPromotions = [];

  const [countRows] = await pool.query(
    `SELECT COUNT(*) AS qty
     FROM kiosk_cart
     WHERE kioskUuid = ? AND itemId = ? AND presence = 1 AND void = 0`,
    [kioskUuid, item.id]
  );

  let runningQty = Number(countRows[0]?.qty || 0);

  for (let i = 0; i < qty; i += 1) {
    runningQty += 1;
    const rule = await findPromotionItemRule({
      itemId: item.id,
      qtyInCartNext: runningQty,
      storeOutletId: kiosk?.storeOutlesId || null,
    });
    const pricing = calculatePromotionItemDiscount(item.price1 || 0, rule);

    values.push([
      kioskUuid,
      pricing.promotionId,
      pricing.promotionItemId,
      item.id,
      barcode || null,
      pricing.originPrice,
      pricing.discount,
      pricing.finalPrice,
      1,
      nowDatetime,
      nowDatetime,
    ]);

    if (pricing.appliedPromotion) {
      appliedPromotions.push(pricing.appliedPromotion);
    }
  }

  const [result] = await pool.query(
    `INSERT INTO kiosk_cart
       (kioskUuid, promotionId, promotionItemId, itemId, barcode, originPrice, discount, price, presence, inputDate, updateDate)
     VALUES ?`,
    [values]
  );

  return {
    insertedCount: Number(result.affectedRows || 0),
    firstInsertId: result.insertId || null,
    appliedPromotions,
  };
}

module.exports = {
  findKioskUuid,
  findByBarcode,
  findById,
  searchByDescription,
  getBarcodesByItemId,
  addToCart,
  addQtyBySelected,
};
