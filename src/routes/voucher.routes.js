const { Router } = require('express');
const auth = require('../middleware/auth');
const voucherController = require('../controllers/voucher.controller');

const router = Router();

// GET /api/voucher/:voucherCode
router.get('/:voucherCode', auth, voucherController.validateVoucher);

// POST /api/voucher/use
router.post('/use', auth, voucherController.useVoucher);

module.exports = router;
