import '../models/notification.dart';
import 'api_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final ApiService _apiService = ApiService();

  /// Get notifications
  Future<Map<String, dynamic>> getNotifications({
    int limit = 20,
    int offset = 0,
    bool unreadOnly = false,
  }) async {
    try {
      final result = await _apiService.get(
        'notifications?limit=$limit&offset=$offset&unreadOnly=$unreadOnly',
        requiresAuth: true,
      );

      if (result['success']) {
        final backendData = result['data']['data'] ?? result['data'];
        final notificationsList = backendData['notifications'] as List;
        final notifications = notificationsList
            .map((json) => Notification.fromJson(json))
            .toList();

        return {
          'success': true,
          'data': {
            'notifications': notifications,
            'unreadCount': backendData['unreadCount'] ?? 0,
            'hasMore': backendData['hasMore'] ?? false,
          },
        };
      }

      return result;
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Mark notification as read
  Future<Map<String, dynamic>> markAsRead(String notificationId) async {
    try {
      final result = await _apiService.put(
        'notifications/$notificationId/read',
        requiresAuth: true,
      );

      return result;
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Mark all notifications as read
  Future<Map<String, dynamic>> markAllAsRead() async {
    try {
      final result = await _apiService.put(
        'notifications/read-all',
        requiresAuth: true,
      );

      return result;
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Delete notification
  Future<Map<String, dynamic>> deleteNotification(String notificationId) async {
    try {
      final result = await _apiService.delete(
        'notifications/$notificationId',
        requiresAuth: true,
      );

      return result;
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}
