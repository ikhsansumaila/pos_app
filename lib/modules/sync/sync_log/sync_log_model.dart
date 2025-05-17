// ignore_for_file: non_constant_identifier_names

class SyncLog {
  static final SYNC_STATUS_SUCCESS = 99;
  static final SYNC_STATUS_FAILED = 98;
  static final SYNC_STATUS_WARNING = 97;

  final String entity; // e.g., "product" / "order"
  final int status;
  final String message;
  final String data;
  final DateTime timestamp;

  SyncLog({
    required this.entity,
    required this.status,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'type': entity,
    'status': status,
    'message': message,
    'data': data,
    'timestamp': timestamp.toIso8601String(),
  };

  factory SyncLog.fromJson(Map<String, dynamic> json) => SyncLog(
    entity: json['type'],
    status: json['status'],
    message: json['message'],
    data: json['data'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}
