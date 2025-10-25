const { query } = require('../config/database');
const logger = require('../config/logger');
const { successResponse, errorResponse } = require('../utils/response');

/**
 * Get wallet balance and details
 * GET /api/v1/wallet
 */
const getWallet = async (req, res) => {
  try {
    const userId = req.user.id;

    const result = await query(
      `SELECT
        w.id,
        w.balance,
        w.currency,
        w.created_at,
        w.updated_at,
        u.username,
        u.full_name
      FROM wallets w
      JOIN users u ON w.user_id = u.id
      WHERE w.user_id = $1`,
      [userId]
    );

    if (result.rows.length === 0) {
      return errorResponse(res, 404, 'Wallet not found');
    }

    return successResponse(res, 200, 'Wallet retrieved successfully', {
      wallet: result.rows[0],
    });
  } catch (error) {
    logger.error('Get wallet error:', error);
    return errorResponse(res, 500, 'Failed to retrieve wallet');
  }
};

/**
 * Get wallet transaction history
 * GET /api/v1/wallet/transactions
 */
const getWalletTransactions = async (req, res) => {
  try {
    const userId = req.user.id;
    const {
      limit = 20,
      offset = 0,
      type = null, // 'credit' or 'debit'
      startDate = null,
      endDate = null
    } = req.query;

    // Get user's wallet
    const walletResult = await query(
      'SELECT id FROM wallets WHERE user_id = $1',
      [userId]
    );

    if (walletResult.rows.length === 0) {
      return errorResponse(res, 404, 'Wallet not found');
    }

    const walletId = walletResult.rows[0].id;

    // Build query
    let queryText = `
      SELECT
        id,
        amount,
        type,
        description,
        reference,
        balance_before,
        balance_after,
        created_at
      FROM wallet_transactions
      WHERE wallet_id = $1
    `;

    const queryParams = [walletId];
    let paramCount = 1;

    // Add type filter
    if (type && ['credit', 'debit'].includes(type)) {
      paramCount++;
      queryText += ` AND type = $${paramCount}`;
      queryParams.push(type);
    }

    // Add date filters
    if (startDate) {
      paramCount++;
      queryText += ` AND created_at >= $${paramCount}`;
      queryParams.push(startDate);
    }

    if (endDate) {
      paramCount++;
      queryText += ` AND created_at <= $${paramCount}`;
      queryParams.push(endDate);
    }

    queryText += ` ORDER BY created_at DESC LIMIT $${paramCount + 1} OFFSET $${paramCount + 2}`;
    queryParams.push(limit, offset);

    const result = await query(queryText, queryParams);

    // Get total count
    let countQuery = 'SELECT COUNT(*) FROM wallet_transactions WHERE wallet_id = $1';
    const countParams = [walletId];

    if (type && ['credit', 'debit'].includes(type)) {
      countQuery += ' AND type = $2';
      countParams.push(type);
    }

    const countResult = await query(countQuery, countParams);
    const total = parseInt(countResult.rows[0].count);

    return successResponse(res, 200, 'Wallet transactions retrieved successfully', {
      transactions: result.rows,
      pagination: {
        total,
        limit: parseInt(limit),
        offset: parseInt(offset),
        hasMore: parseInt(offset) + result.rows.length < total,
      },
    });
  } catch (error) {
    logger.error('Get wallet transactions error:', error);
    return errorResponse(res, 500, 'Failed to retrieve wallet transactions');
  }
};

/**
 * Initiate wallet funding (Paystack)
 * POST /api/v1/wallet/fund
 */
const fundWallet = async (req, res) => {
  try {
    const userId = req.user.id;
    const { amount, paymentMethod } = req.body;

    // Validate amount
    if (!amount || amount <= 0) {
      return errorResponse(res, 400, 'Invalid amount');
    }

    // Minimum deposit
    if (amount < 10) {
      return errorResponse(res, 400, 'Minimum deposit is GHS 10.00');
    }

    // Maximum deposit
    if (amount > 10000) {
      return errorResponse(res, 400, 'Maximum deposit is GHS 10,000.00');
    }

    // Get user details
    const userResult = await query(
      'SELECT email, phone_number, full_name FROM users WHERE id = $1',
      [userId]
    );

    if (userResult.rows.length === 0) {
      return errorResponse(res, 404, 'User not found');
    }

    const user = userResult.rows[0];

    // TODO: Integrate with Paystack API
    // For now, return a mock payment link
    const reference = `FUND_${Date.now()}_${userId.substring(0, 8)}`;

    // In production, you would:
    // 1. Call Paystack initialize transaction API
    // 2. Get payment URL and reference
    // 3. Return to user for payment
    // 4. Handle webhook callback to credit wallet

    return successResponse(res, 200, 'Payment initialized', {
      reference,
      amount,
      paymentMethod,
      paymentUrl: `https://paystack.com/pay/${reference}`, // Mock URL
      message: 'Complete payment to fund wallet',
    });
  } catch (error) {
    logger.error('Fund wallet error:', error);
    return errorResponse(res, 500, 'Failed to initiate wallet funding');
  }
};

