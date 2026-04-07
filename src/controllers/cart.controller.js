const cartService = require('../services/cart.service');
const crypto = require('crypto');
const { success, error } = require('../utils/response');

/**
 * POST /api/cart/new
 * Create a new cart session (kioskUuid).
 * Body: { cashierId, terminalId, storeOutletId? }
 */
async function createCart(req, res, next) {
  try {
    const { cashierId, terminalId, storeOutletId } = req.body;

    // Generate new kioskUuid
    const kioskUuid = await cartService.generateKioskUuid(terminalId);

    // Insert into kiosk_uuid table
    const record = await cartService.createKioskUuid(kioskUuid, cashierId, terminalId, storeOutletId);

    if (!record) {
      return error(res, 'Failed to create cart session', 500);
    }

    return success(res, record, 'Cart session created');
  } catch (err) {
    next(err);
  }
}

/**
 * GET /api/cart/:kioskUuid
 * Get existing cart session info.
 */
async function getCart(req, res, next) {
  try {
    const { kioskUuid } = req.params;

    const record = await cartService.findByKioskUuid(kioskUuid);
    if (!record) {
      return error(res, 'Cart session not found', 404);
    }

    return success(res, record);
  } catch (err) {
    next(err);
  }
}

/**
 * GET /api/cart/list/:kioskUuid
 * Get cart items with header totals (subtotal, tax, grandTotal).
 */
async function listCart(req, res, next) {
  try {
    const { kioskUuid } = req.params;

    // Verify kiosk session exists
    const session = await cartService.findByKioskUuid(kioskUuid);
    if (!session) {
      return error(res, 'Cart session not found', 404);
    }

    // Get aggregated cart items
    const rows = await cartService.listCartItems(kioskUuid);

    const PPN_RATE = 11; // PPN Indonesia 11%

    const items = rows.map((row) => {
      const hasTax = row.ppnFlag === 1 || String(row.itemTaxId) === '2';
      const taxAmount = hasTax ? row.totalPrice * (PPN_RATE / 100) : 0;

      return {
        itemId: row.itemId,
        promotionId: row.promotionId || null,
        promotionItemId: row.promotionItemId || null,
        promotionName: row.promotionName || null,
        name: row.description || row.shortDesc || '',
        barcode: row.barcode || row.itemId,
        qty: row.qty,
        price: row.price || 0,
        discount: row.totalDiscount || 0,
        tax: Math.round(taxAmount),
        total: row.totalPrice || 0,
        uom: row.itemUomId || 'Pcs',
        imageUrl: row.images || null,
      };
    });

    const subtotal = items.reduce((sum, i) => sum + i.total, 0);
    const tax = items.reduce((sum, i) => sum + i.tax, 0);
    const grandTotal = subtotal + tax;
    const itemCount = items.reduce((sum, i) => sum + i.qty, 0);

    return success(res, {
      kioskUuid,
      session,
      items,
      itemCount,
      subtotal,
      tax,
      grandTotal,
    });
  } catch (err) {
    next(err);
  }
}

/**
 * POST /api/cart/void/:kioskUuid
 * Verify supervisor PIN, then hard delete all cart data.
 * Body: { pin }
 */
async function voidCart(req, res, next) {
  try {
    const { kioskUuid } = req.params;
    const { pin } = req.body;
    const pinMd5 = pin ? crypto.createHash('md5').update(pin).digest('hex') : '';
    console.log(`[Cart Void] kioskUuid=${kioskUuid}, pinMd5=${pinMd5}`);
    if (!pin) {
      return error(res, 'Verification PIN is required', 400);
    }

    // Verify PIN against user_pin table
    const pinRecord = await cartService.verifyPin(pin);
    if (!pinRecord) {
      return error(res, 'Invalid verification PIN', 401);
    }

    // Verify session exists
    const session = await cartService.findByKioskUuid(kioskUuid);
    if (!session) {
      return error(res, 'Cart session not found', 404);
    }

    await cartService.deleteCartByKioskUuid(kioskUuid);

    return success(res, { kioskUuid, authorizedBy: pinRecord.userId }, 'Cart voided successfully');
  } catch (err) {
    next(err);
  }
}

/**
 * POST /api/cart/voidItem/:kioskUuid
 * Body: { itemId, barcode, qty, reason }
 * Remove (void) qty of an item from the cart session
 */
async function voidCartItem(req, res, next) {
  try {
    const { kioskUuid } = req.params;
    const { itemId, barcode, qty, reason } = req.body;
    if (!itemId && !barcode) {
      return error(res, 'itemId or barcode is required', 400);
    }
    if (!qty || qty < 1) {
      return error(res, 'qty must be at least 1', 400);
    }
    // Find session
    const session = await cartService.findByKioskUuid(kioskUuid);
    if (!session) {
      return error(res, 'Cart session not found', 404);
    }
    // Void item(s)
    const result = await cartService.voidCartItem(kioskUuid, itemId, barcode, qty, reason);
    if (!result) {
      return error(res, 'Failed to void item', 500);
    }
    return success(res, { kioskUuid, itemId, barcode, qty }, 'Item voided');
  } catch (err) {
    next(err);
  }
}

module.exports = {
  createCart,
  getCart,
  listCart,
  voidCart,
  voidCartItem,
};
