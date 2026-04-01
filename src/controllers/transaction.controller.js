const transactionService = require('../services/transaction.service');
const cartService = require('../services/cart.service');
const { success, error } = require('../utils/response');

/**
 * POST /api/transactions
 * Create a transaction from the current kiosk cart.
 * Body: { kioskUuid, terminalId, settlementId, payments: [{ paymentTypeId, amount, reference? }], cashReceived? }
 */
async function createTransaction(req, res, next) {
  try {
    const { kioskUuid, terminalId, settlementId, payments, cashReceived } = req.body;

    // Verify cart session exists and is active
    const session = await cartService.findByKioskUuid(kioskUuid);
    if (!session) {
      return error(res, 'Cart session not found or already completed', 404);
    }

    const cashierId = session.cashierId;
    const storeOutletId = session.storeOutlesId; // note: typo in DB column name

    const transaction = await transactionService.createTransaction({
      kioskUuid,
      cashierId,
      terminalId,
      settlementId,
      storeOutletId,
      payments,
      cashReceived,
    });

    return success(res, transaction, 'Transaction created');
  } catch (err) {
    next(err);
  }
}

/**
 * GET /api/transactions?date=YYYY-MM-DD&page=1&limit=20
 * List transactions for a given date with pagination.
 */
async function listTransactions(req, res, next) {
  try {
    const { date, page = '1', limit = '20' } = req.query;

    if (!date) {
      return error(res, 'date query parameter is required', 400);
    }

    const result = await transactionService.listTransactions(
      date,
      parseInt(page, 10) || 1,
      parseInt(limit, 10) || 20,
    );

    return success(res, result);
  } catch (err) {
    next(err);
  }
}

/**
 * GET /api/transactions/:id
 * Get one completed transaction for receipt/reprint.
 */
async function getTransactionById(req, res, next) {
  try {
    const { id } = req.params;
    const result = await transactionService.getTransactionById(id);

    if (!result) {
      return error(res, 'Transaction not found', 404);
    }

    return success(res, result);
  } catch (err) {
    next(err);
  }
}

module.exports = {
  createTransaction,
  listTransactions,
  getTransactionById,
};
