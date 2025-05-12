// ignore_for_file: non_constant_identifier_names
final String USER_BOX_KEY = 'userBox';
final String USER_ROLE_BOX_KEY = 'userRoleBox';
final String STORE_BOX_KEY = 'storeBox';
final String PRODUCT_BOX_KEY = 'productBox';
final String TRANSACTION_BOX_KEY = 'transactionBox';
final String ORDER_BOX_KEY = 'orderBox';

final String QUEUE_USER_KEY = 'queueBox_user';
final String QUEUE_STORE_KEY = 'queueBox_store';
final String QUEUE_PRODUCT_KEY = 'queueBox_product';
final String QUEUE_ORDER_KEY = 'queueBox_order';
final String QUEUE_TRANSACTION_KEY = 'queueBox_transaction';

final String SYNC_LOG_BOX_KEY = 'syncLogBox';

/// Gunakan ID unik untuk setiap model Hive.
/// Jangan ubah nilai yang sudah digunakan di production.
class HiveTypeIds {
  // User (0–19)
  static const int user = 0;
  static const int userCreate = 1;
  static const int userRole = 2;

  // Store (20–39)
  static const int store = 20;
  static const int storeCreate = 21;

  // Product (40–59)
  static const int product = 40;
  static const int productCreate = 41;

  // Cart (60–79)
  static const int cartItem = 60;

  // Order (80–99)
  static const int order = 80;
  static const int orderCreate = 81;

  // Transaction (100–119)
  static const int transaction = 100;
  static const int transactionCreate = 101;
  static const int transactionItem = 102;

  // Sync / Log / Queue (120–139)
  static const int syncLog = 120;
  static const int syncQueue = 121;

  // Tambahkan di sini sesuai kebutuhan
}
