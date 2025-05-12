import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/modules/sync/transaction/transaction_queue_controller.dart';

class TransactionQueueDetail extends StatelessWidget {
  final String tag;

  // Controller yang diambil berdasarkan tag dan tipe generik T
  final TransactionQueueController controller;

  // Konstruktor
  TransactionQueueDetail({super.key, required this.tag}) : controller = Get.find(tag: tag);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('List Queue $tag')),
      body: () {
        var queueItems = controller.local.getQueuedItems();
        for (var i = 0; i < queueItems.length; i++) {
          print('queue item : ${queueItems[i].toJson()}');
        }
        if (queueItems.isEmpty) return Center(child: Text('Kosong'));

        return ListView.builder(
          itemCount: queueItems.length,
          itemBuilder: (_, i) {
            final item = queueItems[i];
            return ListTile(title: Text(item.toJson().toString()));
          },
        );
      }(),
    );
  }
}
