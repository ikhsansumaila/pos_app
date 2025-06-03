// data/repository/product_repository_impl.dart
import 'dart:developer';

import 'package:pos_app/core/network/connectivity_service.dart';
import 'package:pos_app/modules/transaction/common/models/transaction_create_model.dart';
import 'package:pos_app/modules/transaction/common/models/transaction_model.dart';
import 'package:pos_app/modules/transaction/selling/data/repository/transaction_repository.dart';
import 'package:pos_app/modules/transaction/selling/data/source/transaction_local.dart';
import 'package:pos_app/modules/transaction/selling/data/source/transaction_remote.dart';
import 'package:pos_app/utils/cache_helper.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remote;
  final TransactionLocalDataSource local;
  final ConnectivityService connectivity;

  TransactionRepositoryImpl({
    required this.remote,
    required this.local,
    required this.connectivity,
  });

  @override
  Future<List<TransactionModel>> getTranscations() async {
    final isOnline = await connectivity.isConnected();

    if (!isOnline) {
      return local.getCachedTransaction();
    }

    try {
      final trx = await remote.fetchTransaction();
      await local.updateCache(trx);
      return trx;
    } catch (e, stackTrace) {
      log("Error fetching transactions: $e", stackTrace: stackTrace);
      return local.getCachedTransaction();
    }
  }

  @override
  Future<bool> postTransaction(TransactionCreateModel trxData) async {
    // for send to remote/queue
    TransactionCreateModel trxCreate = TransactionCreateModel.fromJson(trxData.toJson());

    // for updating local cache
    // TransactionModel trxCached = TransactionModel.setByFormData(trxData);

    if (await connectivity.isConnected()) {
      log('Posting transaction: ${trxCreate.toJsonObject()}');
      var response = await remote.postTransaction(trxCreate.toJson());

      // if failed, save to local queue
      if (response.statusCode != 200 && response.statusCode != 201) {
        // await AppDialog.show(
        //   'Terjadi kesalahan',
        //   content: response.error ?? 'Gagal mengirim transaksi. Silakan coba lagi.',
        // );

        // local.addToQueue(trxCreate); // simpan queue lokal
        // await local.addToCache(trxCached);
        return false;
      }
    } else {
      // if offline mode, save to local queue
      // local.addToQueue(trxCreate);
      // await local.addToCache(trxCached);
      return false;
    }
    return true;
  }

  @override
  int generateNextCacheId() {
    return CacheHelper.generateNextCacheId(local.cacheBox);
  }
}
