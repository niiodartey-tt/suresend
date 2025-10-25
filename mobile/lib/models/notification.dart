class Notification {
  final String id;
  final String title;
  final String message;
  final String type; // 'transaction', 'delivery', 'dispute', 'system'
  final bool isRead;
  final DateTime createdAt;
  final DateTime? readAt;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.readAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'system',
      isRead: json['is_read'] ?? json['isRead'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
      readAt: json['read_at'] != null
          ? DateTime.parse(json['read_at'])
          : json['readAt'] != null
              ? DateTime.parse(json['readAt'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
    };
  }

  Notification copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    bool? isRead,
    DateTime? createdAt,
    DateTime? readAt,
  }) {
    return Notification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
    );
  }
}
