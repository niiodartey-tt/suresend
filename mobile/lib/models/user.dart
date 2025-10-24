class User {
  final String id;
  final String username;
  final String phoneNumber;
  final String fullName;
  final String userType; // 'buyer', 'seller', 'rider'
  final String? email;
  final bool isVerified;
  final String kycStatus; // 'pending', 'approved', 'rejected'
  final String? profileImage;
  final double walletBalance;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;

  User({
    required this.id,
    required this.username,
    required this.phoneNumber,
    required this.fullName,
    required this.userType,
    this.email,
    required this.isVerified,
    required this.kycStatus,
    this.profileImage,
    required this.walletBalance,
    this.createdAt,
    this.lastLoginAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      fullName: json['fullName'] ?? '',
      userType: json['userType'] ?? 'buyer',
      email: json['email'],
      isVerified: json['isVerified'] ?? false,
      kycStatus: json['kycStatus'] ?? 'pending',
      profileImage: json['profileImage'],
      walletBalance: (json['walletBalance'] is String)
          ? double.parse(json['walletBalance'])
          : (json['walletBalance'] ?? 0.0).toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'phoneNumber': phoneNumber,
      'fullName': fullName,
      'userType': userType,
      'email': email,
      'isVerified': isVerified,
      'kycStatus': kycStatus,
      'profileImage': profileImage,
      'walletBalance': walletBalance,
      'createdAt': createdAt?.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? username,
    String? phoneNumber,
    String? fullName,
    String? userType,
    String? email,
    bool? isVerified,
    String? kycStatus,
    String? profileImage,
    double? walletBalance,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fullName: fullName ?? this.fullName,
      userType: userType ?? this.userType,
      email: email ?? this.email,
      isVerified: isVerified ?? this.isVerified,
      kycStatus: kycStatus ?? this.kycStatus,
      profileImage: profileImage ?? this.profileImage,
      walletBalance: walletBalance ?? this.walletBalance,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  // Helper methods
  bool get isBuyer => userType == 'buyer';
  bool get isSeller => userType == 'seller';
  bool get isRider => userType == 'rider';
  bool get isKYCApproved => kycStatus == 'approved';
  bool get isKYCPending => kycStatus == 'pending';
  bool get isKYCRejected => kycStatus == 'rejected';
}
