const shiftService = require('../services/shift.service');
const { success, error } = require('../utils/response');
const env = require('../config/env');

/**
 * POST /api/shift/open
 * Body: { openingBalance, terminalId? }
 * Auth: required (cashierId from JWT)
 */
async function openShift(req, res, next) {
  try {
    const { openingBalance } = req.body;
    const terminalId = req.body.terminalId || env.TERMINAL_ID;
    const cashierId = String(req.user.userId || req.user.id);
    const storeOutletId = req.user.storeOutlesId || env.STORE_OUTLET_ID;

    // Check if there's already an active daily session.
    const existing = await shiftService.findActiveShift(terminalId);
    if (existing) {
      return success(res, {
        resetId: existing.resetId,
        settlementId: existing.resetId,
        cashierId: existing.cashierId,
        openingBalance: existing.openingBalance,
        terminalId,
        alreadyOpen: true,
      }, 'Shift already active');
    }

    // Generate new resetId
    const resetId = await shiftService.generateResetId();

    // Create daily-start reset row + opening balance
    await shiftService.openShift({
      resetId,
      terminalId,
      cashierId,
      storeOutletId,
      openingBalance: openingBalance || 0,
    });

    return success(res, {
      resetId,
      settlementId: resetId,
      cashierId,
      openingBalance: openingBalance || 0,
      terminalId,
      alreadyOpen: false,
    }, 'Shift opened successfully');
  } catch (err) {
    next(err);
  }
}

/**
 * GET /api/shift/active/:terminalId
 * Check if there's an active shift on this terminal.
 */
async function getActiveShift(req, res, next) {
  try {
    const terminalId = req.params.terminalId || env.TERMINAL_ID;
    const active = await shiftService.findActiveShift(terminalId);

    if (!active) {
      return success(res, null, 'No active shift');
    }

    return success(res, {
      resetId: active.resetId,
      settlementId: active.resetId,
      cashierId: active.cashierId,
      openingBalance: active.openingBalance,
      terminalId,
    }, 'Active shift found');
  } catch (err) {
    next(err);
  }
}

/**
 * GET /api/shift/summary/:resetId
 * Get shift summary (for daily close screen).
 */
async function getShiftSummary(req, res, next) {
  try {
    const { settlementId, resetId } = req.params;
    const sessionId = resetId || settlementId;
    if (!sessionId) {
      return error(res, 'resetId is required', 400);
    }

    const summary = await shiftService.getShiftSummary(sessionId);
    return success(res, summary, 'Shift summary');
  } catch (err) {
    next(err);
  }
}

/**
 * POST /api/shift/close/:resetId
 * Close the current shift.
 */
async function closeShift(req, res, next) {
  try {
    const { settlementId, resetId } = req.params;
    const sessionId = resetId || settlementId;
    if (!sessionId) {
      return error(res, 'resetId is required', 400);
    }

    const userIdClose = String(req.user.userId || req.user.id);
    const note = req.body?.notes || req.body?.note || null;

    const result = await shiftService.closeShift(sessionId, userIdClose, note);
    return success(res, result, 'Shift closed successfully');
  } catch (err) {
    next(err);
  }
}

module.exports = {
  openShift,
  getActiveShift,
  getShiftSummary,
  closeShift,
};
