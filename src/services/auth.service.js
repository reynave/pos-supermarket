const crypto = require('crypto');
const jwt = require('jsonwebtoken');
const pool = require('../config/database');
const env = require('../config/env');

/**
 * Find user by employee ID, joined with role name from user_access.
 */
async function findUserById(userId) {
  const [rows] = await pool.query(
    `SELECT u.id, u.name, u.userAccessId, u.password, u.status, u.presence,
            u.saveFunc, u.saveShortCut, u.storeOutlesId,
            ua.name AS roleName
     FROM user u
     LEFT JOIN user_access ua ON ua.id = u.userAccessId
     WHERE u.id = ?`,
    [userId]
  );
  return rows[0] || null;
}

/**
 * Verify MD5 legacy password.
 */
function verifyMd5(plain, hash) {
  return crypto.createHash('md5').update(plain).digest('hex') === hash;
}

/**
 * Generate a unique session ID (hex timestamp + random bytes, similar to PHP uniqid).
 */
function generateSessionId() {
  const ts = Math.floor(Date.now() / 1000).toString(16);
  const rand = crypto.randomBytes(4).toString('hex');
  return ts + rand;
}

/**
 * Create or update a session record in user_auth.
 */
async function createSession({ userId, agent, clientIp, terminalId, token }) {
  const sessionId = generateSessionId();
  const now = new Date();

  await pool.query(
    `INSERT INTO user_auth (id, userId, agent, client_ip, terminalId, inputDate, updateDate, status, token, inputBy)
     VALUES (?, ?, ?, ?, ?, ?, ?, 1, ?, ?)`,
    [sessionId, userId, agent, clientIp, terminalId, now, now, token, userId]
  );

  return sessionId;
}

/**
 * Invalidate all active sessions for a user + terminal combination.
 */
async function invalidateSessions(userId, terminalId) {
  await pool.query(
    `UPDATE user_auth SET status = 0, updateDate = NOW()
     WHERE userId = ? AND terminalId = ? AND status = 1`,
    [userId, terminalId]
  );
}

/**
 * Generate JWT token for a user.
 */
function generateToken(user) {
  const payload = {
    userId: user.id,
    name: user.name,
    userAccessId: user.userAccessId,
    roleName: user.roleName,
  };

  return jwt.sign(payload, env.JWT_SECRET, { expiresIn: env.JWT_EXPIRES_IN });
}

/**
 * Find active session by token.
 */
async function findSessionByToken(token) {
  const [rows] = await pool.query(
    `SELECT * FROM user_auth WHERE token = ? AND status = 1`,
    [token]
  );
  return rows[0] || null;
}

module.exports = {
  findUserById,
  verifyMd5,
  generateSessionId,
  createSession,
  invalidateSessions,
  generateToken,
  findSessionByToken,
};
