const { verifyAccessToken } = require('../utils/jwt');
const { errorResponse } = require('../utils/response');
const logger = require('../config/logger');

/**
 * Authentication middleware
 * Verifies JWT token and attaches user info to request
 */
const authenticate = (req, res, next) => {
  try {
    // Get token from header
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return errorResponse(res, 401, 'No token provided');
    }

    const token = authHeader.substring(7); // Remove 'Bearer ' prefix

    // Verify token
    const decoded = verifyAccessToken(token);

    // Attach user info to request
    req.user = {
      userId: decoded.userId,
      username: decoded.username,
      userType: decoded.userType,
    };

    next();
  } catch (error) {
    logger.error('Authentication error:', error.message);
    return errorResponse(res, 401, 'Invalid or expired token');
  }
};

/**
 * Authorization middleware
 * Checks if user has required role
 * @param {string[]} allowedRoles - Array of allowed user types
 */
const authorize = (...allowedRoles) => {
  return (req, res, next) => {
    if (!req.user) {
      return errorResponse(res, 401, 'Not authenticated');
    }

    if (!allowedRoles.includes(req.user.userType)) {
      return errorResponse(
        res,
        403,
        'You do not have permission to access this resource'
      );
    }

    next();
  };
};

module.exports = {
  authenticate,
  authorize,
};
