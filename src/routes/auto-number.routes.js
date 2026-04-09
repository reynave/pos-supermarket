const { Router } = require('express');
const { generateCode } = require('../controllers/auto-number.controller');

const router = Router();

// GET /api/auto-number/generate/:name
// Consume next running number for the given auto_number name.
// DEV/TEST only — this route file is never loaded in production.
router.get('/generate/:name', generateCode);

module.exports = router;
