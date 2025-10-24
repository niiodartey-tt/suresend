class Transaction {
  final String id;
  final String transactionRef;
  final double amount;
  final double commission;
  final String status; // 'pending', 'in_escrow', 'completed', 'refunded', 'disputed', 'cancelled'
  final String type; // 'escrow', 'direct'
  final String description;
  final String paymentMethod;
  final TransactionParticipant buyer;
  final TransactionParticipant seller;
  final TransactionParticipant? rider;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? escrowStatus; // 'held', 'released', 'refunded'
  final DateTime? heldAt;
  final DateTime? releasedAt;
  final DateTime? refundedAt;

  Transaction({
    required this.id,
    required this.transactionRef,
    required this.amount,
    required this.commission,
    required this.status,
    required this.type,
    required this.description,
    required this.paymentMethod,
    required this.buyer,
    required this.seller,
    this.rider,
    required this.createdAt,
    this.completedAt,
    this.escrowStatus,
    this.heldAt,
    this.releasedAt,
    this.refundedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      transactionRef: json['transactionRef'] ?? '',
      amount: (json['amount'] is String)
          ? double.parse(json['amount'])
          : (json['amount'] ?? 0.0).toDouble(),
      commission: (json['commission'] is String)
          ? double.parse(json['commission'])
          : (json['commission'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'pending',
      type: json['type'] ?? 'escrow',
      description: json['description'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      buyer: TransactionParticipant.fromJson(json['buyer'] ?? {}),
      seller: TransactionParticipant.fromJson(json['seller'] ?? {}),
      rider: json['rider'] != null
          ? TransactionParticipant.fromJson(json['rider'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      escrowStatus: json['escrowStatus'],
      heldAt: json['heldAt'] != null ? DateTime.parse(json['heldAt']) : null,
      releasedAt: json['releasedAt'] != null
          ? DateTime.parse(json['releasedAt'])
          : null,
      refundedAt: json['refundedAt'] != null
          ? DateTime.parse(json['refundedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transactionRef': transactionRef,
      'amount': amount,
      'commission': commission,
      'status': status,
      'type': type,
      'description': description,
      'paymentMethod': paymentMethod,
      'buyer': buyer.toJson(),
      'seller': seller.toJson(),
      'rider': rider?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'escrowStatus': escrowStatus,
      'heldAt': heldAt?.toIso8601String(),
      'releasedAt': releasedAt?.toIso8601String(),
      'refundedAt': refundedAt?.toIso8601String(),
    };
  }

  // Helper getters
  bool get isInEscrow => status == 'in_escrow';
  bool get isCompleted => status == 'completed';
  bool get isRefunded => status == 'refunded';
  bool get isDisputed => status == 'disputed';
  bool get isCancelled => status == 'cancelled';
  bool get isPending => status == 'pending';

  // Seller receives the full amount (buyer pays amount + commission)
  double get amountAfterCommission => amount;

  String get statusDisplay {
    switch (status) {
      case 'in_escrow':
        return 'In Escrow';
      case 'completed':
        return 'Completed';
      case 'refunded':
        return 'Refunded';
      case 'disputed':
        return 'Disputed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Pending';
    }
  }
}

class TransactionParticipant {
  final String id;
  final String username;
  final String fullName;
  final String? phoneNumber;

  TransactionParticipant({
    required this.id,
    required this.username,
    required this.fullName,
    this.phoneNumber,
  });

  factory TransactionParticipant.fromJson(Map<String, dynamic> json) {
    return TransactionParticipant(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
    };
  }
}

class TransactionStats {
  final PurchaseStats purchases;
  final SalesStats sales;
  final DeliveryStats deliveries;

  TransactionStats({
    required this.purchases,
    required this.sales,
    required this.deliveries,
  });

  factory TransactionStats.fromJson(Map<String, dynamic> json) {
    return TransactionStats(
      purchases: PurchaseStats.fromJson(json['purchases'] ?? {}),
      sales: SalesStats.fromJson(json['sales'] ?? {}),
      deliveries: DeliveryStats.fromJson(json['deliveries'] ?? {}),
    );
  }
}

class PurchaseStats {
  final int total;
  final int completed;
  final int active;
  final double totalSpent;

  PurchaseStats({
    required this.total,
    required this.completed,
    required this.active,
    required this.totalSpent,
  });

  factory PurchaseStats.fromJson(Map<String, dynamic> json) {
    return PurchaseStats(
      total: json['total'] ?? 0,
      completed: json['completed'] ?? 0,
      active: json['active'] ?? 0,
      totalSpent: (json['totalSpent'] is String)
          ? double.parse(json['totalSpent'])
          : (json['totalSpent'] ?? 0.0).toDouble(),
    );
  }
}

class SalesStats {
  final int total;
  final int completed;
  final int active;
  final double totalEarned;

  SalesStats({
    required this.total,
    required this.completed,
    required this.active,
    required this.totalEarned,
  });

  factory SalesStats.fromJson(Map<String, dynamic> json) {
    return SalesStats(
      total: json['total'] ?? 0,
      completed: json['completed'] ?? 0,
      active: json['active'] ?? 0,
      totalEarned: (json['totalEarned'] is String)
          ? double.parse(json['totalEarned'])
          : (json['totalEarned'] ?? 0.0).toDouble(),
    );
  }
}

class DeliveryStats {
  final int total;

  DeliveryStats({required this.total});

  factory DeliveryStats.fromJson(Map<String, dynamic> json) {
    return DeliveryStats(
      total: json['total'] ?? 0,
    );
  }
}

class UserSearchResult {
  final String id;
  final String username;
  final String fullName;
  final String userType;
  final bool isVerified;
  final String kycStatus;

  UserSearchResult({
    required this.id,
    required this.username,
    required this.fullName,
    required this.userType,
    required this.isVerified,
    required this.kycStatus,
  });

  factory UserSearchResult.fromJson(Map<String, dynamic> json) {
    return UserSearchResult(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      fullName: json['fullName'] ?? '',
      userType: json['userType'] ?? '',
      isVerified: json['isVerified'] ?? false,
      kycStatus: json['kycStatus'] ?? 'pending',
    );
  }
}
