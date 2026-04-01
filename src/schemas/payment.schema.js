const { z } = require('zod');

const addPaymentSchema = z.object({
  kioskUuid: z.string().min(1, 'kioskUuid is required'),
  paymentTypeId: z.string().min(1, 'paymentTypeId is required'),
  paid: z
    .number({ required_error: 'paid is required' })
    .int('paid must be an integer')
    .min(1, 'paid must be at least 1'),
  reference: z.string().optional(),
  approvedCode: z.string().optional(),
});

const removePaymentSchema = z.object({
  kioskUuid: z.string().min(1, 'kioskUuid is required'),
});

const completePaymentSchema = z.object({
  kioskUuid: z.string().min(1, 'kioskUuid is required'),
  terminalId: z.string().optional(),
  settlementId: z.string().min(1, 'settlementId is required'),
  cashReceived: z.number().optional(),
});

module.exports = { addPaymentSchema, removePaymentSchema, completePaymentSchema };
