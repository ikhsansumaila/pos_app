import 'package:get/get.dart';
import 'package:pos_app/modules/transaction/main/data/source/transaction_local.dart';

class TransactionQueueController extends GetxController {
  final TransactionLocalDataSource local;
  TransactionQueueController(this.local);
}
