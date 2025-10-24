const express = require('express');
const router = express.Router();
const {
  register,
  login,
  verifyOTP,
  resendOTP,
  logout,
} = require('../controllers/authController');
const { authenticate } = require('../middleware/auth');

/**
 * Authentication Routes
 * Base path: /api/v1/auth
 */

// @route   POST /api/v1/auth/register
// @desc    Register a new user
// @access  Public
router.post('/register', register);

// @route   POST /api/v1/auth/login
// @desc    Login user (sends OTP)
// @access  Public
router.post('/login', login);

// @route   POST /api/v1/auth/verify-otp
// @desc    Verify OTP and complete authentication
// @access  Public
router.post('/verify-otp', verifyOTP);

// @route   POST /api/v1/auth/resend-otp
// @desc    Resend OTP
// @access  Public
router.post('/resend-otp', resendOTP);

// @route   POST /api/v1/auth/logout
// @desc    Logout user
// @access  Private
router.post('/logout', authenticate, logout);

module.exports = router;
