// sync_log_model.dart
class SyncLog {
  final String type; // e.g., "product" / "order"
  final bool success;
  final String message;
  final DateTime timestamp;

  SyncLog({
    required this.type,
    required this.success,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'success': success,
    'message': message,
    'timestamp': timestamp.toIso8601String(),
  };

  factory SyncLog.fromJson(Map<String, dynamic> json) => SyncLog(
    type: json['type'],
    success: json['success'],
    message: json['message'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}
