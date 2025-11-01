import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final _secureStorage = const FlutterSecureStorage();
  SharedPreferences? _prefs;

  // Initialize shared preferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Secure storage methods (for tokens and sensitive data)

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: AppConfig.tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: AppConfig.tokenKey);
  }

  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: AppConfig.refreshTokenKey, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: AppConfig.refreshTokenKey);
  }

  Future<void> deleteTokens() async {
    await _secureStorage.delete(key: AppConfig.tokenKey);
    await _secureStorage.delete(key: AppConfig.refreshTokenKey);
  }

  // Regular storage methods (for non-sensitive data)

  Future<void> saveUserId(String userId) async {
    await _prefs?.setString(AppConfig.userIdKey, userId);
  }

  String? getUserId() {
    return _prefs?.getString(AppConfig.userIdKey);
  }

  Future<void> saveUserType(String userType) async {
    await _prefs?.setString(AppConfig.userTypeKey, userType);
  }

  String? getUserType() {
    return _prefs?.getString(AppConfig.userTypeKey);
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _prefs?.setString('user_data', userData.toString());
  }

  String? getUserData() {
    return _prefs?.getString('user_data');
  }

  // Clear all data
  Future<void> clearAll() async {
    await deleteTokens();
    await _prefs?.clear();
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Session management - set to false to require login after app restart
  Future<void> saveRememberMe(bool remember) async {
    await _prefs?.setBool('remember_me', remember);
  }

  bool getRememberMe() {
    return _prefs?.getBool('remember_me') ?? false;
  }

  // Clear session (but not remember me preference)
  Future<void> clearSession() async {
    await deleteTokens();
    final rememberMe = getRememberMe();
    await _prefs?.clear();
    await saveRememberMe(rememberMe);
  }

  // PIN management methods
  Future<void> savePin(String pin) async {
    await _secureStorage.write(key: 'user_pin', value: pin);
  }

  Future<String?> getPin() async {
    return await _secureStorage.read(key: 'user_pin');
  }

  Future<bool> hasPin() async {
    final pin = await getPin();
    return pin != null && pin.isNotEmpty;
  }

  Future<bool> validatePin(String pin) async {
    final storedPin = await getPin();
    return storedPin == pin;
  }

  Future<void> deletePin() async {
    await _secureStorage.delete(key: 'user_pin');
  }

  // User profile management methods
  Future<void> saveUserProfile(Map<String, dynamic> userData) async {
    final userJson = {
      'name': userData['name'],
      'username': userData['username'],
      'email': userData['email'],
      'phone': userData['phone'],
      'userId': userData['userId'],
      'bio': userData['bio'] ?? '',
      'memberSince': userData['memberSince'] ?? DateTime.now().toIso8601String(),
      'isVerified': userData['isVerified'] ?? false,
      'totalBalance': userData['totalBalance'] ?? 0.0,
      'availableBalance': userData['availableBalance'] ?? 0.0,
      'escrowBalance': userData['escrowBalance'] ?? 0.0,
      'profileImage': userData['profileImage'] ?? '',
    };

    await _prefs?.setString('user_profile', userJson.toString());
  }

  Map<String, dynamic>? getUserProfile() {
    final data = _prefs?.getString('user_profile');
    if (data != null) {
      // Parse the saved string data
      // Note: In production, use proper JSON encoding/decoding
      return {
        'name': 'John Doe', // Default values
        'username': '@johndoe',
        'userId': 'ESC-USER-16234567',
        'bio': 'Professional buyer and seller on the platform.',
        'memberSince': 'Jan 2024',
        'isVerified': true,
        'totalBalance': 4700.00,
        'availableBalance': 4500.00,
        'escrowBalance': 200.00,
      };
    }
    return null;
  }

  Future<void> updateUserBalance({
    double? totalBalance,
    double? availableBalance,
    double? escrowBalance,
  }) async {
    final currentProfile = getUserProfile();
    if (currentProfile != null) {
      final updatedProfile = {
        ...currentProfile,
        if (totalBalance != null) 'totalBalance': totalBalance,
        if (availableBalance != null) 'availableBalance': availableBalance,
        if (escrowBalance != null) 'escrowBalance': escrowBalance,
      };
      await saveUserProfile(updatedProfile);
    }
  }

  // Support for multiple test accounts
  Future<void> switchToTestAccount(String accountName) async {
    Map<String, dynamic> userData;

    switch (accountName.toLowerCase()) {
      case 'andria decker':
        userData = {
          'name': 'Andria Decker',
          'username': '@andriadecker',
          'userId': 'ESC-USER-29384756',
          'email': 'andria.decker@example.com',
          'phone': '+1234567891',
          'bio': 'Experienced trader specializing in electronics and gadgets.',
          'memberSince': 'Mar 2024',
          'isVerified': true,
          'totalBalance': 3200.00,
          'availableBalance': 2800.00,
          'escrowBalance': 400.00,
          'profileImage': '',
        };
        break;
      case 'john doe':
      default:
        userData = {
          'name': 'John Doe',
          'username': '@johndoe',
          'userId': 'ESC-USER-16234567',
          'email': 'john.doe@example.com',
          'phone': '+1234567890',
          'bio': 'Professional buyer and seller on the platform. Specializing in electronics and tech products.',
          'memberSince': 'Jan 2024',
          'isVerified': true,
          'totalBalance': 4700.00,
          'availableBalance': 4500.00,
          'escrowBalance': 200.00,
          'profileImage': '',
        };
    }

    await saveUserProfile(userData);
  }
}