/**
 * Withdraw from wallet
 * POST /api/v1/wallet/withdraw
 */
const withdrawFunds = async (req, res) => {
  const client = await query('BEGIN');

  try {
    const userId = req.user.id;
    const { amount, withdrawalMethod, accountDetails } = req.body;

    // Validate amount
    if (!amount || amount <= 0) {
      await client.query('ROLLBACK');
      return errorResponse(res, 400, 'Invalid amount');
    }

    // Minimum withdrawal
    if (amount < 50) {
      await client.query('ROLLBACK');
      return errorResponse(res, 400, 'Minimum withdrawal is GHS 50.00');
    }

    // Validate withdrawal method
    const validMethods = ['bank_transfer', 'mobile_money'];
    if (!withdrawalMethod || !validMethods.includes(withdrawalMethod)) {
      await client.query('ROLLBACK');
      return errorResponse(res, 400, 'Invalid withdrawal method');
    }

    // Get wallet
    const walletResult = await client.query(
      'SELECT id, balance FROM wallets WHERE user_id = $1 FOR UPDATE',
      [userId]
    );

    if (walletResult.rows.length === 0) {
      await client.query('ROLLBACK');
      return errorResponse(res, 404, 'Wallet not found');
    }

    const wallet = walletResult.rows[0];

    // Check sufficient balance
    if (wallet.balance < amount) {
      await client.query('ROLLBACK');
      return errorResponse(res, 400, 'Insufficient balance');
    }

    // Deduct from wallet
    const balanceBefore = parseFloat(wallet.balance);
    const balanceAfter = balanceBefore - amount;

    await client.query(
      'UPDATE wallets SET balance = $1, updated_at = NOW() WHERE id = $2',
      [balanceAfter, wallet.id]
    );

    // Record wallet transaction
    const reference = `WD_${Date.now()}_${userId.substring(0, 8)}`;

    await client.query(
      `INSERT INTO wallet_transactions
        (wallet_id, amount, type, description, reference, balance_before, balance_after)
       VALUES ($1, $2, 'debit', $3, $4, $5, $6)`,
      [
        wallet.id,
        amount,
        `Withdrawal via ${withdrawalMethod}`,
        reference,
        balanceBefore,
        balanceAfter,
      ]
    );

    await client.query('COMMIT');

    // TODO: Integrate with payment provider to process withdrawal
    // For now, return success with pending status

    return successResponse(res, 200, 'Withdrawal request submitted', {
      reference,
      amount,
      withdrawalMethod,
      status: 'pending',
      message: 'Your withdrawal will be processed within 24 hours',
      newBalance: balanceAfter,
    });
  } catch (error) {
    await client.query('ROLLBACK');
    logger.error('Withdraw funds error:', error);
    return errorResponse(res, 500, 'Failed to process withdrawal');
  }
};

/**
 * Handle Paystack webhook (for funding confirmation)
 * POST /api/v1/wallet/webhook/paystack
 */
const handlePaystackWebhook = async (req, res) => {
  try {
    const event = req.body;

    // Verify webhook signature (important for production)
    // const hash = crypto.createHmac('sha512', process.env.PAYSTACK_SECRET_KEY)
    //   .update(JSON.stringify(req.body))
    //   .digest('hex');
    // if (hash !== req.headers['x-paystack-signature']) {
    //   return res.status(400).send('Invalid signature');
    // }

    if (event.event === 'charge.success') {
      const { reference, amount, customer } = event.data;

      // Extract user ID from reference
      const userIdMatch = reference.match(/FUND_\d+_([a-f0-9]+)/);
      if (!userIdMatch) {
        return res.status(400).send('Invalid reference');
      }

      const userId = userIdMatch[1];

      // Credit wallet
      const walletResult = await query(
        'SELECT id, balance FROM wallets WHERE user_id = $1',
        [userId]
      );

      if (walletResult.rows.length === 0) {
        return res.status(404).send('Wallet not found');
      }

      const wallet = walletResult.rows[0];
      const amountInGHS = amount / 100; // Paystack returns in kobo
      const balanceBefore = parseFloat(wallet.balance);
      const balanceAfter = balanceBefore + amountInGHS;

      // Update wallet balance
      await query(
        'UPDATE wallets SET balance = $1, updated_at = NOW() WHERE id = $2',
        [balanceAfter, wallet.id]
      );

      // Record transaction
      await query(
        `INSERT INTO wallet_transactions
          (wallet_id, amount, type, description, reference, balance_before, balance_after)
         VALUES ($1, $2, 'credit', 'Wallet funded via Paystack', $3, $4, $5)`,
        [wallet.id, amountInGHS, reference, balanceBefore, balanceAfter]
      );

      logger.info(`Wallet funded: ${userId}, Amount: ${amountInGHS}`);
    }

    res.status(200).send('Webhook received');
  } catch (error) {
    logger.error('Paystack webhook error:', error);
    res.status(500).send('Webhook processing failed');
  }
};

