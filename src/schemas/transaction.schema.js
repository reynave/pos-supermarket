const { z } = require('zod');

const paymentSchema = z.object({
  paymentTypeId: z.string().min(1, 'paymentTypeId is required'),
  amount: z.number().min(0),
  reference: z.string().optional().default(''),
  approvedCode: z.string().optional().default(''),
});

const createTransactionSchema = z.object({
  body: z.object({
    kioskUuid: z.string().min(1, 'kioskUuid is required'),
    terminalId: z.string().min(1, 'terminalId is required'),
    settlementId: z.string().min(1, 'settlementId is required'),
    payments: z.array(paymentSchema).min(1, 'At least one payment is required'),
    cashReceived: z.number().optional(),
  }),
});

module.exports = {
  createTransactionSchema,
};
