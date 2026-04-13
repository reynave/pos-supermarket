const paymentBcaLanService = require('../services/payment-bca-lan.service');
const { success, error } = require('../utils/response');

async function payment(req, res, next) {
  try {
    const result = await paymentBcaLanService.executeBcaLanPayment(req.body);
    if (!result.success) {
      return error(res, result.message, 502);
    }
    return success(res, result, 'BCA LAN payment processed');
  } catch (err) {
    next(err);
  }
}

async function echoTest(req, res, next) {
  try {
    const result = await paymentBcaLanService.echoTestBcaLan(req.body);
    if (!result.success) {
      return res.status(500).json(result);
    }
    return res.json(result);
  } catch (err) {
    if (err.message.includes('BCA_LAN_ECHO_TEST') || err.message.includes('ECHOTESTBCA')) {
      return error(res, err.message, 400);
    }
    next(err);
  }
}

async function checkServer(_req, res) {
  return success(
    res,
    {
      message: 'BCA LAN module ready',
      timestamp: new Date().toISOString(),
    },
    'BCA LAN status',
  );
}

module.exports = {
  payment,
  echoTest,
  checkServer,
};
