const { z } = require('zod');

const cashDeclarationSchema = z.object({
  denom_100k: z.number().int().nonnegative().default(0),
  denom_50k: z.number().int().nonnegative().default(0),
  denom_20k: z.number().int().nonnegative().default(0),
  denom_10k: z.number().int().nonnegative().default(0),
  denom_5k: z.number().int().nonnegative().default(0),
  denom_2k: z.number().int().nonnegative().default(0),
  denom_1k: z.number().int().nonnegative().default(0),
  coins_other: z.number().int().nonnegative().default(0),
});

const dailyCloseSubmitSchema = z.object({
  terminalId: z.string().optional(),
  physicalCash: z.number().optional(),
  notes: z.string().optional(),
  note: z.string().optional(),
  cashDeclaration: cashDeclarationSchema.optional(),
});

module.exports = {
  dailyCloseSubmitSchema,
};
