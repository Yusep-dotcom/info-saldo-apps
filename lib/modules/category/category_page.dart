import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_saldo_apps/data/local/database.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isExpense = true;
  final AppDb database = AppDb();
  final TextEditingController categoryNameController = TextEditingController();

  Future<void> insert(String name, int type) async {
    final now = DateTime.now();
    await database
        .into(database.categories)
        .insert(
          CategoriesCompanion.insert(
            name: name,
            type: type,
            createdAt: now,
            updateAt: now,
          ),
        );
  }

  Future<void> update(int id, String newName) async {
    await database.updateCategoryRepo(id, newName);
  }

  Future<List<Category>> getCategories() {
    return database.getAllCategoriesRepo(isExpense ? 2 : 1);
  }

  void openDialog(Category? category) {
    categoryNameController.text = category?.name ?? '';

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            isExpense ? 'Add Income' : 'Add Outcome',
            style: GoogleFonts.montserrat(),
          ),
          content: TextField(
            controller: categoryNameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Nama kategori',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = categoryNameController.text.trim();
                if (name.isEmpty) return;

                if (category == null) {
                  await insert(name, isExpense ? 2 : 1);
                } else {
                  await update(category.id, name);
                }

                categoryNameController.clear();
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // HEADER
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlutterSwitch(
                  value: isExpense,
                  width: 75,
                  height: 36,
                  toggleSize: 28,
                  borderRadius: 30,
                  activeColor: Color(0xFF5656B4),
                  inactiveColor: Colors.red,
                  onToggle: (value) {
                    setState(() {
                      isExpense = value;
                    });
                  },
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
            child: FutureBuilder<List<Category>>(
              future: getCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Data kosong'));
                }

                final categories = snapshot.data!;

                return ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: Icon(
                          isExpense ? Icons.arrow_downward : Icons.arrow_upward,
                          color: isExpense
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
                              onPressed: () async {
                                await database.deleteCategoryRepo(category.id);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
