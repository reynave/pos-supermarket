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
  resetId: z.string().optional(),
  settlementId: z.string().optional(),
  cashReceived: z.number().optional(),
}).superRefine((body, ctx) => {
  if (!body.resetId && !body.settlementId) {
    ctx.addIssue({
      code: z.ZodIssueCode.custom,
      message: 'resetId is required',
      path: ['resetId'],
    });
  }
});

const updatePaymentTypeSchema = z.object({
  openCashDrawer: z.union([z.literal(0), z.literal(1)]).optional(),
  label: z.string().min(1).optional(),
  name: z.string().min(1).optional(),
  image: z.string().optional(),
  edc: z.number().int().min(0).optional(),
  isLock: z.union([z.literal(0), z.literal(1)]).optional(),
  status: z.union([z.literal(0), z.literal(1)]).optional(),
  presence: z.union([z.literal(0), z.literal(1)]).optional(),
  connectionType: z.enum(['', 'IP', 'COM', 'MANUAL']).optional(),
  com: z.string().optional(),
  ip: z.string().optional(),
  port: z.string().optional(),
  apikey: z.string().optional(),
  mId: z.string().optional(),
  nmId: z.string().optional(),
  merchant: z.string().optional(),
  timeout: z.number().int().min(0).optional(),
  apiUrl: z.string().optional(),
  apiUrlStatus: z.string().optional(),
  inputBy: z.string().optional(),
  updateBy: z.string().optional(),
}).superRefine((body, ctx) => {
  if (Object.keys(body).length === 0) {
    ctx.addIssue({
      code: z.ZodIssueCode.custom,
      message: 'At least one field must be provided for update',
      path: [],
    });
  }
});

module.exports = { addPaymentSchema, removePaymentSchema, completePaymentSchema, updatePaymentTypeSchema };
