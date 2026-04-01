const { Router } = require('express');
const cartController = require('../controllers/cart.controller');
const validate = require('../middleware/validate');
const { createCartSchema } = require('../schemas/cart.schema');
const auth = require('../middleware/auth');

const router = Router();

// POST /api/cart/new — create new cart session (kioskUuid)
router.post('/new', auth, validate(createCartSchema), cartController.createCart);

// GET /api/cart/list/:kioskUuid — get cart items + totals (must be before /:kioskUuid)
router.get('/list/:kioskUuid', auth, cartController.listCart);

// POST /api/cart/void/:kioskUuid — verify PIN + hard delete all cart data
router.post('/void/:kioskUuid', auth, cartController.voidCart);

// GET /api/cart/:kioskUuid — get cart session info
router.get('/:kioskUuid', auth, cartController.getCart);

// Buatkan void item post, body isi nya kioskUuid, itemId/barcode, qty, reason
router.post('/voidItem/:kioskUuid', auth, cartController.voidCartItem);


module.exports = router;
