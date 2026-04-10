const { Router } = require('express');
const itemsAdminController = require('../controllers/items-admin.controller');
const auth = require('../middleware/auth');
const validate = require('../middleware/validate');
const { createItemSchema, updateItemSchema } = require('../schemas/items-admin.schema');

const router = Router();

router.get('/meta', auth, itemsAdminController.getMeta);
router.get('/', auth, itemsAdminController.listItems);
router.get('/:id', auth, itemsAdminController.getItemById);
router.post('/', auth, validate(createItemSchema), itemsAdminController.createItem);
router.put('/:id', auth, validate(updateItemSchema), itemsAdminController.updateItem);
router.delete('/:id', auth, itemsAdminController.deleteItem);

module.exports = router;