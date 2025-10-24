const express = require('express');
const router = express.Router();
const {
  getProfile,
  updateProfile,
  getKYCStatus,
  submitKYC,
} = require('../controllers/userController');
const { authenticate } = require('../middleware/auth');

/**
 * User Routes
 * Base path: /api/v1/users
 * All routes require authentication
 */

// Apply authentication middleware to all routes
router.use(authenticate);

// @route   GET /api/v1/users/profile
// @desc    Get user profile
// @access  Private
router.get('/profile', getProfile);

// @route   PUT /api/v1/users/profile
// @desc    Update user profile
// @access  Private
router.put('/profile', updateProfile);

// @route   GET /api/v1/users/kyc-status
// @desc    Get KYC status and documents
// @access  Private
router.get('/kyc-status', getKYCStatus);

// @route   POST /api/v1/users/kyc
// @desc    Submit KYC document
// @access  Private
router.post('/kyc', submitKYC);

module.exports = router;
