const { query, getClient } = require('../config/database');
const { hashPassword, comparePassword } = require('../utils/password');
const { generateAccessToken, generateRefreshToken } = require('../utils/jwt');
const { generateOTP, getOTPExpiry, isOTPExpired, sendOTP } = require('../utils/otp');
const { successResponse, errorResponse } = require('../utils/response');
const {
  registerSchema,
  loginSchema,
  verifyOTPSchema,
  resendOTPSchema,
} = require('../utils/validation');
const logger = require('../config/logger');

/**
 * Register a new user
 * POST /api/v1/auth/register
 */
const register = async (req, res) => {
  try {
    // Validate request body
    const { error, value } = registerSchema.validate(req.body);
    if (error) {
      return errorResponse(res, 400, 'Validation error', error.details);
    }

    const { username, phoneNumber, password, fullName, userType, email } = value;

    // Check if username already exists
    const userCheck = await query(
      'SELECT id FROM users WHERE username = $1 OR phone_number = $2',
      [username, phoneNumber]
    );

    if (userCheck.rows.length > 0) {
      return errorResponse(res, 409, 'Username or phone number already exists');
    }

    // Hash password
    const passwordHash = await hashPassword(password);

    // Generate OTP
    const otpCode = generateOTP();
    const otpExpiry = getOTPExpiry();

    // Start transaction
    const client = await getClient();

    try {
      await client.query('BEGIN');

      // Insert user
      const userResult = await client.query(
        `INSERT INTO users (username, phone_number, password_hash, full_name, user_type, email)
         VALUES ($1, $2, $3, $4, $5, $6)
         RETURNING id, username, phone_number, full_name, user_type, email, created_at`,
        [username, phoneNumber, passwordHash, fullName, userType, email || null]
      );

      const user = userResult.rows[0];

      // Create wallet for user
      await client.query(
        'INSERT INTO wallets (user_id, balance) VALUES ($1, $2)',
        [user.id, 0.00]
      );

      // Store OTP
      await client.query(
        `INSERT INTO otp_verifications (phone_number, otp_code, purpose, expires_at)
         VALUES ($1, $2, $3, $4)`,
        [phoneNumber, otpCode, 'registration', otpExpiry]
      );

      await client.query('COMMIT');

      // Send OTP via SMS
      await sendOTP(phoneNumber, otpCode, 'registration');

      logger.info(`User registered: ${username} (${user.id})`);

      return successResponse(res, 201, 'Registration successful. OTP sent to your phone.', {
        user: {
          id: user.id,
          username: user.username,
          phoneNumber: user.phone_number,
          fullName: user.full_name,
          userType: user.user_type,
          email: user.email,
        },
        requiresOTP: true,
      });
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  } catch (error) {
    logger.error('Registration error:', error);
    return errorResponse(res, 500, 'Registration failed', error.message);
  }
};

/**
 * Login user (Step 1: Validate credentials)
 * POST /api/v1/auth/login
 */
const login = async (req, res) => {
  try {
    // Validate request body
    const { error, value } = loginSchema.validate(req.body);
    if (error) {
      return errorResponse(res, 400, 'Validation error', error.details);
    }

    const { identifier, password } = value;

    // Find user by username or phone number
    const userResult = await query(
      `SELECT id, username, phone_number, password_hash, full_name, user_type,
              email, is_verified, is_active, kyc_status
       FROM users
       WHERE username = $1 OR phone_number = $1`,
      [identifier]
    );

    if (userResult.rows.length === 0) {
      return errorResponse(res, 401, 'Invalid credentials');
    }

    const user = userResult.rows[0];

    // Check if account is active
    if (!user.is_active) {
      return errorResponse(res, 403, 'Account is deactivated. Please contact support.');
    }

    // Verify password
    const isPasswordValid = await comparePassword(password, user.password_hash);
    if (!isPasswordValid) {
      return errorResponse(res, 401, 'Invalid credentials');
    }

    // Generate and send OTP for 2FA
    const otpCode = generateOTP();
    const otpExpiry = getOTPExpiry();

    await query(
      `INSERT INTO otp_verifications (phone_number, otp_code, purpose, expires_at)
       VALUES ($1, $2, $3, $4)`,
      [user.phone_number, otpCode, 'login', otpExpiry]
    );

    // Send OTP via SMS
    await sendOTP(user.phone_number, otpCode, 'login');

    logger.info(`Login OTP sent to user: ${user.username} (${user.id})`);

    return successResponse(res, 200, 'Credentials verified. OTP sent to your phone.', {
      phoneNumber: user.phone_number,
      requiresOTP: true,
    });
  } catch (error) {
    logger.error('Login error:', error);
    return errorResponse(res, 500, 'Login failed', error.message);
  }
};

/**
 * Verify OTP and complete authentication
 * POST /api/v1/auth/verify-otp
 */
const verifyOTP = async (req, res) => {
  try {
    // Validate request body
    const { error, value } = verifyOTPSchema.validate(req.body);
    if (error) {
      return errorResponse(res, 400, 'Validation error', error.details);
    }

    const { phoneNumber, otpCode, purpose } = value;

    // Find OTP record
    const otpResult = await query(
      `SELECT id, otp_code, expires_at, verified, attempts
       FROM otp_verifications
       WHERE phone_number = $1 AND purpose = $2 AND verified = false
       ORDER BY created_at DESC
       LIMIT 1`,
      [phoneNumber, purpose]
    );

    if (otpResult.rows.length === 0) {
      return errorResponse(res, 404, 'No OTP found. Please request a new one.');
    }

    const otpRecord = otpResult.rows[0];

    // Check if OTP is expired
    if (isOTPExpired(otpRecord.expires_at)) {
      return errorResponse(res, 400, 'OTP has expired. Please request a new one.');
    }

    // Check attempts (max 3)
    if (otpRecord.attempts >= 3) {
      return errorResponse(res, 429, 'Too many failed attempts. Please request a new OTP.');
    }

    // Verify OTP
    if (otpRecord.otp_code !== otpCode) {
      // Increment attempts
      await query(
        'UPDATE otp_verifications SET attempts = attempts + 1 WHERE id = $1',
        [otpRecord.id]
      );
      return errorResponse(res, 401, 'Invalid OTP code');
    }

    // Mark OTP as verified
    await query(
      'UPDATE otp_verifications SET verified = true, verified_at = CURRENT_TIMESTAMP WHERE id = $1',
      [otpRecord.id]
    );

    // Get user details
    const userResult = await query(
      `SELECT id, username, phone_number, full_name, user_type, email,
              is_verified, kyc_status, profile_image_url
       FROM users
       WHERE phone_number = $1`,
      [phoneNumber]
    );

    if (userResult.rows.length === 0) {
      return errorResponse(res, 404, 'User not found');
    }

    const user = userResult.rows[0];

    // Mark user as verified if registration OTP
    if (purpose === 'registration' && !user.is_verified) {
      await query('UPDATE users SET is_verified = true WHERE id = $1', [user.id]);
      user.is_verified = true;
    }

    // Update last login
    await query('UPDATE users SET last_login_at = CURRENT_TIMESTAMP WHERE id = $1', [user.id]);

    // Get wallet balance
    const walletResult = await query(
      'SELECT balance FROM wallets WHERE user_id = $1',
      [user.id]
    );

    // Generate JWT tokens
    const accessToken = generateAccessToken({
      userId: user.id,
      username: user.username,
      userType: user.user_type,
    });

    const refreshToken = generateRefreshToken({
      userId: user.id,
    });

    logger.info(`OTP verified for user: ${user.username} (${user.id})`);

    return successResponse(res, 200, 'Authentication successful', {
      accessToken,
      refreshToken,
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
        walletBalance: walletResult.rows[0]?.balance || 0,
      },
    });
  } catch (error) {
    logger.error('OTP verification error:', error);
    return errorResponse(res, 500, 'OTP verification failed', error.message);
  }
};

