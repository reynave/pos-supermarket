const itemService = require('../services/item.service');
const { success, error } = require('../utils/response');

/**
 * POST /api/item/barcode
 * Add item to kiosk_cart by barcode scan.
 * Body: { kioskUuid, barcode }
 */
async function addByBarcode(req, res, next) {
  try {
    const { kioskUuid, barcode } = req.body;

    // Validate kioskUuid exists
    const kiosk = await itemService.findKioskUuid(kioskUuid);
    if (!kiosk) {
      return error(res, 'Invalid kioskUuid', 404);
    }

    // Lookup item by barcode
    const item = await itemService.findByBarcode(barcode);
    if (!item) {
      return error(res, 'Item not found for this barcode', 404);
    }

    // Insert into kiosk_cart
    const cartId = await itemService.addToCart(kioskUuid, item, barcode);

    // Get all barcodes for this item
    const barcodes = await itemService.getBarcodesByItemId(item.id);

    return success(res, {
      cartId,
      kioskUuid,
      ...item,
      barcodes,
    });
  } catch (err) {
    next(err);
  }
}

/**
 * POST /api/item/add
 * Add item to kiosk_cart by itemId.
 * Body: { kioskUuid, itemId }
 */
async function addByItemId(req, res, next) {
  try {
    const { kioskUuid, itemId } = req.body;

    // Validate kioskUuid exists
    const kiosk = await itemService.findKioskUuid(kioskUuid);
    if (!kiosk) {
      return error(res, 'Invalid kioskUuid', 404);
    }

    // Lookup item by id
    const item = await itemService.findById(itemId);
    if (!item) {
      return error(res, 'Item not found', 404);
    }

    // Insert into kiosk_cart
    const cartId = await itemService.addToCart(kioskUuid, item, null);

    // Get all barcodes for this item
    const barcodes = await itemService.getBarcodesByItemId(item.id);

    return success(res, {
      cartId,
      kioskUuid,
      ...item,
      barcodes,
    });
  } catch (err) {
    next(err);
  }
}

/**
 * POST /api/item/add-qty
 * Duplicate selected item rows to kiosk_cart based on qty.
 * Body: { kioskUuid, itemId, barcode?, qty }
 */
async function addQtyBySelected(req, res, next) {
  try {
    const { kioskUuid, itemId, barcode, qty } = req.body;

    const kiosk = await itemService.findKioskUuid(kioskUuid);
    if (!kiosk) {
      return error(res, 'Invalid kioskUuid', 404);
    }

    const item = await itemService.findById(itemId);
    if (!item) {
      return error(res, 'Item not found', 404);
    }

    const result = await itemService.addQtyBySelected(kioskUuid, item, barcode, qty);

    return success(res, {
      kioskUuid,
      itemId,
      qty,
      insertedCount: result.insertedCount,
    }, 'Item quantity added successfully');
  } catch (err) {
    next(err);
  }
}

/**
 * GET /api/item/search?q=keyword
 * Search items by description.
 */
async function search(req, res, next) {
  try {
    const { q } = req.query;

    if (!q || q.trim().length === 0) {
      return error(res, 'Search query is required', 400);
    }

    const items = await itemService.searchByDescription(q.trim());

    return success(res, {
      count: items.length,
      items,
    });
  } catch (err) {
    next(err);
  }
}

module.exports = {
  addByBarcode,
  addByItemId,
  addQtyBySelected,
  search,
};
