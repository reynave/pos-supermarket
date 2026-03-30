const { z } = require('zod');

const loginSchema = z.object({
  userId: z
    .string({ required_error: 'Employee ID is required' })
    .min(1, 'Employee ID is required'),
  password: z.string().optional().default(''),
  terminalId: z.string().optional().default(''),
});

module.exports = { loginSchema };
