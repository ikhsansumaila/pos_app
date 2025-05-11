import 'package:pos_app/modules/transaction/main/data/models/transaction_create_model.dart';
import 'package:pos_app/modules/transaction/main/data/models/transaction_model.dart';

abstract class TransactionRepository {
  Future<List<TransactionModel>> getUsers();
  Future<void> postTransaction(TransactionCreateModel transaction);
  Future<bool> processQueue(); // use in background sync process
}
