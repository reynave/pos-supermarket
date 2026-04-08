const { Router } = require('express');
const paymentController = require('../controllers/payment.controller');
const auth = require('../middleware/auth');
const validate = require('../middleware/validate');
const {
  addPaymentSchema,
  removePaymentSchema,
  completePaymentSchema,
  updatePaymentTypeSchema,
} = require('../schemas/payment.schema');

const router = Router();

// GET /api/payment/types — list available payment types
router.get('/types', auth, paymentController.getPaymentTypes);

// GET /api/payment/types/all — list payment types for settings page (presence=1)
router.get('/types/all', auth, paymentController.getAllPaymentTypes);

// GET /api/payment/types/:id — get payment type detail
router.get('/types/:id', auth, paymentController.getPaymentTypeDetail);

// PUT /api/payment/types/:id — update payment type detail
router.put('/types/:id', auth, validate(updatePaymentTypeSchema), paymentController.updatePaymentTypeDetail);

// GET /api/payment/pending/:kioskUuid — get pending payment entries for a cart
router.get('/pending/:kioskUuid', auth, paymentController.getPendingPayments);

// POST /api/payment/add — add a payment entry to kiosk_paid_pos
router.post('/add', auth, validate(addPaymentSchema), paymentController.addPayment);

// DELETE /api/payment/:id — remove a payment entry
router.delete('/:id', auth, validate(removePaymentSchema), paymentController.removePayment);

// POST /api/payment/complete — finalize transaction from kiosk_paid_pos
router.post('/complete', auth, validate(completePaymentSchema), paymentController.completePayment);

module.exports = router;
