const { query } = require('../config/database');
const { successResponse, errorResponse } = require('../utils/response');
const logger = require('../config/logger');

/**
 * Get user's transactions (with pagination and filters)
 * GET /api/v1/transactions
 */
const getTransactions = async (req, res) => {
  try {
    const userId = req.user.userId;
    const {
      page = 1,
      limit = 20,
      status,
      type,
      role, // 'buyer', 'seller', 'rider'
    } = req.query;

    const offset = (page - 1) * limit;

    // Build query conditions
    let conditions = [];
    let params = [userId];
    let paramIndex = 2;

    // Role filter
    if (role === 'buyer') {
      conditions.push(`t.buyer_id = $1`);
    } else if (role === 'seller') {
      conditions.push(`t.seller_id = $1`);
    } else if (role === 'rider') {
      conditions.push(`t.rider_id = $1`);
    } else {
      conditions.push(`(t.buyer_id = $1 OR t.seller_id = $1 OR t.rider_id = $1)`);
    }

    // Status filter
    if (status) {
      conditions.push(`t.status = $${paramIndex}`);
      params.push(status);
      paramIndex++;
    }

    // Type filter
    if (type) {
      conditions.push(`t.type = $${paramIndex}`);
      params.push(type);
      paramIndex++;
    }

    const whereClause = conditions.join(' AND ');

    // Get transactions
    const result = await query(
      `SELECT
        t.*,
        buyer.username as buyer_username,
        buyer.full_name as buyer_name,
        seller.username as seller_username,
        seller.full_name as seller_name,
        rider.username as rider_username,
        rider.full_name as rider_name
       FROM transactions t
       LEFT JOIN users buyer ON t.buyer_id = buyer.id
       LEFT JOIN users seller ON t.seller_id = seller.id
       LEFT JOIN users rider ON t.rider_id = rider.id
       WHERE ${whereClause}
       ORDER BY t.created_at DESC
       LIMIT $${paramIndex} OFFSET $${paramIndex + 1}`,
      [...params, limit, offset]
    );

    // Get total count
    const countResult = await query(
      `SELECT COUNT(*) FROM transactions t WHERE ${whereClause}`,
      params
    );

    const total = parseInt(countResult.rows[0].count);
    const totalPages = Math.ceil(total / limit);

    return successResponse(res, 200, 'Transactions retrieved successfully', {
      transactions: result.rows.map((t) => ({
        id: t.id,
        transactionRef: t.transaction_ref,
        amount: t.amount,
        commission: t.commission,
        status: t.status,
        type: t.type,
        description: t.description,
        paymentMethod: t.payment_method,
        buyer: {
          id: t.buyer_id,
          username: t.buyer_username,
          fullName: t.buyer_name,
        },
        seller: {
          id: t.seller_id,
          username: t.seller_username,
          fullName: t.seller_name,
        },
        rider: t.rider_id
          ? {
              id: t.rider_id,
              username: t.rider_username,
              fullName: t.rider_name,
            }
          : null,
        createdAt: t.created_at,
        completedAt: t.completed_at,
      })),
      pagination: {
        currentPage: parseInt(page),
        totalPages,
        totalItems: total,
        itemsPerPage: parseInt(limit),
      },
    });
  } catch (error) {
    logger.error('Get transactions error:', error);
    return errorResponse(res, 500, 'Failed to retrieve transactions');
  }
};

/**
 * Get transaction statistics
 * GET /api/v1/transactions/stats
 */
const getTransactionStats = async (req, res) => {
  try {
    const userId = req.user.userId;

    // Get stats
    const statsResult = await query(
      `SELECT
        COUNT(*) FILTER (WHERE buyer_id = $1) as total_purchases,
        COUNT(*) FILTER (WHERE seller_id = $1) as total_sales,
        COUNT(*) FILTER (WHERE rider_id = $1) as total_deliveries,
        COUNT(*) FILTER (WHERE status = 'completed' AND buyer_id = $1) as completed_purchases,
        COUNT(*) FILTER (WHERE status = 'completed' AND seller_id = $1) as completed_sales,
        COUNT(*) FILTER (WHERE status = 'in_escrow' AND buyer_id = $1) as active_purchases,
        COUNT(*) FILTER (WHERE status = 'in_escrow' AND seller_id = $1) as active_sales,
        COALESCE(SUM(amount) FILTER (WHERE status = 'completed' AND buyer_id = $1), 0) as total_spent,
        COALESCE(SUM(amount - commission) FILTER (WHERE status = 'completed' AND seller_id = $1), 0) as total_earned
       FROM transactions
       WHERE buyer_id = $1 OR seller_id = $1 OR rider_id = $1`,
      [userId]
    );

    const stats = statsResult.rows[0];

    return successResponse(res, 200, 'Transaction statistics retrieved successfully', {
      stats: {
        purchases: {
          total: parseInt(stats.total_purchases),
          completed: parseInt(stats.completed_purchases),
          active: parseInt(stats.active_purchases),
          totalSpent: parseFloat(stats.total_spent),
        },
        sales: {
          total: parseInt(stats.total_sales),
          completed: parseInt(stats.completed_sales),
          active: parseInt(stats.active_sales),
          totalEarned: parseFloat(stats.total_earned),
        },
        deliveries: {
          total: parseInt(stats.total_deliveries),
        },
      },
    });
  } catch (error) {
    logger.error('Get transaction stats error:', error);
    return errorResponse(res, 500, 'Failed to retrieve transaction statistics');
  }
};

/**
 * Search users for transaction (all users can buy or sell)
 * GET /api/v1/transactions/search-users
 */
const searchUsers = async (req, res) => {
  try {
    const { search, excludeRiders = 'true', limit = 10 } = req.query;

    if (!search || search.length < 2) {
      return errorResponse(res, 400, 'Search query must be at least 2 characters');
    }

    // Build query based on whether to exclude riders
    let whereClause = `is_active = true AND (username ILIKE $1 OR full_name ILIKE $1)`;
    if (excludeRiders === 'true') {
      whereClause += ` AND user_type = 'user'`;
    }

    const result = await query(
      `SELECT id, username, full_name, user_type, is_verified, kyc_status
       FROM users
       WHERE ${whereClause}
       LIMIT $2`,
      [`%${search}%`, limit]
    );

    return successResponse(res, 200, 'Users found', {
      users: result.rows.map((u) => ({
        id: u.id,
        username: u.username,
        fullName: u.full_name,
        userType: u.user_type,
        isVerified: u.is_verified,
        kycStatus: u.kyc_status,
      })),
    });
  } catch (error) {
    logger.error('Search users error:', error);
    return errorResponse(res, 500, 'Failed to search users');
  }
};

module.exports = {
  getTransactions,
  getTransactionStats,
  searchUsers,
};
