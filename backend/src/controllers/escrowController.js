const { query, getClient } = require('../config/database');
const { successResponse, errorResponse } = require('../utils/response');
const {
  createEscrowSchema,
  confirmDeliverySchema,
  raiseDisputeSchema,
  cancelTransactionSchema,
  assignRiderSchema,
} = require('../utils/escrowValidation');
const logger = require('../config/logger');
const { v4: uuidv4 } = require('uuid');

/**
 * Create a new escrow transaction
 * POST /api/v1/escrow/create
 */
const createEscrow = async (req, res) => {
  try {
    // Validate request body
    const { error, value } = createEscrowSchema.validate(req.body);
    if (error) {
      return errorResponse(res, 400, 'Validation error', error.details);
    }

    const buyerId = req.user.userId;
    const { sellerId, amount, description, paymentMethod, riderId } = value;

    // Check if buyer is trying to create transaction with themselves
    if (buyerId === sellerId) {
      return errorResponse(res, 400, 'Cannot create transaction with yourself');
    }

    // Verify seller exists and is a seller
    const sellerCheck = await query(
      'SELECT id, user_type FROM users WHERE id = $1',
      [sellerId]
    );

    if (sellerCheck.rows.length === 0) {
      return errorResponse(res, 404, 'Seller not found');
    }

    if (sellerCheck.rows[0].user_type !== 'seller') {
      return errorResponse(res, 400, 'User is not a seller');
    }

    // Calculate commission (2%)
    const commissionRate = parseFloat(process.env.PLATFORM_COMMISSION_RATE) || 0.02;
    const commission = amount * commissionRate;

    // Generate transaction reference
    const transactionRef = `ESC${Date.now()}${Math.random().toString(36).substr(2, 9).toUpperCase()}`;

    const client = await getClient();

    try {
      await client.query('BEGIN');

      // For wallet payment, check buyer's wallet balance
      if (paymentMethod === 'wallet') {
        const walletResult = await client.query(
          'SELECT balance FROM wallets WHERE user_id = $1',
          [buyerId]
        );

        if (walletResult.rows.length === 0) {
          throw new Error('Wallet not found');
        }

        const balance = parseFloat(walletResult.rows[0].balance);
        if (balance < amount) {
          throw new Error(`Insufficient wallet balance. Required: ${amount}, Available: ${balance}`);
        }

        // Deduct from buyer's wallet
        await client.query(
          'UPDATE wallets SET balance = balance - $1::NUMERIC WHERE user_id = $2',
          [amount, buyerId]
        );

        // Log wallet transaction
        await client.query(
          `INSERT INTO wallet_transactions
           (wallet_id, amount, type, description, reference, balance_before, balance_after)
           SELECT id, $1::NUMERIC, 'debit', $2, $3, $4::NUMERIC, ($4::NUMERIC - $1::NUMERIC)
           FROM wallets WHERE user_id = $5`,
          [amount, 'Escrow payment', transactionRef, balance, buyerId]
        );
      }

      // Create transaction
      const transactionResult = await client.query(
        `INSERT INTO transactions
         (transaction_ref, buyer_id, seller_id, rider_id, amount, commission, status, type, description, payment_method)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
         RETURNING *`,
        [
          transactionRef,
          buyerId,
          sellerId,
          riderId || null,
          amount,
          commission,
          'in_escrow',
          'escrow',
          description,
          paymentMethod,
        ]
      );

      const transaction = transactionResult.rows[0];

      // Create escrow account
      await client.query(
        `INSERT INTO escrow_accounts (transaction_id, amount, status, held_at)
         VALUES ($1, $2, 'held', CURRENT_TIMESTAMP)`,
        [transaction.id, amount]
      );

      // Log transaction
      await client.query(
        `INSERT INTO transaction_logs (transaction_id, action, description, created_by)
         VALUES ($1, 'created', 'Escrow transaction created', $2)`,
        [transaction.id, buyerId]
      );

      // Create notifications for seller (and rider if assigned)
      await client.query(
        `INSERT INTO notifications (user_id, title, message, type)
         VALUES ($1, 'New Escrow Payment', $2, 'transaction')`,
        [
          sellerId,
          `You have received an escrow payment of GHS ${amount} for: ${description}`,
        ]
      );

      if (riderId) {
        await client.query(
          `INSERT INTO notifications (user_id, title, message, type)
           VALUES ($1, 'New Delivery', $2, 'delivery')`,
          [
            riderId,
            `You have been assigned a delivery for transaction ${transactionRef}`,
          ]
        );
      }

      await client.query('COMMIT');

      logger.info(`Escrow transaction created: ${transactionRef} by user ${buyerId}`);

      return successResponse(res, 201, 'Escrow transaction created successfully', {
        transaction: {
          id: transaction.id,
          transactionRef: transaction.transaction_ref,
          amount: transaction.amount,
          commission: transaction.commission,
          status: transaction.status,
          description: transaction.description,
          paymentMethod: transaction.payment_method,
          createdAt: transaction.created_at,
        },
      });
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  } catch (error) {
    logger.error('Create escrow error:', error);
    return errorResponse(res, 500, error.message || 'Failed to create escrow transaction');
  }
};

/**
 * Get escrow transaction details
 * GET /api/v1/escrow/:id
 */
const getEscrowDetails = async (req, res) => {
  try {
    const userId = req.user.userId;
    const transactionId = req.params.id;

    const result = await query(
      `SELECT
        t.*,
        e.status as escrow_status,
        e.held_at,
        e.released_at,
        e.refunded_at,
        buyer.username as buyer_username,
        buyer.full_name as buyer_name,
        buyer.phone_number as buyer_phone,
        seller.username as seller_username,
        seller.full_name as seller_name,
        seller.phone_number as seller_phone,
        rider.username as rider_username,
        rider.full_name as rider_name,
        rider.phone_number as rider_phone
       FROM transactions t
       LEFT JOIN escrow_accounts e ON t.id = e.transaction_id
       LEFT JOIN users buyer ON t.buyer_id = buyer.id
       LEFT JOIN users seller ON t.seller_id = seller.id
       LEFT JOIN users rider ON t.rider_id = rider.id
       WHERE t.id = $1 AND (t.buyer_id = $2 OR t.seller_id = $2 OR t.rider_id = $2)`,
      [transactionId, userId]
    );

    if (result.rows.length === 0) {
      return errorResponse(res, 404, 'Transaction not found or access denied');
    }

    const transaction = result.rows[0];

    // Get transaction logs
    const logsResult = await query(
      `SELECT tl.*, u.username, u.full_name
       FROM transaction_logs tl
       LEFT JOIN users u ON tl.created_by = u.id
       WHERE tl.transaction_id = $1
       ORDER BY tl.created_at DESC`,
      [transactionId]
    );

    return successResponse(res, 200, 'Transaction details retrieved successfully', {
      transaction: {
        id: transaction.id,
        transactionRef: transaction.transaction_ref,
        amount: transaction.amount,
        commission: transaction.commission,
        status: transaction.status,
        type: transaction.type,
        description: transaction.description,
        paymentMethod: transaction.payment_method,
        escrowStatus: transaction.escrow_status,
        buyer: {
          id: transaction.buyer_id,
          username: transaction.buyer_username,
          fullName: transaction.buyer_name,
          phoneNumber: transaction.buyer_phone,
        },
        seller: {
          id: transaction.seller_id,
          username: transaction.seller_username,
          fullName: transaction.seller_name,
          phoneNumber: transaction.seller_phone,
        },
        rider: transaction.rider_id
          ? {
              id: transaction.rider_id,
              username: transaction.rider_username,
              fullName: transaction.rider_name,
              phoneNumber: transaction.rider_phone,
            }
          : null,
        heldAt: transaction.held_at,
        releasedAt: transaction.released_at,
        refundedAt: transaction.refunded_at,
        createdAt: transaction.created_at,
        completedAt: transaction.completed_at,
        logs: logsResult.rows,
      },
    });
  } catch (error) {
    logger.error('Get escrow details error:', error);
    return errorResponse(res, 500, 'Failed to retrieve transaction details');
  }
};

/**
 * Confirm delivery (buyer confirms receipt)
 * POST /api/v1/escrow/:id/confirm-delivery
 */
const confirmDelivery = async (req, res) => {
  try {
    const { error, value } = confirmDeliverySchema.validate(req.body);
    if (error) {
      return errorResponse(res, 400, 'Validation error', error.details);
    }

    const buyerId = req.user.userId;
    const transactionId = req.params.id;
    const { confirmed, notes } = value;

    const client = await getClient();

    try {
      await client.query('BEGIN');

      // Get transaction details
      const transactionResult = await client.query(
        `SELECT t.*, e.id as escrow_id, e.amount as escrow_amount
         FROM transactions t
         LEFT JOIN escrow_accounts e ON t.id = e.transaction_id
         WHERE t.id = $1 AND t.buyer_id = $2`,
        [transactionId, buyerId]
      );

      if (transactionResult.rows.length === 0) {
        throw new Error('Transaction not found or you are not the buyer');
      }

      const transaction = transactionResult.rows[0];

      if (transaction.status !== 'in_escrow') {
        throw new Error(`Cannot confirm delivery for transaction with status: ${transaction.status}`);
      }

      if (confirmed) {
        // Release funds to seller
        const amountToRelease = parseFloat(transaction.amount) - parseFloat(transaction.commission);

        // Credit seller's wallet
        await client.query(
          'UPDATE wallets SET balance = balance + $1::NUMERIC WHERE user_id = $2',
          [amountToRelease, transaction.seller_id]
        );

        // Log wallet transaction for seller
        const sellerWalletResult = await client.query(
          'SELECT balance FROM wallets WHERE user_id = $1',
          [transaction.seller_id]
        );
        const sellerBalance = parseFloat(sellerWalletResult.rows[0].balance);

        await client.query(
          `INSERT INTO wallet_transactions
           (wallet_id, amount, type, description, reference, balance_before, balance_after)
           SELECT id, $1, 'credit', $2, $3, $4, $5
           FROM wallets WHERE user_id = $6`,
          [
            amountToRelease,
            'Escrow payment received',
            transaction.transaction_ref,
            sellerBalance - amountToRelease,
            sellerBalance,
            transaction.seller_id,
          ]
        );

        // Update transaction status
        await client.query(
          `UPDATE transactions
           SET status = 'completed', completed_at = CURRENT_TIMESTAMP
           WHERE id = $1`,
          [transactionId]
        );

        // Update escrow account
        await client.query(
          `UPDATE escrow_accounts
           SET status = 'released', released_at = CURRENT_TIMESTAMP, notes = $1
           WHERE transaction_id = $2`,
          [notes || 'Delivery confirmed by buyer', transactionId]
        );

        // Log transaction
        await client.query(
          `INSERT INTO transaction_logs (transaction_id, action, description, created_by)
           VALUES ($1, 'completed', $2, $3)`,
          [
            transactionId,
            `Delivery confirmed. Funds released to seller${notes ? ': ' + notes : ''}`,
            buyerId,
          ]
        );

        // Notify seller
        await client.query(
          `INSERT INTO notifications (user_id, title, message, type)
           VALUES ($1, 'Payment Released', $2, 'transaction')`,
          [
            transaction.seller_id,
            `Delivery confirmed! GHS ${amountToRelease.toFixed(2)} has been credited to your wallet.`,
          ]
        );

        // Notify rider if exists
        if (transaction.rider_id) {
          await client.query(
            `INSERT INTO notifications (user_id, title, message, type)
             VALUES ($1, 'Delivery Completed', $2, 'delivery')`,
            [transaction.rider_id, 'Delivery has been confirmed by the buyer.']
          );
        }
      } else {
        // Buyer rejected delivery - initiate refund
        await client.query(
          `UPDATE transactions
           SET status = 'disputed'
           WHERE id = $1`,
          [transactionId]
        );

        // Create dispute
        await client.query(
          `INSERT INTO disputes (transaction_id, raised_by, reason, status)
           VALUES ($1, $2, $3, 'open')`,
          [transactionId, buyerId, notes || 'Delivery rejected by buyer']
        );

        // Log transaction
        await client.query(
          `INSERT INTO transaction_logs (transaction_id, action, description, created_by)
           VALUES ($1, 'disputed', $2, $3)`,
          [transactionId, `Delivery rejected${notes ? ': ' + notes : ''}`, buyerId]
        );

        // Notify seller
        await client.query(
          `INSERT INTO notifications (user_id, title, message, type)
           VALUES ($1, 'Delivery Rejected', $2, 'transaction')`,
          [transaction.seller_id, 'The buyer has rejected the delivery. A dispute has been raised.']
        );
      }

      await client.query('COMMIT');

      logger.info(
        `Delivery ${confirmed ? 'confirmed' : 'rejected'} for transaction ${transactionId}`
      );

      return successResponse(
        res,
        200,
        confirmed
          ? 'Delivery confirmed. Funds released to seller.'
          : 'Delivery rejected. Dispute raised.'
      );
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  } catch (error) {
    logger.error('Confirm delivery error:', error);
    return errorResponse(res, 500, error.message || 'Failed to process delivery confirmation');
  }
};

/**
 * Raise a dispute
 * POST /api/v1/escrow/:id/dispute
 */
const raiseDispute = async (req, res) => {
  try {
    const { error, value } = raiseDisputeSchema.validate(req.body);
    if (error) {
      return errorResponse(res, 400, 'Validation error', error.details);
    }

    const userId = req.user.userId;
    const transactionId = req.params.id;
    const { reason } = value;

    const client = await getClient();

    try {
      await client.query('BEGIN');

      // Verify user is part of the transaction
      const transactionResult = await client.query(
        `SELECT * FROM transactions
         WHERE id = $1 AND (buyer_id = $2 OR seller_id = $2)`,
        [transactionId, userId]
      );

      if (transactionResult.rows.length === 0) {
        throw new Error('Transaction not found or access denied');
      }

      const transaction = transactionResult.rows[0];

      if (transaction.status === 'completed' || transaction.status === 'refunded') {
        throw new Error('Cannot dispute a completed or refunded transaction');
      }

      // Update transaction status
      await client.query(
        `UPDATE transactions SET status = 'disputed' WHERE id = $1`,
        [transactionId]
      );

      // Create dispute
      await client.query(
        `INSERT INTO disputes (transaction_id, raised_by, reason, status)
         VALUES ($1, $2, $3, 'open')`,
        [transactionId, userId, reason]
      );

      // Log transaction
      await client.query(
        `INSERT INTO transaction_logs (transaction_id, action, description, created_by)
         VALUES ($1, 'disputed', $2, $3)`,
        [transactionId, `Dispute raised: ${reason}`, userId]
      );

      // Notify other party
      const otherPartyId =
        userId === transaction.buyer_id ? transaction.seller_id : transaction.buyer_id;

      await client.query(
        `INSERT INTO notifications (user_id, title, message, type)
         VALUES ($1, 'Dispute Raised', $2, 'dispute')`,
        [otherPartyId, `A dispute has been raised on transaction ${transaction.transaction_ref}`]
      );

      await client.query('COMMIT');

      logger.info(`Dispute raised on transaction ${transactionId} by user ${userId}`);

      return successResponse(res, 200, 'Dispute raised successfully. An admin will review it.');
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  } catch (error) {
    logger.error('Raise dispute error:', error);
    return errorResponse(res, 500, error.message || 'Failed to raise dispute');
  }
};

/**
 * Cancel escrow transaction (before seller ships)
 * POST /api/v1/escrow/:id/cancel
 */
const cancelTransaction = async (req, res) => {
  try {
    const { error, value } = cancelTransactionSchema.validate(req.body);
    if (error) {
      return errorResponse(res, 400, 'Validation error', error.details);
    }

    const userId = req.user.userId;
    const transactionId = req.params.id;
    const { reason } = value;

    const client = await getClient();

    try {
      await client.query('BEGIN');

      // Get transaction details
      const transactionResult = await client.query(
        `SELECT * FROM transactions WHERE id = $1 AND buyer_id = $2`,
        [transactionId, userId]
      );

      if (transactionResult.rows.length === 0) {
        throw new Error('Transaction not found or you are not the buyer');
      }

      const transaction = transactionResult.rows[0];

      if (transaction.status !== 'in_escrow') {
        throw new Error('Can only cancel transactions that are in escrow');
      }

      // Refund to buyer if paid from wallet
      if (transaction.payment_method === 'wallet') {
        await client.query(
          'UPDATE wallets SET balance = balance + $1::NUMERIC WHERE user_id = $2',
          [transaction.amount, userId]
        );

        // Log wallet transaction
        const walletResult = await client.query(
          'SELECT balance FROM wallets WHERE user_id = $1',
          [userId]
        );
        const balance = parseFloat(walletResult.rows[0].balance);

        await client.query(
          `INSERT INTO wallet_transactions
           (wallet_id, amount, type, description, reference, balance_before, balance_after)
           SELECT id, $1, 'credit', $2, $3, $4, $5
           FROM wallets WHERE user_id = $6`,
          [
            transaction.amount,
            'Refund from cancelled transaction',
            transaction.transaction_ref,
            balance - transaction.amount,
            balance,
            userId,
          ]
        );
      }

      // Update transaction status
      await client.query(
        `UPDATE transactions
         SET status = 'cancelled', completed_at = CURRENT_TIMESTAMP
         WHERE id = $1`,
        [transactionId]
      );

      // Update escrow account
      await client.query(
        `UPDATE escrow_accounts
         SET status = 'refunded', refunded_at = CURRENT_TIMESTAMP, notes = $1
         WHERE transaction_id = $2`,
        [reason || 'Cancelled by buyer', transactionId]
      );

      // Log transaction
      await client.query(
        `INSERT INTO transaction_logs (transaction_id, action, description, created_by)
         VALUES ($1, 'cancelled', $2, $3)`,
        [transactionId, `Transaction cancelled${reason ? ': ' + reason : ''}`, userId]
      );

      // Notify seller
      await client.query(
        `INSERT INTO notifications (user_id, title, message, type)
         VALUES ($1, 'Transaction Cancelled', $2, 'transaction')`,
        [
          transaction.seller_id,
          `Transaction ${transaction.transaction_ref} has been cancelled by the buyer.`,
        ]
      );

      await client.query('COMMIT');

      logger.info(`Transaction ${transactionId} cancelled by user ${userId}`);

      return successResponse(res, 200, 'Transaction cancelled successfully. Funds have been refunded.');
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  } catch (error) {
    logger.error('Cancel transaction error:', error);
    return errorResponse(res, 500, error.message || 'Failed to cancel transaction');
  }
};

module.exports = {
  createEscrow,
  getEscrowDetails,
  confirmDelivery,
  raiseDispute,
  cancelTransaction,
};
