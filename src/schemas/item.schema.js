const { z } = require('zod');

const searchItemSchema = z.object({
  q: z
    .string({ required_error: 'Search query is required' })
    .min(1, 'Search query is required'),
});

const addByBarcodeSchema = z.object({
  kioskUuid: z.string({ required_error: 'kioskUuid is required' }).min(1, 'kioskUuid is required'),
  barcode: z.string({ required_error: 'barcode is required' }).min(1, 'barcode is required'),
});

const addByItemIdSchema = z.object({
  kioskUuid: z.string({ required_error: 'kioskUuid is required' }).min(1, 'kioskUuid is required'),
  itemId: z.string({ required_error: 'itemId is required' }).min(1, 'itemId is required'),
});

module.exports = { searchItemSchema, addByBarcodeSchema, addByItemIdSchema };
