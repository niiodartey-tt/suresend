const { query } = require('../config/database');
const logger = require('../config/logger');
const { successResponse, errorResponse } = require('../utils/response');

/**
 * Get user notifications
 * GET /api/v1/notifications
 */
const getNotifications = async (req, res) => {
  try {
    const userId = req.user.id;
    const { limit = 20, offset = 0, unreadOnly = 'false' } = req.query;

    let queryText = `
      SELECT
        id,
        title,
        message,
        type,
        is_read,
        created_at,
        read_at
      FROM notifications
      WHERE user_id = $1
    `;

    const queryParams = [userId];

    if (unreadOnly === 'true') {
      queryText += ' AND is_read = false';
    }

    queryText += ` ORDER BY created_at DESC LIMIT $2 OFFSET $3`;
    queryParams.push(limit, offset);

    const result = await query(queryText, queryParams);

    // Get unread count
    const unreadCountResult = await query(
      'SELECT COUNT(*) as count FROM notifications WHERE user_id = $1 AND is_read = false',
      [userId]
    );

    return successResponse(res, 200, 'Notifications retrieved successfully', {
      notifications: result.rows,
      unreadCount: parseInt(unreadCountResult.rows[0].count),
      hasMore: result.rows.length === parseInt(limit),
    });
  } catch (error) {
    logger.error('Get notifications error:', error);
    return errorResponse(res, 500, 'Failed to retrieve notifications');
  }
};

/**
 * Mark notification as read
 * PUT /api/v1/notifications/:id/read
 */
const markAsRead = async (req, res) => {
  try {
    const userId = req.user.id;
    const { id } = req.params;

    const result = await query(
      `UPDATE notifications
       SET is_read = true, read_at = NOW()
       WHERE id = $1 AND user_id = $2
       RETURNING *`,
      [id, userId]
    );

    if (result.rows.length === 0) {
      return errorResponse(res, 404, 'Notification not found');
    }

    return successResponse(res, 200, 'Notification marked as read', {
      notification: result.rows[0],
    });
  } catch (error) {
    logger.error('Mark notification as read error:', error);
    return errorResponse(res, 500, 'Failed to mark notification as read');
  }
};

/**
 * Mark all notifications as read
 * PUT /api/v1/notifications/read-all
 */
const markAllAsRead = async (req, res) => {
  try {
    const userId = req.user.id;

    await query(
      `UPDATE notifications
       SET is_read = true, read_at = NOW()
       WHERE user_id = $1 AND is_read = false`,
      [userId]
    );

    return successResponse(res, 200, 'All notifications marked as read');
  } catch (error) {
    logger.error('Mark all as read error:', error);
    return errorResponse(res, 500, 'Failed to mark all notifications as read');
  }
};

/**
 * Delete notification
 * DELETE /api/v1/notifications/:id
 */
const deleteNotification = async (req, res) => {
  try {
    const userId = req.user.id;
    const { id } = req.params;

    const result = await query(
      'DELETE FROM notifications WHERE id = $1 AND user_id = $2 RETURNING *',
      [id, userId]
    );

    if (result.rows.length === 0) {
      return errorResponse(res, 404, 'Notification not found');
    }

    return successResponse(res, 200, 'Notification deleted successfully');
  } catch (error) {
    logger.error('Delete notification error:', error);
    return errorResponse(res, 500, 'Failed to delete notification');
  }
};

module.exports = {
  getNotifications,
  markAsRead,
  markAllAsRead,
  deleteNotification,
};
