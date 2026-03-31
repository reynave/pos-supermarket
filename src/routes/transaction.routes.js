const { Router } = require('express');
const transactionController = require('../controllers/transaction.controller');
const auth = require('../middleware/auth');
const validate = require('../middleware/validate');
const { createTransactionSchema } = require('../schemas/transaction.schema');

const router = Router();

// GET /api/transactions?date=YYYY-MM-DD&page=1&limit=20 — list transactions
router.get('/', auth, transactionController.listTransactions);

// POST /api/transactions — create a new transaction from cart
router.post('/', /*auth,*/ validate(createTransactionSchema), transactionController.createTransaction);

module.exports = router;