/**
 * Direct transfer to another user
 * POST /api/v1/wallet/transfer
 */
const transferFunds = async (req, res) => {
  const client = await query('BEGIN');

  try {
    const senderId = req.user.id;
    const { recipientUsername, amount, description } = req.body;

    // Validate amount
    if (!amount || amount <= 0) {
      await client.query('ROLLBACK');
      return errorResponse(res, 400, 'Invalid amount');
    }

    // Minimum transfer
    if (amount < 1) {
      await client.query('ROLLBACK');
      return errorResponse(res, 400, 'Minimum transfer is GHS 1.00');
    }

    // Get recipient
    const recipientResult = await client.query(
      'SELECT id, username FROM users WHERE username = $1 AND is_active = true',
      [recipientUsername]
    );

    if (recipientResult.rows.length === 0) {
      await client.query('ROLLBACK');
      return errorResponse(res, 404, 'Recipient not found');
    }

    const recipient = recipientResult.rows[0];

    // Cannot transfer to self
    if (recipient.id === senderId) {
      await client.query('ROLLBACK');
      return errorResponse(res, 400, 'Cannot transfer to yourself');
    }

    // Get sender wallet
    const senderWalletResult = await client.query(
      'SELECT id, balance FROM wallets WHERE user_id = $1 FOR UPDATE',
      [senderId]
    );

    if (senderWalletResult.rows.length === 0) {
      await client.query('ROLLBACK');
      return errorResponse(res, 404, 'Sender wallet not found');
    }

    const senderWallet = senderWalletResult.rows[0];

    // Check balance
    if (parseFloat(senderWallet.balance) < amount) {
      await client.query('ROLLBACK');
      return errorResponse(res, 400, 'Insufficient balance');
    }

    // Get recipient wallet
    const recipientWalletResult = await client.query(
      'SELECT id, balance FROM wallets WHERE user_id = $1 FOR UPDATE',
      [recipient.id]
    );

    if (recipientWalletResult.rows.length === 0) {
      await client.query('ROLLBACK');
      return errorResponse(res, 404, 'Recipient wallet not found');
    }

    const recipientWallet = recipientWalletResult.rows[0];

    // Deduct from sender
    const senderBalanceBefore = parseFloat(senderWallet.balance);
    const senderBalanceAfter = senderBalanceBefore - amount;

    await client.query(
      'UPDATE wallets SET balance = $1, updated_at = NOW() WHERE id = $2',
      [senderBalanceAfter, senderWallet.id]
    );

    // Credit recipient
    const recipientBalanceBefore = parseFloat(recipientWallet.balance);
    const recipientBalanceAfter = recipientBalanceBefore + amount;

    await client.query(
      'UPDATE wallets SET balance = $1, updated_at = NOW() WHERE id = $2',
      [recipientBalanceAfter, recipientWallet.id]
    );

    const reference = `TXF_${Date.now()}_${senderId.substring(0, 8)}`;

    // Record sender transaction
    await client.query(
      `INSERT INTO wallet_transactions
        (wallet_id, amount, type, description, reference, balance_before, balance_after)
       VALUES ($1, $2, 'debit', $3, $4, $5, $6)`,
      [
        senderWallet.id,
        amount,
        description || `Transfer to @${recipient.username}`,
        reference,
        senderBalanceBefore,
        senderBalanceAfter,
      ]
    );

    // Record recipient transaction
    await client.query(
      `INSERT INTO wallet_transactions
        (wallet_id, amount, type, description, reference, balance_before, balance_after)
       VALUES ($1, $2, 'credit', $3, $4, $5, $6)`,
      [
        recipientWallet.id,
        amount,
        description || `Transfer from @${req.user.username}`,
        reference,
        recipientBalanceBefore,
        recipientBalanceAfter,
      ]
    );

    // Notify recipient
    await client.query(
      `INSERT INTO notifications (user_id, title, message, type)
       VALUES ($1, 'Money Received', $2, 'transaction')`,
      [recipient.id, `You received GHS ${amount.toFixed(2)} from @${req.user.username}`]
    );

    await client.query('COMMIT');

    return successResponse(res, 200, 'Transfer successful', {
      reference,
      amount,
      recipient: recipient.username,
      newBalance: senderBalanceAfter,
    });
  } catch (error) {
    await client.query('ROLLBACK');
    logger.error('Transfer funds error:', error);
    return errorResponse(res, 500, 'Failed to transfer funds');
  }
};

module.exports = {
  getWallet,
  getWalletTransactions,
  fundWallet,
  withdrawFunds,
  handlePaystackWebhook,
  transferFunds,
};
