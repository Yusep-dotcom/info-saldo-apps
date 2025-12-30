import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:info_saldo_apps/app/data/local/database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:info_saldo_apps/app/data/models/transaction_with_category.dart';

class TransactionPage extends StatefulWidget {
  final TransactionWithCategory? transactionWithCategory;
  const TransactionPage({super.key, this.transactionWithCategory});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final AppDb database = Get.find<AppDb>();

  bool isIncome = true;
  int type = 2; // 2 = income, 1 = expense

  Category? selectedCategory;
  Category? deletedCategory;

  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.transactionWithCategory != null) {
      final data = widget.transactionWithCategory!;

      amountController.text = data.transaction.amount.toString();
      nameController.text = data.transaction.title;
      dateController.text = DateFormat(
        'yyyy-MM-dd',
      ).format(data.transaction.transaction_date);

      selectedCategory = data.category;
      type = data.category.type;
      isIncome = type == 2;
    }
  }

  Future<List<Category>> getCategories() {
    return database.getAllCategoriesRepo(type);
  }

  Future<void> saveTransaction() async {
    if (selectedCategory == null) {
      Get.snackbar('Error', 'Kategori wajib dipilih');
      return;
    }

    final now = DateTime.now();

    /// ================= EDIT =================
    if (widget.transactionWithCategory != null) {
      final id = widget.transactionWithCategory!.transaction.id;

      await (database.update(
        database.transactions,
      )..where((tbl) => tbl.id.equals(id))).write(
        TransactionsCompanion(
          title: drift.Value(nameController.text),
          amount: drift.Value(int.parse(amountController.text)),
          transaction_date: drift.Value(DateTime.parse(dateController.text)),
          category_id: drift.Value(selectedCategory!.id),
          updateAt: drift.Value(now),
        ),
      );
    }
    /// ================= TAMBAH =================
    else {
      await database
          .into(database.transactions)
          .insert(
            TransactionsCompanion.insert(
              title: nameController.text,
              amount: int.parse(amountController.text),
              transaction_date: DateTime.parse(dateController.text),
              category_id: drift.Value(selectedCategory!.id),
              createdAt: now,
              updateAt: now,
            ),
          );
    }

    Get.back(result: DateTime.parse(dateController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Transaksi',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 70,
        backgroundColor: const Color(0xFF5656B4),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// ================= TOGGLE =================
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _toggleButton(
                      title: 'Pemasukan',
                      active: isIncome,

                      onTap: () {
                        setState(() {
                          isIncome = true;
                          type = 2;
                          selectedCategory = null;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _toggleButton(
                      title: 'Pengeluaran',
                      active: !isIncome,
                      onTap: () {
                        setState(() {
                          isIncome = false;
                          type = 1;
                          selectedCategory = null;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            /// ================= FORM =================
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _input(amountController, 'Jumlah'),
                  const SizedBox(height: 10),

                  Text(
                    'Kategori',
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 5),

                  FutureBuilder<List<Category>>(
                    future: getCategories(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }

                      final categories = snapshot.data!;
                      if (categories.isEmpty) {
                        return const Text('Kategori tidak tersedia');
                      }

                      // 🔑 kalau kategori terhapus, reset dropdown
                      if (selectedCategory != null &&
                          !categories.any(
                            (c) => c.id == selectedCategory!.id,
                          )) {
                        selectedCategory = null;
                      }

                      return DropdownButton<Category>(
                        isExpanded: true,
                        hint: const Text('Pilih Kategori'),
                        value: selectedCategory,
                        items: categories.map((e) {
                          return DropdownMenuItem<Category>(
                            value: e,
                            child: Text(e.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 10),
                  _dateInput(),
                  const SizedBox(height: 10),
                  _input(nameController, 'Keterangan'),
                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF5656B4),
                      ),
                      onPressed: saveTransaction,

                      child: Text(
                        widget.transactionWithCategory == null
                            ? 'Tambah'
                            : 'Update',
                        style: GoogleFonts.montserrat(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= WIDGETS =================

  Widget _toggleButton({
    required String title,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF5656B4) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF5656B4), width: 2),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.montserrat(
              color: active ? Colors.white : const Color(0xFF5656B4),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _input(TextEditingController c, String hint) {
    return TextField(
      controller: c,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hint,
      ),
    );
  }

  Widget _dateInput() {
    return TextField(
      controller: dateController,
      readOnly: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Tanggal',
      ),
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );

        if (date != null) {
          dateController.text = DateFormat('yyyy-MM-dd').format(date);
        }
      },
    );
  }
}
