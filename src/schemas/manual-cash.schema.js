const { z } = require('zod');

const addManualCashSchema = z.object({
  resetId: z.string().optional(),
  terminalId: z.string().optional(),
  amount: z.number().positive(),
});

const openDrawerSchema = z.object({
  terminalId: z.string().optional(),
});

module.exports = {
  addManualCashSchema,
  openDrawerSchema,
};
