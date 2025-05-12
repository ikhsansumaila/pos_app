import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QueueDetailPage<T> extends StatelessWidget {
  final String tag;

  // Controller yang diambil berdasarkan tag dan tipe generik T
  final T controller;

  // Konstruktor
  QueueDetailPage({super.key, required this.tag})
    : controller = Get.find<T>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('List Queue $tag')),
      body: Center(child: Text('Kosong')),

      // Obx(() {
      // if (controller.queue.isEmpty) return Center(child: Text('Kosong'));

      // return ListView.builder(
      //   itemCount: controller.queue.length,
      //   itemBuilder: (_, i) {
      //     final item = controller.queue[i];
      //     return ListTile(title: Text(item.toString()));
      //   },
      // );
      // }),
    );
  }
}
