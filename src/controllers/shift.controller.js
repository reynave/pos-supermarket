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

    // Check if there's already an active shift on this terminal
    const existing = await shiftService.findActiveShift(terminalId);
    if (existing) {
      return success(res, {
        settlementId: existing.settlementId,
        cashierId: existing.cashierId,
        openingBalance: existing.openingBalance,
        terminalId,
        alreadyOpen: true,
      }, 'Shift already active');
    }

    // Generate new settlementId
    const settlementId = await shiftService.generateSettlementId(terminalId);

    // Create settlement + opening balance
    await shiftService.openShift({
      settlementId,
      terminalId,
      cashierId,
      openingBalance: openingBalance || 0,
    });

    return success(res, {
      settlementId,
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
      settlementId: active.settlementId,
      cashierId: active.cashierId,
      openingBalance: active.openingBalance,
      terminalId,
    }, 'Active shift found');
  } catch (err) {
    next(err);
  }
}

/**
 * GET /api/shift/summary/:settlementId
 * Get shift summary (for daily close screen).
 */
async function getShiftSummary(req, res, next) {
  try {
    const { settlementId } = req.params;
    if (!settlementId) {
      return error(res, 'settlementId is required', 400);
    }

    const summary = await shiftService.getShiftSummary(settlementId);
    return success(res, summary, 'Shift summary');
  } catch (err) {
    next(err);
  }
}

/**
 * POST /api/shift/close/:settlementId
 * Close the current shift.
 */
async function closeShift(req, res, next) {
  try {
    const { settlementId } = req.params;
    if (!settlementId) {
      return error(res, 'settlementId is required', 400);
    }

    const result = await shiftService.closeShift(settlementId);
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
