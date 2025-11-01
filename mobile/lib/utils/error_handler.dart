import 'package:flutter/material.dart';

/// Custom app exception
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  AppException(this.message, {this.code, this.details});

  @override
  String toString() => message;
}

/// Error handler utility
class ErrorHandler {
  /// Show error snackbar
  static void showError(BuildContext context, dynamic error) {
    String message = _getErrorMessage(error);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Show success snackbar
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show warning snackbar
  static void showWarning(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_outlined, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show info snackbar
  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show error dialog
  static Future<void> showErrorDialog(
    BuildContext context,
    dynamic error, {
    String? title,
    VoidCallback? onRetry,
  }) async {
    String message = _getErrorMessage(error);

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 12),
            Text(title ?? 'Error'),
          ],
        ),
        content: Text(message),
        actions: [
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onRetry();
              },
              child: const Text('Retry'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Get user-friendly error message
  static String _getErrorMessage(dynamic error) {
    if (error == null) return 'An unknown error occurred';

    if (error is AppException) {
      return error.message;
    }

    if (error is String) {
      return error;
    }

    // Handle common error patterns
    String errorString = error.toString();

    if (errorString.contains('SocketException') ||
        errorString.contains('NetworkError')) {
      return 'Network error. Please check your internet connection.';
    }

    if (errorString.contains('TimeoutException')) {
      return 'Request timed out. Please try again.';
    }

    if (errorString.contains('FormatException')) {
      return 'Invalid data format received.';
    }

    if (errorString.contains('Unauthorized') || errorString.contains('401')) {
      return 'Session expired. Please login again.';
    }

    if (errorString.contains('Forbidden') || errorString.contains('403')) {
      return 'You don\'t have permission to perform this action.';
    }

    if (errorString.contains('Not Found') || errorString.contains('404')) {
      return 'Resource not found.';
    }

    if (errorString.contains('Server Error') || errorString.contains('500')) {
      return 'Server error. Please try again later.';
    }

    // Return original error message if no pattern matches
    return errorString.length > 100
        ? '${errorString.substring(0, 100)}...'
        : errorString;
  }

  /// Handle API response errors
  static String handleApiError(Map<String, dynamic> response) {
    if (response['success'] == false) {
      if (response['error'] != null) {
        return response['error'].toString();
      }
      if (response['message'] != null) {
        return response['message'].toString();
      }
      return 'Request failed. Please try again.';
    }
    return 'Unknown error occurred';
  }

  /// Log error (can be extended to send to error tracking service)
  static void logError(dynamic error, {StackTrace? stackTrace}) {
    // In production, send to error tracking service (e.g., Sentry, Firebase Crashlytics)
    debugPrint('Error: $error');
    if (stackTrace != null) {
      debugPrint('Stack trace: $stackTrace');
    }
  }
}
