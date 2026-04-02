const paymentService = require('../services/payment.service');
const transactionService = require('../services/transaction.service');
const itemService = require('../services/item.service');
const { success, error } = require('../utils/response');

/**
 * GET /api/payment/types
 * List available payment types.
 */
async function getPaymentTypes(req, res, next) {
  try {
    const types = await paymentService.getPaymentTypes();
    return success(res, types);
  } catch (err) {
    next(err);
  }
}

/**
 * GET /api/payment/pending/:kioskUuid
 * Get all pending (not yet finalized) payment entries for a cart.
 */
async function getPendingPayments(req, res, next) {
  try {
    const { kioskUuid } = req.params;
    const payments = await paymentService.getPendingPayments(kioskUuid);
    const totalPaid = payments.reduce((sum, p) => sum + Number(p.paid), 0);
    return success(res, { payments, totalPaid });
  } catch (err) {
    next(err);
  }
}

/**
 * POST /api/payment/add
 * Add one payment entry to kiosk_paid_pos.
 * Body: { kioskUuid, paymentTypeId, paid, reference?, approvedCode? }
 */
async function addPayment(req, res, next) {
  try {
    const { kioskUuid, paymentTypeId, paid, reference, approvedCode } = req.body;

    // Validate kiosk session
    const kiosk = await itemService.findKioskUuid(kioskUuid);
    if (!kiosk) return error(res, 'Invalid kioskUuid', 404);

    const id = await paymentService.addPayment({
      kioskUuid,
      paymentTypeId,
      paid: Number(paid),
      reference,
      approvedCode,
    });

    const payments = await paymentService.getPendingPayments(kioskUuid);
    const totalPaid = payments.reduce((sum, p) => sum + Number(p.paid), 0);

    return success(res, { id, payments, totalPaid }, 'Payment added');
  } catch (err) {
    next(err);
  }
}

/**
 * DELETE /api/payment/:id
 * Remove a specific payment entry.
 * Query: ?kioskUuid=xxx
 */
async function removePayment(req, res, next) {
  try {
    const { id } = req.params;
    const { kioskUuid } = req.body;

    if (!kioskUuid) return error(res, 'kioskUuid is required', 400);

    const removed = await paymentService.removePayment(Number(id), kioskUuid);
    if (!removed) return error(res, 'Payment entry not found', 404);

    const payments = await paymentService.getPendingPayments(kioskUuid);
    const totalPaid = payments.reduce((sum, p) => sum + Number(p.paid), 0);

    return success(res, { payments, totalPaid }, 'Payment removed');
  } catch (err) {
    next(err);
  }
}

/**
 * POST /api/payment/complete
 * Finalize payment: validate total paid >= grand total, then create transaction.
 * Body: { kioskUuid, terminalId, resetId?, settlementId?, cashReceived? }
 */
async function completePayment(req, res, next) {
  try {
    const { kioskUuid, terminalId, resetId, settlementId, cashReceived } = req.body;

    // Validate kiosk session
    const kiosk = await itemService.findKioskUuid(kioskUuid);
    if (!kiosk) return error(res, 'Invalid kioskUuid', 404);

    // Load pending payments
    const pendingPayments = await paymentService.getPendingPayments(kioskUuid);
    if (!pendingPayments.length) return error(res, 'No payment entries found', 400);

    // Total paid check is enforced downstream in createTransaction via grandTotal
    const payments = pendingPayments.map((p) => ({
      paymentTypeId: p.paymentTypeId,
      amount: Number(p.paid),
      reference: p.refCode || '',
      approvedCode: p.approvedCode || '',
    }));

    const transaction = await transactionService.createTransaction({
      kioskUuid,
      cashierId: kiosk.cashierId,
      terminalId: terminalId || kiosk.terminalId,
      resetId: resetId || settlementId || null,
      storeOutletId: kiosk.storeOutlesId,
      payments,
      cashReceived: cashReceived ? Number(cashReceived) : undefined,
    });

    // Clean up kiosk_paid_pos after successful transaction
    await require('../config/database').query(
      'DELETE FROM kiosk_paid_pos WHERE kioskUuid = ?',
      [kioskUuid],
    );

    return success(res, transaction, 'Payment complete');
  } catch (err) {
    next(err);
  }
}

module.exports = {
  getPaymentTypes,
  getPendingPayments,
  addPayment,
  removePayment,
  completePayment,
};
