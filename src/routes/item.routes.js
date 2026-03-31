const { Router } = require('express');
const itemController = require('../controllers/item.controller');
const auth = require('../middleware/auth');
const validate = require('../middleware/validate');
const { addByBarcodeSchema, addByItemIdSchema } = require('../schemas/item.schema');

const router = Router();

// GET /api/item/search?q=keyword (protected — must be before /:id)
router.get('/search', /*auth, */ itemController.search);

// POST /api/item/barcode (protected) — add item to cart by barcode
router.post('/barcode', /*auth, */ validate(addByBarcodeSchema), itemController.addByBarcode);

// POST /api/item/add (protected) — add item to cart by itemId
router.post('/add', /*auth, */ validate(addByItemIdSchema), itemController.addByItemId);

module.exports = router;