/**
 * Resend OTP
 * POST /api/v1/auth/resend-otp
 */
const resendOTP = async (req, res) => {
  try {
    // Validate request body
    const { error, value } = resendOTPSchema.validate(req.body);
    if (error) {
      return errorResponse(res, 400, 'Validation error', error.details);
    }

    const { phoneNumber, purpose } = value;

    // Check if user exists
    const userCheck = await query(
      'SELECT id FROM users WHERE phone_number = $1',
      [phoneNumber]
    );

    if (userCheck.rows.length === 0) {
      return errorResponse(res, 404, 'Phone number not registered');
    }

    // Generate new OTP
    const otpCode = generateOTP();
    const otpExpiry = getOTPExpiry();

    // Store new OTP
    await query(
      `INSERT INTO otp_verifications (phone_number, otp_code, purpose, expires_at)
       VALUES ($1, $2, $3, $4)`,
      [phoneNumber, otpCode, purpose, otpExpiry]
    );

    // Send OTP via SMS
    await sendOTP(phoneNumber, otpCode, purpose);

    logger.info(`OTP resent to: ${phoneNumber}`);

    return successResponse(res, 200, 'New OTP sent to your phone', {
      phoneNumber,
    });
  } catch (error) {
    logger.error('Resend OTP error:', error);
    return errorResponse(res, 500, 'Failed to resend OTP', error.message);
  }
};

/**
 * Logout user
 * POST /api/v1/auth/logout
 */
const logout = async (req, res) => {
  try {
    // In a stateless JWT system, logout is handled client-side
    // Here we can add token to blacklist if needed (future enhancement)

    logger.info(`User logged out: ${req.user?.userId}`);

    return successResponse(res, 200, 'Logged out successfully');
  } catch (error) {
    logger.error('Logout error:', error);
    return errorResponse(res, 500, 'Logout failed', error.message);
  }
};

module.exports = {
  register,
  login,
  verifyOTP,
  resendOTP,
  logout,
};
