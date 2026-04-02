const jwt = require('jsonwebtoken');
const env = require('../config/env');

function auth(req, res, next) {
  const header = req.headers.authorization;

  // Always attempt to decode JWT token if present (works in all environments)
  if (header && header.startsWith('Bearer ')) {
    const token = header.split(' ')[1];
    try {
      const decoded = jwt.verify(token, env.JWT_SECRET);
      req.user = decoded;
      return next();
    } catch (err) {
      // In production, reject invalid tokens immediately
      if (env.NODE_ENV !== 'development') {
        return res.status(401).json({ success: false, message: 'Invalid or expired token.' });
      }
      // In development, fall through to dev fallback below
    }
  }

  if (env.NODE_ENV === 'development') {
    // Dev fallback: no token provided or token invalid — use a placeholder
    req.user = { userId: 'dev-user', id: 'dev-user', role: 'DEVELOPER' };
    return next();
  }

  return res.status(401).json({ success: false, message: 'Access denied. No token provided.' });
}

module.exports = auth;
