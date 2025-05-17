// data/repository/product_repository_impl.dart
import 'dart:developer';

import 'package:pos_app/core/network/connectivity_service.dart';
import 'package:pos_app/modules/store/data/models/store_model.dart';
import 'package:pos_app/modules/store/data/repository/store_repository.dart';
import 'package:pos_app/modules/store/data/source/store_local.dart';
import 'package:pos_app/modules/store/data/source/store_remote.dart';

class StoreRepositoryImpl implements StoreRepository {
  final StoreRemoteDataSource remote;
  final StoreLocalDataSource local;
  final ConnectivityService connectivity;

  StoreRepositoryImpl({required this.remote, required this.local, required this.connectivity});

  @override
  Future<List<StoreModel>> getStores() async {
    final isOnline = await connectivity.isConnected();

    if (!isOnline) {
      return local.getCachedStores();
    }

    try {
      final stores = await remote.fetchStores();
      await local.updateStoreCache(stores);
      return stores;
    } catch (e, stackTrace) {
      log("Error fetching stores: $e", stackTrace: stackTrace);
      return local.getCachedStores();
    }
  }

  @override
  Future<String?> postStore(StoreModel store) async {
    final isOnline = await connectivity.isConnected();

    if (!isOnline) {
      return 'Harap periksa koneksi internet Anda';
    }

    final response = await remote.postStore(store.toJsonCreate());
    if (response.statusCode != 200 && response.statusCode != 201) {
      return 'Error: ${response.data}';
    }

    return null;
  }
}
