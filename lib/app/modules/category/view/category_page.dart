import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_saldo_apps/app/data/local/database.dart';
import 'package:info_saldo_apps/app/modules/category/controller/category_controller.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoryController>();

    void openDialog(Category? category) {
      controller.nameController.text = category?.name ?? '';

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Obx(
            () => Text(
              controller.isExpense.value ? 'Add Income' : 'Add Outcome',
              style: GoogleFonts.montserrat(),
            ),
          ),
          content: TextField(
            controller: controller.nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Nama kategori',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = controller.nameController.text.trim();
                if (name.isEmpty) return;

                if (category == null) {
                  await controller.insert(name);
                } else {
                  await controller.updateCategory(category.id, name);
                }

                controller.nameController.clear();
                Get.back();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color(0xFF5656B4),
        centerTitle: true,
        title: Text(
          'Tambah Category',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => FlutterSwitch(
                      value: controller.isExpense.value,
                      width: 75,
                      height: 36,
                      toggleSize: 28,
                      borderRadius: 30,
                      activeColor: const Color(0xFF5656B4),
                      inactiveColor: Colors.red,
                      onToggle: (value) {
                        controller.isExpense.value = value;
                        controller.fetchCategories();
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => openDialog(null),
                  ),
                ],
              ),
            ),

            // LIST
            Expanded(
              child: Obx(() {
                if (controller.categoryList.isEmpty) {
                  return const Center(child: Text('Data kosong'));
                }

                return ListView.builder(
                  itemCount: controller.categoryList.length,
                  itemBuilder: (_, index) {
                    final category = controller.categoryList[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: Icon(
                          controller.isExpense.value
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: controller.isExpense.value
                              ? const Color(0xFF5656B4)
                              : Colors.red,
                        ),
                        title: Text(category.name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => openDialog(category),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  controller.deleteCategory(category.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
