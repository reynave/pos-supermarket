const { z } = require('zod');

const toInt = (value) => {
  if (typeof value === 'number') return Math.trunc(value);
  if (typeof value === 'string' && value.trim() !== '') {
    const parsed = Number(value);
    if (!Number.isNaN(parsed)) return Math.trunc(parsed);
  }
  return value;
};

const bcaLanPaymentSchema = z.object({
  paymentTypeId: z.string().optional(),
  ip: z.string().min(1, 'ip is required when paymentTypeId is not provided').optional(),
  port: z.string().optional(),
  amount: z.preprocess(
    toInt,
    z.number({ required_error: 'amount is required' }).int('amount must be integer').min(0, 'amount must be >= 0'),
  ),
  transType: z.string().length(2, 'transType must be 2 chars').optional(),
  reffNumber: z.string().max(12, 'reffNumber max length is 12').optional(),
  timeoutMs: z.preprocess(
    toInt,
    z.number().int('timeoutMs must be integer').positive('timeoutMs must be > 0').optional(),
  ),
}).superRefine((body, ctx) => {
  if (!body.paymentTypeId && !body.ip) {
    ctx.addIssue({
      code: z.ZodIssueCode.custom,
      message: 'Either paymentTypeId or ip is required',
      path: ['ip'],
    });
  }
});

const bcaLanEchoSchema = z.object({
  paymentTypeId: z.string().optional(),
  ip: z.string().min(1, 'ip is required when paymentTypeId is not provided').optional(),
  port: z.string().optional(),
  timeoutMs: z.preprocess(
    toInt,
    z.number().int('timeoutMs must be integer').positive('timeoutMs must be > 0').optional(),
  ),
});

module.exports = {
  bcaLanPaymentSchema,
  bcaLanEchoSchema,
};
