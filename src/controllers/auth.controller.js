const authService = require('../services/auth.service');
const { success, error } = require('../utils/response');
const env = require('../config/env');

async function login(req, res, next) {
  try {
    const { userId, password, terminalId } = req.body;
    const terminal = terminalId || env.TERMINAL_ID;

    // 1. Find user
    const user = await authService.findUserById(userId);
    if (!user) {
      return error(res, 'Employee ID not found', 404);
    }

    // 2. Check user status
    if (user.status !== 1) {
      return error(res, 'User account is inactive', 403);
    }

    // 3. Verify password (if user has one set)
    if (user.password) {
      if (!password) {
        return error(res, 'Password is required', 401);
      }
      const valid = authService.verifyMd5(password, user.password);
      if (!valid) {
        return error(res, 'Invalid password', 401);
      }
    }

    // 4. Invalidate previous sessions on this terminal
    await authService.invalidateSessions(user.id, terminal);

    // 5. Generate JWT
    const token = authService.generateToken(user);

    // 6. Store session in user_auth
    const agent = req.headers['user-agent'] || '';
    const clientIp = req.ip;
    const sessionId = await authService.createSession({
      userId: user.id,
      agent: agent.substring(0, 50),
      clientIp,
      terminalId: terminal,
      token: `TT-${token.substring(token.length - 32)}`,
    });

    // 7. Return response
    return success(res, {
      token,
      sessionId,
      user: {
        id: user.id,
        name: user.name,
        role: user.roleName,
        userAccessId: user.userAccessId,
        saveFunc: user.saveFunc,
        saveShortCut: user.saveShortCut,
      },
      terminalId: terminal,
    }, 'Login successful');
  } catch (err) {
    next(err);
  }
}

async function logout(req, res, next) {
  try {
    const { userId, terminalId } = req.user;
    const terminal = terminalId || req.body.terminalId || env.TERMINAL_ID;

    await authService.invalidateSessions(userId, terminal);

    return success(res, null, 'Logout successful');
  } catch (err) {
    next(err);
  }
}

async function me(req, res, next) {
  try {
    const user = await authService.findUserById(req.user.userId);
    if (!user) {
      return error(res, 'User not found', 404);
    }

    return success(res, {
      id: user.id,
      name: user.name,
      role: user.roleName,
      userAccessId: user.userAccessId,
      status: user.status,
      saveFunc: user.saveFunc,
      saveShortCut: user.saveShortCut,
    });
  } catch (err) {
    next(err);
  }
}

module.exports = { login, logout, me };
