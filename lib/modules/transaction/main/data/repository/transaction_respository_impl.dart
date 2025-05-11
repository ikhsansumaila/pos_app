// data/repository/product_repository_impl.dart
import 'dart:developer';

import 'package:pos_app/core/network/connectivity_service.dart';
import 'package:pos_app/modules/transaction/main/data/models/transaction_create_model.dart';
import 'package:pos_app/modules/transaction/main/data/models/transaction_model.dart';
import 'package:pos_app/modules/transaction/main/data/repository/transaction_repository.dart';
import 'package:pos_app/modules/transaction/main/data/source/transaction_local.dart';
import 'package:pos_app/modules/transaction/main/data/source/transaction_remote.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remote;
  final TransactionLocalDataSource local;
  final ConnectivityService connectivity;

  TransactionRepositoryImpl(this.remote, this.local, this.connectivity);

  @override
  Future<List<TransactionModel>> getUsers() async {
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
  Future<void> postTransaction(TransactionCreateModel trx) async {
    if (await connectivity.isConnected()) {
      var response = await remote.postTransaction(trx);

      // if failed, save to local queue
      if (response.statusCode != 200 && response.statusCode != 201) {
        local.addToQueue(trx); // simpan queue lokal
      }
    } else {
      // if offline mode, save to local queue
      local.addToQueue(trx);
    }
  }

  @override
  Future<bool> processQueue() async {
    // TODO: ADD BULKING POST and call clearAllQueue after ?

    // final queue = local.getQueuedItems(); // dari Hive

    // while (queue.isNotEmpty) {
    //   final item = queue[0];
    //   try {
    //     // Coba kirim ulang data
    //     var response = await remote.postTransaction(item);

    //     // Jika berhasil, hapus data dari queue
    //     if (response.statusCode == 200 || response.statusCode == 201) {
    //       await local.deleteQueueAt(0); // Hapus data yang sudah berhasil diposting
    //     }
    //   } catch (e) {
    //     // Jika gagal lagi, data tetap ada di queue
    //     break;
    //   }
    // }
    return true;
  }
}
