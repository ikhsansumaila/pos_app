import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/core/controller_provider.dart';
import 'package:pos_app/modules/store/controller/store_controller.dart';
import 'package:pos_app/modules/store/view/store_add_page.dart';
import 'package:pos_app/modules/store/view/store_detail_page.dart';

class StoreListPage extends StatelessWidget {
  final controller = ControllerProvider.findOrPut(StoreController(repository: Get.find()));

  StoreListPage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchStores();

    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Toko"), centerTitle: true),
      body: Obx(
        () =>
            controller.stores.isEmpty
                ? const Center(child: Text("Belum ada data toko."))
                : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.stores.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final store = controller.stores[index];
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        leading: const Icon(Icons.store, size: 32, color: Colors.teal),
                        title: Text(
                          store.storeName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text(
                          store.storeAddress,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Get.to(() => StoreDetailPage(store: store)),
                      ),
                    );
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => StoreAddPage()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
