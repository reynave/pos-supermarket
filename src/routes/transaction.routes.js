const { Router } = require('express');
const transactionController = require('../controllers/transaction.controller');
const auth = require('../middleware/auth');
const validate = require('../middleware/validate');
const { createTransactionSchema } = require('../schemas/transaction.schema');

const router = Router();

// GET /api/transactions?date=YYYY-MM-DD&page=1&limit=20 — list transactions
router.get('/', auth, transactionController.listTransactions);

// GET /api/transactions/:id/print-txt?template=bill.hbs — rendered receipt template as text/plain for printer
router.get('/:id/print-txt', auth, transactionController.getTransactionPrintText);

// GET /api/transactions/:id — get one transaction for receipt/reprint
router.get('/:id', auth, transactionController.getTransactionById);

// POST /api/transactions — create a new transaction from cart
router.post('/', auth, validate(createTransactionSchema), transactionController.createTransaction);

module.exports = router;
