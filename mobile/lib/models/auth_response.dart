import 'user.dart';

class AuthResponse {
  final String? accessToken;
  final String? refreshToken;
  final User? user;
  final bool requiresOTP;
  final String? phoneNumber;

  AuthResponse({
    this.accessToken,
    this.refreshToken,
    this.user,
    this.requiresOTP = false,
    this.phoneNumber,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      requiresOTP: json['requiresOTP'] ?? false,
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': user?.toJson(),
      'requiresOTP': requiresOTP,
      'phoneNumber': phoneNumber,
    };
  }
}
