const express = require('express');
const router = express.Router();
const {
  getTransactions,
  getTransactionStats,
  searchUsers,
} = require('../controllers/transactionController');
const { authenticate } = require('../middleware/auth');

/**
 * Transaction Routes
 * Base path: /api/v1/transactions
 * All routes require authentication
 */

// Apply authentication middleware to all routes
router.use(authenticate);

// @route   GET /api/v1/transactions
// @desc    Get user's transactions (with filters)
// @access  Private
router.get('/', getTransactions);

// @route   GET /api/v1/transactions/stats
// @desc    Get transaction statistics
// @access  Private
router.get('/stats', getTransactionStats);

// @route   GET /api/v1/transactions/search-users
// @desc    Search users for creating transactions
// @access  Private
router.get('/search-users', searchUsers);

module.exports = router;
