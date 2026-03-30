const { Router } = require('express');
const authController = require('../controllers/auth.controller');
const auth = require('../middleware/auth');
const validate = require('../middleware/validate');
const { loginSchema } = require('../schemas/auth.schema');

const router = Router();

// POST /api/auth/login
router.post('/login', validate(loginSchema), authController.login);

// POST /api/auth/logout (protected)
router.post('/logout', auth, authController.logout);

// GET /api/auth/me (protected)
router.get('/me', auth, authController.me);

module.exports = router;
