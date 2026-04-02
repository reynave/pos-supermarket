const { Router } = require('express');
const auth = require('../middleware/auth');
const validate = require('../middleware/validate');
const dailyCloseController = require('../controllers/daily-close.controller');
const { dailyCloseSubmitSchema } = require('../schemas/daily-close.schema');

const router = Router();

router.get('/history', auth, dailyCloseController.getDailyCloseHistory);
router.get('/report/:resetId', auth, dailyCloseController.getDailyCloseReport);
router.get('/:resetId', auth, dailyCloseController.getDailyClose);
router.post('/:resetId', auth, validate(dailyCloseSubmitSchema), dailyCloseController.submitDailyClose);

module.exports = router;
