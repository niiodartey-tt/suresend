const express = require('express');
const router = express.Router();
const {
  createEscrow,
  getEscrowDetails,
  confirmDelivery,
  raiseDispute,
  cancelTransaction,
} = require('../controllers/escrowController');
const { authenticate, authorize } = require('../middleware/auth');

/**
 * Escrow Routes
 * Base path: /api/v1/escrow
 * All routes require authentication
 */

// Apply authentication middleware to all routes
router.use(authenticate);

// @route   POST /api/v1/escrow/create
// @desc    Create a new escrow transaction
// @access  Private (Buyer only)
router.post('/create', authorize('buyer'), createEscrow);

// @route   GET /api/v1/escrow/:id
// @desc    Get escrow transaction details
// @access  Private (Buyer, Seller, Rider)
router.get('/:id', getEscrowDetails);

// @route   POST /api/v1/escrow/:id/confirm-delivery
// @desc    Confirm or reject delivery
// @access  Private (Buyer only)
router.post('/:id/confirm-delivery', authorize('buyer'), confirmDelivery);

// @route   POST /api/v1/escrow/:id/dispute
// @desc    Raise a dispute
// @access  Private (Buyer, Seller)
router.post('/:id/dispute', authorize('buyer', 'seller'), raiseDispute);

// @route   POST /api/v1/escrow/:id/cancel
// @desc    Cancel escrow transaction
// @access  Private (Buyer only)
router.post('/:id/cancel', authorize('buyer'), cancelTransaction);

module.exports = router;
