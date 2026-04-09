const { generateAutoNumber } = require('../utils/autoNumber');
const { success, error } = require('../utils/response');

/**
 * GET /api/auto-number/generate/:name
 * DEV/TEST ONLY — disabled in production.
 *
 * Generate and consume the next sequential code for the given auto_number name.
 * Each call permanently increments the running number.
 *
 * Params:
 *   name — value of auto_number.name (e.g. 'voucherCode', 'reset', 'pos')
 *
 * Response:
 *   { name, code, runningNumber }
 */
async function generateCode(req, res, next) {
  try {
    const { name } = req.params;

    if (!name || !name.trim()) {
      return error(res, 'name param is required', 400);
    }

    const code = await generateAutoNumber(name.trim());

    return success(res, { name: name.trim(), code }, `Generated code for '${name.trim()}'`);
  } catch (err) {
    if (err.message && err.message.includes('not found')) {
      return error(res, err.message, 404);
    }
    next(err);
  }
}

module.exports = { generateCode };
