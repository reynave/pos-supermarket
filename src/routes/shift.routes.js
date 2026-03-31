const { Router } = require('express');
const shiftController = require('../controllers/shift.controller');
const auth = require('../middleware/auth');
const validate = require('../middleware/validate');
const { openShiftSchema } = require('../schemas/shift.schema');

const router = Router();

// POST /api/shift/open — open a new shift (requires auth)
router.post('/open', auth, validate(openShiftSchema), shiftController.openShift);

// GET /api/shift/active/:terminalId — check active shift
router.get('/active/:terminalId', auth, shiftController.getActiveShift);

// GET /api/shift/summary/:settlementId — shift summary for daily close
router.get('/summary/:settlementId', auth, shiftController.getShiftSummary);

// POST /api/shift/close/:settlementId — close the shift
router.post('/close/:settlementId', auth, shiftController.closeShift);

module.exports = router;
