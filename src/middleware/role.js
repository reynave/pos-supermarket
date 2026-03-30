function role(...allowedRoles) {
  return (req, res, next) => {
    if (!req.user || !allowedRoles.includes(req.user.roleName)) {
      return res.status(403).json({ success: false, message: 'Forbidden. Insufficient role.' });
    }
    next();
  };
}

module.exports = role;
