import '../models/auth_response.dart';
import '../models/user.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  /// Register a new user
  Future<Map<String, dynamic>> register({
    required String username,
    required String phoneNumber,
    required String password,
    required String fullName,
    required String userType,
    String? email,
  }) async {
    try {
      final result = await _apiService.post(
        'auth/register',
        body: {
          'username': username,
          'phoneNumber': phoneNumber,
          'password': password,
          'fullName': fullName,
          'userType': userType,
          if (email != null && email.isNotEmpty) 'email': email,
        },
      );

      if (result['success']) {
        // Backend response structure: { status, message, data: { user, requiresOTP } }
        // API service wraps it as: { success, data: <backend response> }
        final backendData = result['data']['data'] ?? result['data'];
        final authResponse = AuthResponse.fromJson(backendData);
        return {
          'success': true,
          'data': authResponse,
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

  /// Login user (sends OTP)
  Future<Map<String, dynamic>> login({
    required String identifier, // username or phone
    required String password,
  }) async {
    try {
      final result = await _apiService.post(
        'auth/login',
        body: {
          'identifier': identifier,
          'password': password,
        },
      );

      if (result['success']) {
        // Backend response structure: { status, message, data: { phoneNumber, requiresOTP } }
        // API service wraps it as: { success, data: <backend response> }
        final backendData = result['data']['data'] ?? result['data'];
        final authResponse = AuthResponse.fromJson(backendData);
        return {
          'success': true,
          'data': authResponse,
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

  /// Verify OTP and complete authentication
  Future<Map<String, dynamic>> verifyOTP({
    required String phoneNumber,
    required String otpCode,
    required String purpose, // 'registration' or 'login'
  }) async {
    try {
      final result = await _apiService.post(
        'auth/verify-otp',
        body: {
          'phoneNumber': phoneNumber,
          'otpCode': otpCode,
          'purpose': purpose,
        },
      );

      if (result['success']) {
        // Backend response structure: { status, message, data: { accessToken, refreshToken, user } }
        // API service wraps it as: { success, data: <backend response> }
        final backendData = result['data']['data'] ?? result['data'];
        final authResponse = AuthResponse.fromJson(backendData);

        // Store tokens and user data
        if (authResponse.accessToken != null) {
          await _storageService.saveToken(authResponse.accessToken!);
          _apiService.setAuthToken(authResponse.accessToken!);
        }

        if (authResponse.refreshToken != null) {
          await _storageService.saveRefreshToken(authResponse.refreshToken!);
        }

        if (authResponse.user != null) {
          await _storageService.saveUserId(authResponse.user!.id);
          await _storageService.saveUserType(authResponse.user!.userType);
        }

        return {
          'success': true,
          'data': authResponse,
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

  /// Resend OTP
  Future<Map<String, dynamic>> resendOTP({
    required String phoneNumber,
    required String purpose,
  }) async {
    try {
      final result = await _apiService.post(
        'auth/resend-otp',
        body: {
          'phoneNumber': phoneNumber,
          'purpose': purpose,
        },
      );

      return result;
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Logout user
  Future<Map<String, dynamic>> logout() async {
    try {
      final result = await _apiService.post(
        'auth/logout',
        requiresAuth: true,
      );

      // Clear local storage regardless of API response
      await _storageService.clearAll();
      _apiService.clearAuthToken();

      return {
        'success': true,
        'message': 'Logged out successfully',
      };
    } catch (e) {
      // Still clear local data even if API call fails
      await _storageService.clearAll();
      _apiService.clearAuthToken();

      return {
        'success': true,
        'message': 'Logged out successfully',
      };
    }
  }

  /// Get user profile
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final result = await _apiService.get(
        'users/profile',
        requiresAuth: true,
      );

      if (result['success']) {
        // Backend response structure: { status, message, data: { user, wallet, stats } }
        // API service wraps it as: { success, data: <backend response> }
        final backendData = result['data']['data'] ?? result['data'];
        final user = User.fromJson(backendData['user']);
        return {
          'success': true,
          'data': {
            'user': user,
            'wallet': backendData['wallet'],
            'stats': backendData['stats'],
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

  /// Update user profile
  Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    String? email,
  }) async {
    try {
      final result = await _apiService.put(
        'users/profile',
        requiresAuth: true,
        body: {
          if (fullName != null) 'fullName': fullName,
          if (email != null) 'email': email,
        },
      );

      return result;
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return await _storageService.isLoggedIn();
  }

  /// Initialize authentication (check stored token)
  Future<bool> initAuth() async {
    final token = await _storageService.getToken();
    if (token != null && token.isNotEmpty) {
      _apiService.setAuthToken(token);
      return true;
    }
    return false;
  }
}
