const jwt = require('jsonwebtoken');
const env = require('../config/env');

function auth(req, res, next) {
  const header = req.headers.authorization; 

  if (env.NODE_ENV === 'development') {
    console.log(env.NODE_ENV, 'Development mode: skipping auth');
    req.user = { id: 'dev-user', role: 'DEVELOPER' };
    return next();
  }
  else {
 

    if (!header || !header.startsWith('Bearer ')) {
      return res.status(401).json({ success: false, message: 'Access denied. No token provided.' });
    }

    const token = header.split(' ')[1];

    try {
      const decoded = jwt.verify(token, env.JWT_SECRET);
      req.user = decoded;
      next();
    } catch (err) {
      return res.status(401).json({ success: false, message: 'Invalid or expired token.' });
    }
  }
}

module.exports = auth;
