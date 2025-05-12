// sync_log_model.dart
class SyncLog {
  final String type; // e.g., "product" / "order"
  final bool success;
  final String message;
  final String data;
  final DateTime timestamp;

  SyncLog({
    required this.type,
    required this.success,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'success': success,
    'message': message,
    'data': data,
    'timestamp': timestamp.toIso8601String(),
  };

  factory SyncLog.fromJson(Map<String, dynamic> json) => SyncLog(
    type: json['type'],
    success: json['success'],
    message: json['message'],
    data: json['data'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}
