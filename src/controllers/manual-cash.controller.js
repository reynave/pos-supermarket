const manualCashService = require('../services/manual-cash.service');
const { success, error } = require('../utils/response');
const env = require('../config/env');

async function getSummary(req, res, next) {
  try {
    const terminalId = req.params.terminalId || req.query.terminalId || env.TERMINAL_ID;
    const data = await manualCashService.getManualCashSummary(terminalId);
    if (!data) {
      return error(res, 'No active shift found for manual cash in', 404);
    }
    return success(res, data, 'Manual cash summary');
  } catch (err) {
    next(err);
  }
}

async function addCashIn(req, res, next) {
  try {
    const terminalId = req.body.terminalId || env.TERMINAL_ID;
    const userId = String(req.user.userId || req.user.id);

    let resetId = req.body.resetId;
    if (!resetId) {
      const active = await manualCashService.getManualCashSummary(terminalId);
      if (!active?.resetId) {
        return error(res, 'No active shift found for manual cash in', 400);
      }
      resetId = active.resetId;
    }

    const result = await manualCashService.addManualCashIn({
      resetId,
      amount: req.body.amount,
      terminalId,
      cashierId: userId,
    });

    return success(res, result, 'Manual cash in added');
  } catch (err) {
    next(err);
  }
}

async function getHistory(req, res, next) {
  try {
    const terminalId = req.query.terminalId || env.TERMINAL_ID;
    const resetId = req.query.resetId || null;

    const data = await manualCashService.getCashBalanceHistory({
      terminalId,
      resetId,
    });

    return success(res, data, 'Cash balance history');
  } catch (err) {
    next(err);
  }
}

async function openDrawer(req, res, next) {
  try {
    const result = manualCashService.openCashDrawer();
    return success(res, result, 'Open drawer executed');
  } catch (err) {
    next(err);
  }
}

module.exports = {
  getSummary,
  addCashIn,
  getHistory,
  openDrawer,
};
