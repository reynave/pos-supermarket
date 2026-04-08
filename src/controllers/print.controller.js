const printService = require('../services/print.service');
const transactionService = require('../services/transaction.service');
const { success, error } = require('../utils/response');

/**
 * POST /api/print/transaction/:transactionId/log
 * Record print action into transaction_printlog.
 */
async function createTransactionPrintLog(req, res, next) {
  try {
    const { transactionId } = req.params;

    if (!transactionId) {
      return error(res, 'transactionId is required', 400);
    }

    const trx = await transactionService.getTransactionById(transactionId, {
      includeReceiptHtml: false,
      templateName: 'bill.hbs',
    });

    if (!trx) {
      return error(res, 'Transaction not found', 404);
    }

    let inputBy = req.user?.userId || req.user?.id || null;
    if (!inputBy || inputBy === 'dev-user') {
      inputBy = trx.transaction?.cashierId || null;
    }

    const log = await printService.createPrintLog(transactionId, inputBy);

    return success(res, log, 'Print log recorded', 201);
  } catch (err) {
    next(err);
  }
}

module.exports = {
  createTransactionPrintLog,
};
