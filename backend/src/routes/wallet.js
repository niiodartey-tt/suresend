const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const { validate, fundWalletSchema, withdrawFundsSchema, transferFundsSchema } = require('../utils/walletValidation');
const {
  getWallet,
  getWalletTransactions,
  fundWallet,
  withdrawFunds,
  handlePaystackWebhook,
  transferFunds,
} = require('../controllers/walletController');

// Webhook doesn't need authentication
router.post('/webhook/paystack', handlePaystackWebhook);

// All other routes require authentication
router.use(authenticate);

// @route   GET /api/v1/wallet
// @desc    Get wallet balance and details
// @access  Private
router.get('/', getWallet);

// @route   GET /api/v1/wallet/transactions
// @desc    Get wallet transaction history
// @access  Private
router.get('/transactions', getWalletTransactions);

// @route   POST /api/v1/wallet/fund
// @desc    Initiate wallet funding
// @access  Private
router.post('/fund', validate(fundWalletSchema), fundWallet);

// @route   POST /api/v1/wallet/withdraw
// @desc    Withdraw funds from wallet
// @access  Private
router.post('/withdraw', validate(withdrawFundsSchema), withdrawFunds);

// @route   POST /api/v1/wallet/transfer
// @desc    Transfer funds to another user
// @access  Private
router.post('/transfer', validate(transferFundsSchema), transferFunds);

module.exports = router;
