const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const {
  getNotifications,
  markAsRead,
  markAllAsRead,
  deleteNotification,
} = require('../controllers/notificationController');

// All routes require authentication
router.use(authenticate);

// @route   GET /api/v1/notifications
// @desc    Get user notifications
// @access  Private
router.get('/', getNotifications);

// @route   PUT /api/v1/notifications/read-all
// @desc    Mark all notifications as read
// @access  Private
router.put('/read-all', markAllAsRead);

// @route   PUT /api/v1/notifications/:id/read
// @desc    Mark notification as read
// @access  Private
router.put('/:id/read', markAsRead);

// @route   DELETE /api/v1/notifications/:id
// @desc    Delete notification
// @access  Private
router.delete('/:id', deleteNotification);

module.exports = router;
