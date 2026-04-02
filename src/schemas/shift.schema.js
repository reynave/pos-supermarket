const { z } = require('zod');

const openShiftSchema = z.object({
  openingBalance: z.number().min(0).default(0),
  terminalId: z.string().optional(),
});

module.exports = { openShiftSchema };
