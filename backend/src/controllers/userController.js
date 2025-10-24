const { query } = require('../config/database');
const { successResponse, errorResponse } = require('../utils/response');
const { updateProfileSchema } = require('../utils/validation');
const logger = require('../config/logger');

/**
 * Get user profile
 * GET /api/v1/users/profile
 */
const getProfile = async (req, res) => {
  try {
    const userId = req.user.userId;

    // Get user details
    const userResult = await query(
      `SELECT id, username, phone_number, full_name, user_type, email,
              is_verified, kyc_status, profile_image_url, created_at, last_login_at
       FROM users
       WHERE id = $1`,
      [userId]
    );

    if (userResult.rows.length === 0) {
      return errorResponse(res, 404, 'User not found');
    }

    const user = userResult.rows[0];

    // Get wallet balance
    const walletResult = await query(
      'SELECT balance, currency FROM wallets WHERE user_id = $1',
      [userId]
    );

    // Get transaction count
    const transactionResult = await query(
      `SELECT COUNT(*) as total_transactions,
              SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as completed_transactions
       FROM transactions
       WHERE buyer_id = $1 OR seller_id = $1`,
      [userId]
    );

    return successResponse(res, 200, 'Profile retrieved successfully', {
      user: {
        id: user.id,
        username: user.username,
        phoneNumber: user.phone_number,
        fullName: user.full_name,
        userType: user.user_type,
        email: user.email,
        isVerified: user.is_verified,
        kycStatus: user.kyc_status,
        profileImage: user.profile_image_url,
        createdAt: user.created_at,
        lastLoginAt: user.last_login_at,
      },
      wallet: {
        balance: walletResult.rows[0]?.balance || 0,
        currency: walletResult.rows[0]?.currency || 'GHS',
      },
      stats: {
        totalTransactions: parseInt(transactionResult.rows[0]?.total_transactions || 0),
        completedTransactions: parseInt(transactionResult.rows[0]?.completed_transactions || 0),
      },
    });
  } catch (error) {
    logger.error('Get profile error:', error);
    return errorResponse(res, 500, 'Failed to retrieve profile', error.message);
  }
};

/**
 * Update user profile
 * PUT /api/v1/users/profile
 */
const updateProfile = async (req, res) => {
  try {
    const userId = req.user.userId;

    // Validate request body
    const { error, value } = updateProfileSchema.validate(req.body);
    if (error) {
      return errorResponse(res, 400, 'Validation error', error.details);
    }

    const { fullName, email } = value;

    // Build update query dynamically
    const updates = [];
    const values = [];
    let paramIndex = 1;

    if (fullName) {
      updates.push(`full_name = $${paramIndex++}`);
      values.push(fullName);
    }

    if (email !== undefined) {
      updates.push(`email = $${paramIndex++}`);
      values.push(email || null);
    }

    if (updates.length === 0) {
      return errorResponse(res, 400, 'No fields to update');
    }

    values.push(userId);

    // Update user
    const updateQuery = `
      UPDATE users
      SET ${updates.join(', ')}
      WHERE id = $${paramIndex}
      RETURNING id, username, phone_number, full_name, user_type, email, is_verified, kyc_status
    `;

    const result = await query(updateQuery, values);

    logger.info(`Profile updated for user: ${userId}`);

    return successResponse(res, 200, 'Profile updated successfully', {
      user: result.rows[0],
    });
  } catch (error) {
    logger.error('Update profile error:', error);
    return errorResponse(res, 500, 'Failed to update profile', error.message);
  }
};

/**
 * Get KYC status
 * GET /api/v1/users/kyc-status
 */
const getKYCStatus = async (req, res) => {
  try {
    const userId = req.user.userId;

    // Get KYC documents
    const result = await query(
      `SELECT id, document_type, status, rejection_reason, uploaded_at, verified_at
       FROM kyc_documents
       WHERE user_id = $1
       ORDER BY uploaded_at DESC`,
      [userId]
    );

    // Get user KYC status
    const userResult = await query(
      'SELECT kyc_status FROM users WHERE id = $1',
      [userId]
    );

    return successResponse(res, 200, 'KYC status retrieved successfully', {
      kycStatus: userResult.rows[0]?.kyc_status || 'pending',
      documents: result.rows,
    });
  } catch (error) {
    logger.error('Get KYC status error:', error);
    return errorResponse(res, 500, 'Failed to retrieve KYC status', error.message);
  }
};

/**
 * Submit KYC document
 * POST /api/v1/users/kyc
 */
const submitKYC = async (req, res) => {
  try {
    const userId = req.user.userId;
    const { documentType, documentUrl } = req.body;

    // Validate input
    if (!documentType || !documentUrl) {
      return errorResponse(res, 400, 'Document type and URL are required');
    }

    const validTypes = ['id_card', 'selfie', 'passport', 'drivers_license'];
    if (!validTypes.includes(documentType)) {
      return errorResponse(res, 400, 'Invalid document type');
    }

    // Insert KYC document
    const result = await query(
      `INSERT INTO kyc_documents (user_id, document_type, document_url, status)
       VALUES ($1, $2, $3, 'pending')
       RETURNING id, document_type, document_url, status, uploaded_at`,
      [userId, documentType, documentUrl]
    );

    logger.info(`KYC document submitted: ${documentType} for user ${userId}`);

    return successResponse(res, 201, 'KYC document submitted successfully', {
      document: result.rows[0],
    });
  } catch (error) {
    logger.error('Submit KYC error:', error);
    return errorResponse(res, 500, 'Failed to submit KYC document', error.message);
  }
};

module.exports = {
  getProfile,
  updateProfile,
  getKYCStatus,
  submitKYC,
};
