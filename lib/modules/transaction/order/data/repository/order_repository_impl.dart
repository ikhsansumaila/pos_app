// data/repository/product_repository_impl.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/core/network/connectivity_service.dart';
import 'package:pos_app/modules/transaction/order/data/models/order_model.dart';
import 'package:pos_app/modules/transaction/order/data/repository/order_repository.dart';
import 'package:pos_app/modules/transaction/order/data/source/order_local.dart';
import 'package:pos_app/modules/transaction/order/data/source/order_remote.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remote;
  final OrderLocalDataSource local;
  final ConnectivityService connectivity;

  OrderRepositoryImpl({required this.remote, required this.local, required this.connectivity});

  @override
  Future<List<OrderModel>> getOrders() async {
    final isOnline = await connectivity.isConnected();

    if (!isOnline) {
      return local.getCachedOrders();
    }

    try {
      final orders = await remote.fetchOrders();
      await local.update(orders);
      return orders;
    } catch (e, stackTrace) {
      log("Error fetching orders: $e", stackTrace: stackTrace);
      return local.getCachedOrders();
    }
  }

  @override
  Future<void> postOrder(OrderModel order) async {
    if (await connectivity.isConnected()) {
      var response = await remote.postOrder(order.toJson());

      // if failed, save to local queue
      if (response.statusCode != 200 && response.statusCode != 201) {
        Get.dialog(
          AlertDialog(
            title: const Text('Terjadi kesalahan'),
            content: Text('${response.data}'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          ),
        );
      }
    } else {
      Get.dialog(
        AlertDialog(
          title: const Text('Tidak ada koneksi internet'),
          content: const Text('Harap periksa koneksi internet Anda'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Future<bool> processQueue() async {
    try {
      // TODO: implement bulking?
      // final queue = local.getQueuedItems(); // dari Hive
      // for (final item in queue) {
      //   await remote.postOrder(item);
      // }
      // local.clearQueue();
      return true;
    } catch (_) {
      return false;
    }
  }
}
