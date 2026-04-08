const { Router } = require('express');
const auth = require('../middleware/auth');
const printController = require('../controllers/print.controller');

const router = Router();

// POST /api/print/transaction/:transactionId/log
router.post('/transaction/:transactionId/log', auth, printController.createTransactionPrintLog);

module.exports = router;
