import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  loading,
}

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();

  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _error;
  bool _isLoading = false;

  // Getters
  AuthStatus get status => _status;
  User? get user => _user;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  /// Initialize authentication
  Future<void> initAuth() async {
    _setLoading(true);

    try {
      final isAuth = await _authService.initAuth();

      if (isAuth) {
        // Fetch user profile
        final result = await _authService.getProfile();
        if (result['success']) {
          _user = result['data']['user'];
          _status = AuthStatus.authenticated;
        } else {
          _status = AuthStatus.unauthenticated;
        }
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _error = e.toString();
    }

    _setLoading(false);
  }

  /// Register a new user
  Future<Map<String, dynamic>> register({
    required String username,
    required String phoneNumber,
    required String password,
    required String fullName,
    required String userType,
    String? email,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authService.register(
        username: username,
        phoneNumber: phoneNumber,
        password: password,
        fullName: fullName,
        userType: userType,
        email: email,
      );

      if (!result['success']) {
        _error = result['error'] ?? 'Registration failed';
      }

      _setLoading(false);
      return result;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Login user
  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authService.login(
        identifier: identifier,
        password: password,
      );

      if (!result['success']) {
        _error = result['error'] ?? 'Login failed';
      }

      _setLoading(false);
      return result;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Verify OTP
  Future<Map<String, dynamic>> verifyOTP({
    required String phoneNumber,
    required String otpCode,
    required String purpose,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authService.verifyOTP(
        phoneNumber: phoneNumber,
        otpCode: otpCode,
        purpose: purpose,
      );

      if (result['success']) {
        _user = result['data'].user;
        _status = AuthStatus.authenticated;
      } else {
        _error = result['error'] ?? 'OTP verification failed';
      }

      _setLoading(false);
      return result;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
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
    _clearError();

    try {
      final result = await _authService.resendOTP(
        phoneNumber: phoneNumber,
        purpose: purpose,
      );

      if (!result['success']) {
        _error = result['error'] ?? 'Failed to resend OTP';
      }

      return result;
    } catch (e) {
      _error = e.toString();
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Logout user
  Future<void> logout() async {
    _setLoading(true);

    try {
      await _authService.logout();
      _user = null;
      _status = AuthStatus.unauthenticated;
    } catch (e) {
      _error = e.toString();
    }

    _setLoading(false);
  }

  /// Refresh user profile
  Future<void> refreshProfile() async {
    try {
      final result = await _authService.getProfile();
      if (result['success']) {
        _user = result['data']['user'];
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
    }
  }

  /// Update user profile
  Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    String? email,
  }) async {
    _clearError();

    try {
      final result = await _authService.updateProfile(
        fullName: fullName,
        email: email,
      );

      if (result['success']) {
        // Refresh profile
        await refreshProfile();
      } else {
        _error = result['error'] ?? 'Failed to update profile';
      }

      return result;
    } catch (e) {
      _error = e.toString();
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
