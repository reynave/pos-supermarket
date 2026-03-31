const { z } = require('zod');

const createCartSchema = z.object({
  cashierId: z.string({ required_error: 'cashierId is required' }).min(1, 'cashierId is required'),
  terminalId: z.string({ required_error: 'terminalId is required' }).min(1, 'terminalId is required'),
  storeOutletId: z.string().optional(),
});

module.exports = { createCartSchema };
