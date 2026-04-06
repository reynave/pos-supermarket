const transactionService = require('../services/transaction.service');
const cartService = require('../services/cart.service');
const { success, error } = require('../utils/response');

/**
 * POST /api/transactions
 * Create a transaction from the current kiosk cart.
 * Body: { kioskUuid, terminalId, resetId?, settlementId?, payments: [{ paymentTypeId, amount, reference? }], cashReceived? }
 */
async function createTransaction(req, res, next) {
  try {
    const { kioskUuid, terminalId, resetId, settlementId, payments, cashReceived } = req.body;

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
      resetId: resetId || settlementId || null,
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
    const { date, page = '1', limit = '20', renderReceiptHtml = 'false', template = 'bill.hbs' } = req.query;

    if (!date) {
      return error(res, 'date query parameter is required', 400);
    }

    const result = await transactionService.listTransactions(
      date,
      parseInt(page, 10) || 1,
      parseInt(limit, 10) || 20,
      {
        includeReceiptHtml: String(renderReceiptHtml).toLowerCase() === 'true',
        templateName: template,
      },
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
    const { renderReceiptHtml = 'true', template = 'bill.hbs' } = req.query;
    const result = await transactionService.getTransactionById(id, {
      includeReceiptHtml: String(renderReceiptHtml).toLowerCase() === 'true',
      templateName: template,
    });

    if (!result) {
      return error(res, 'Transaction not found', 404);
    }

    return success(res, result);
  } catch (err) {
    next(err);
  }
}

/**
 * GET /api/transactions/:id/print-txt?template=bill.hbs
 * Get rendered receipt template as plain text for printer channel.
 */
async function getTransactionPrintText(req, res, next) {
  try {
    const { id } = req.params;
    const { template = 'bill.hbs' } = req.query;

    const result = await transactionService.getTransactionById(id, {
      includeReceiptHtml: true,
      templateName: template,
    });

    if (!result) {
      return error(res, 'Transaction not found', 404);
    }

    res.setHeader('Content-Type', 'text/plain; charset=utf-8');
    return res.status(200).send(result.receiptHtml || '');
  } catch (err) {
    next(err);
  }
}

module.exports = {
  createTransaction,
  listTransactions,
  getTransactionById,
  getTransactionPrintText,
};
