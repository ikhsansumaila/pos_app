import 'package:get/get.dart';
import 'package:pos_app/modules/transaction/main/data/repository/transaction_respository_impl.dart';

class TransactionQueueController extends GetxController {
  final TransactionRepositoryImpl repo;
  TransactionQueueController({required this.repo});
}
