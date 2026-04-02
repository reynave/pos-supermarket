const { Router } = require('express');
const auth = require('../middleware/auth');
const validate = require('../middleware/validate');
const manualCashController = require('../controllers/manual-cash.controller');
const { addManualCashSchema, openDrawerSchema } = require('../schemas/manual-cash.schema');

const router = Router();

router.get('/history', auth, manualCashController.getHistory);
router.get('/summary', auth, manualCashController.getSummary);
router.get('/summary/:terminalId', auth, manualCashController.getSummary);
router.post('/add', auth, validate(addManualCashSchema), manualCashController.addCashIn);
router.post('/open-drawer', auth, validate(openDrawerSchema), manualCashController.openDrawer);

module.exports = router;
