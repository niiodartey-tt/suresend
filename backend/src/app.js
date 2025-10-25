const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const rateLimit = require('express-rate-limit');
const logger = require('./config/logger');

const app = express();

// Security middleware
app.use(helmet());

// CORS configuration
const corsOptions = {
  origin: process.env.ALLOWED_ORIGINS?.split(',') || ['http://localhost:3000'],
  credentials: true,
  optionsSuccessStatus: 200,
};
app.use(cors(corsOptions));

// Rate limiting
const limiter = rateLimit({
  windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 15 * 60 * 1000, // 15 minutes
  max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS) || 100,
  message: 'Too many requests from this IP, please try again later.',
});
app.use('/api', limiter);

// Body parser middleware
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// HTTP request logger
if (process.env.NODE_ENV === 'development') {
  app.use(morgan('dev'));
} else {
  app.use(morgan('combined', {
    stream: { write: (message) => logger.info(message.trim()) },
  }));
}

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'success',
    message: 'SureSend API is running',
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV,
  });
});

// API Routes
app.get('/api', (req, res) => {
  res.status(200).json({
    status: 'success',
    message: 'Welcome to SureSend API',
    version: process.env.API_VERSION || 'v1',
    endpoints: {
      health: '/health',
      api: '/api',
      auth: {
        register: 'POST /api/v1/auth/register',
        login: 'POST /api/v1/auth/login',
        verifyOTP: 'POST /api/v1/auth/verify-otp',
        resendOTP: 'POST /api/v1/auth/resend-otp',
        logout: 'POST /api/v1/auth/logout',
      },
      users: {
        profile: 'GET /api/v1/users/profile',
        updateProfile: 'PUT /api/v1/users/profile',
        kycStatus: 'GET /api/v1/users/kyc-status',
        submitKYC: 'POST /api/v1/users/kyc',
      },
      escrow: {
        create: 'POST /api/v1/escrow/create',
        details: 'GET /api/v1/escrow/:id',
        confirmDelivery: 'POST /api/v1/escrow/:id/confirm-delivery',
        dispute: 'POST /api/v1/escrow/:id/dispute',
        cancel: 'POST /api/v1/escrow/:id/cancel',
      },
      transactions: {
        list: 'GET /api/v1/transactions',
        stats: 'GET /api/v1/transactions/stats',
        searchUsers: 'GET /api/v1/transactions/search-users',
      },
      notifications: {
        list: 'GET /api/v1/notifications',
        markAsRead: 'PUT /api/v1/notifications/:id/read',
        markAllAsRead: 'PUT /api/v1/notifications/read-all',
        delete: 'DELETE /api/v1/notifications/:id',
      },
      wallet: {
        details: 'GET /api/v1/wallet',
        transactions: 'GET /api/v1/wallet/transactions',
        fund: 'POST /api/v1/wallet/fund',
        withdraw: 'POST /api/v1/wallet/withdraw',
        transfer: 'POST /api/v1/wallet/transfer',
      },
    },
  });
});

// Import routes
const authRoutes = require('./routes/auth');
const userRoutes = require('./routes/users');
const escrowRoutes = require('./routes/escrow');
const transactionRoutes = require('./routes/transactions');
const notificationRoutes = require('./routes/notifications');
const walletRoutes = require('./routes/wallet');

// Use routes
app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/users', userRoutes);
app.use('/api/v1/escrow', escrowRoutes);
app.use('/api/v1/transactions', transactionRoutes);
app.use('/api/v1/notifications', notificationRoutes);
app.use('/api/v1/wallet', walletRoutes);

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    status: 'error',
    message: 'Route not found',
    path: req.originalUrl,
  });
});

// Global error handler
app.use((err, req, res, next) => {
  logger.error('Error:', {
    message: err.message,
    stack: err.stack,
    url: req.originalUrl,
    method: req.method,
  });

  res.status(err.statusCode || 500).json({
    status: 'error',
    message: err.message || 'Internal server error',
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack }),
  });
});

module.exports = app;
