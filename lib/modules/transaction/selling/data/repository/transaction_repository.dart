import 'package:pos_app/modules/transaction/common/models/transaction_create_model.dart';
import 'package:pos_app/modules/transaction/common/models/transaction_model.dart';

abstract class TransactionRepository {
  Future<List<TransactionModel>> getTranscations();
  Future<void> postTransaction(TransactionCreateModel transaction);
  int generateNextCacheId();
}
