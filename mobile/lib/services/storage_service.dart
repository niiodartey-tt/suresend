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
}
