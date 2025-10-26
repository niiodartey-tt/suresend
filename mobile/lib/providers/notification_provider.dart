import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/notification.dart';
import '../services/notification_service.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationService _notificationService = NotificationService();

  List<Notification> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;
  Timer? _pollingTimer;

  // Getters
  List<Notification> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get error => _error;

  /// Fetch notifications
  Future<void> fetchNotifications({
    bool refresh = false,
    bool unreadOnly = false,
  }) async {
    if (_isLoading) return;

    if (refresh) {
      _notifications = [];
      _hasMore = true;
    }

    _setLoading(true);
    _clearError();

    try {
      final result = await _notificationService.getNotifications(
        limit: 20,
        offset: refresh ? 0 : _notifications.length,
        unreadOnly: unreadOnly,
      );

      if (result['success']) {
        final data = result['data'];
        final newNotifications = data['notifications'] as List<Notification>;

        if (refresh) {
          _notifications = newNotifications;
        } else {
          _notifications.addAll(newNotifications);
        }

        _unreadCount = data['unreadCount'] ?? 0;
        _hasMore = data['hasMore'] ?? false;
      } else {
        _error = result['error'] ?? 'Failed to fetch notifications';
      }
    } catch (e) {
      _error = e.toString();
    }

    _setLoading(false);
  }

  /// Fetch unread count only (for badge)
  Future<void> fetchUnreadCount() async {
    try {
      final result = await _notificationService.getNotifications(
        limit: 1,
        offset: 0,
        unreadOnly: true,
      );

      if (result['success']) {
        final data = result['data'];
        _unreadCount = data['unreadCount'] ?? 0;
        notifyListeners();
      }
    } catch (e) {
      // Silently fail for badge updates
    }
  }

  /// Mark notification as read
  Future<bool> markAsRead(String notificationId) async {
    try {
      final result = await _notificationService.markAsRead(notificationId);

      if (result['success']) {
        // Update local notification
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          _notifications[index] = _notifications[index].copyWith(
            isRead: true,
            readAt: DateTime.now(),
          );
          _unreadCount = _unreadCount > 0 ? _unreadCount - 1 : 0;
          notifyListeners();
        }
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// Mark all notifications as read
  Future<bool> markAllAsRead() async {
    try {
      final result = await _notificationService.markAllAsRead();

      if (result['success']) {
        // Update all local notifications
        _notifications = _notifications
            .map((n) => n.copyWith(isRead: true, readAt: DateTime.now()))
            .toList();
        _unreadCount = 0;
        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// Delete notification
  Future<bool> deleteNotification(String notificationId) async {
    try {
      final result =
          await _notificationService.deleteNotification(notificationId);

      if (result['success']) {
        // Remove from local list
        final notification =
            _notifications.firstWhere((n) => n.id == notificationId);
        _notifications.removeWhere((n) => n.id == notificationId);

        if (!notification.isRead) {
          _unreadCount = _unreadCount > 0 ? _unreadCount - 1 : 0;
        }

        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// Start polling for new notifications (every 30 seconds)
  void startPolling() {
    stopPolling(); // Clear any existing timer

    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      fetchUnreadCount();
    });
  }

  /// Stop polling
  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  /// Clear all notifications (local only)
  void clearNotifications() {
    _notifications = [];
    _unreadCount = 0;
    _hasMore = true;
    notifyListeners();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }
}
