const dailyCloseService = require('../services/daily-close.service');
const { success, error } = require('../utils/response');
const env = require('../config/env');

async function getDailyClose(req, res, next) {
  try {
    const { resetId } = req.params;
    if (!resetId) return error(res, 'resetId is required', 400);

    const data = await dailyCloseService.getDailyCloseSummary(resetId);
    if (!data) return error(res, 'Daily close session not found', 404);

    return success(res, data, 'Daily close summary');
  } catch (err) {
    next(err);
  }
}

async function getDailyCloseHistory(req, res, next) {
  try {
    const data = await dailyCloseService.getDailyCloseHistory();
    return success(res, data, 'Daily close history');
  } catch (err) {
    next(err);
  }
}

async function submitDailyClose(req, res, next) {
  try {
    const { resetId } = req.params;
    if (!resetId) return error(res, 'resetId is required', 400);

    const userIdClose = String(req.user.userId || req.user.id);
    const note = req.body?.notes || req.body?.note || null;
    const terminalId = req.body?.terminalId || env.TERMINAL_ID;
    const cashDeclaration = req.body?.cashDeclaration || null;
    const physicalCash = req.body?.physicalCash;

    const result = await dailyCloseService.closeDaily({
      resetId,
      userIdClose,
      terminalId,
      note,
      cashDeclaration,
      physicalCash,
    });

    return success(res, result, 'Daily close submitted');
  } catch (err) {
    next(err);
  }
}

async function getDailyCloseReport(req, res, next) {
  try {
    const { resetId } = req.params;
    if (!resetId) return error(res, 'resetId is required', 400);

    const data = await dailyCloseService.getDailyCloseSummary(resetId);
    if (!data) return error(res, 'Daily close report not found', 404);

    return success(res, data, 'Daily close report');
  } catch (err) {
    next(err);
  }
}

module.exports = {
  getDailyClose,
  getDailyCloseHistory,
  submitDailyClose,
  getDailyCloseReport,
};
