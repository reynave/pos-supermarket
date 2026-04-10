const { z } = require('zod');

const barcodeValueSchema = z
  .string({ required_error: 'barcode is required' })
  .trim()
  .min(1, 'barcode is required')
  .max(50, 'barcode is too long');

const itemBarcodesSchema = z
  .array(barcodeValueSchema)
  .min(1, 'At least one barcode is required')
  .superRefine((barcodes, ctx) => {
    const normalized = new Set();

    for (const [index, barcode] of barcodes.entries()) {
      const key = barcode.trim().toLowerCase();
      if (normalized.has(key)) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          path: [index],
          message: 'Barcode must be unique',
        });
      }
      normalized.add(key);
    }
  });

const baseItemSchema = z.object({
  description: z.string({ required_error: 'description is required' }).trim().min(1, 'description is required').max(250),
  shortDesc: z.string().trim().max(250).optional().nullable().transform((value) => value ?? ''),
  price1: z.coerce.number({ required_error: 'price1 is required' }).min(0, 'price1 must be zero or greater'),
  itemUomId: z.string({ required_error: 'itemUomId is required' }).trim().min(1, 'itemUomId is required').max(50),
  itemCategoryId: z.union([z.string(), z.number()]).transform((value) => String(value).trim()).pipe(
    z.string().min(1, 'itemCategoryId is required').max(50),
  ),
  itemTaxId: z.union([z.string(), z.number()]).transform((value) => String(value).trim()).pipe(
    z.string().min(1, 'itemTaxId is required').max(50),
  ),
  images: z.string().trim().optional().nullable().transform((value) => value ?? ''),
  status: z.coerce.number({ required_error: 'status is required' }).int().refine((value) => value === 0 || value === 1, 'status must be 0 or 1'),
  barcodes: itemBarcodesSchema,
});

const createItemSchema = baseItemSchema.extend({
  id: z.string({ required_error: 'id is required' }).trim().min(1, 'id is required').max(50),
});

const updateItemSchema = baseItemSchema;

module.exports = {
  createItemSchema,
  updateItemSchema,
};