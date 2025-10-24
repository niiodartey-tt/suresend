class AppConfig {
  // API Configuration
  static const String apiBaseUrl = 'http://localhost:3000/api/v1';
  static const String apiVersion = 'v1';

  // Development mode
  static const bool isDevelopment = true;

  // App Information
  static const String appName = 'SureSend';
  static const String appVersion = '1.0.0';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // OTP Configuration
  static const int otpLength = 6;
  static const Duration otpExpiry = Duration(minutes: 5);

  // Commission Rate
  static const double commissionRate = 0.02; // 2%

  // Currency
  static const String currency = 'GHS';
  static const String currencySymbol = '₵';

  // Pagination
  static const int defaultPageSize = 20;

  // File Upload
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png'];

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String userTypeKey = 'user_type';

  // Phone Number
  static const String defaultCountryCode = 'GH';
  static const String defaultDialCode = '+233';
}
