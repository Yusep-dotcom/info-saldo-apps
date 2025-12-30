import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:info_saldo_apps/app/data/local/database.dart';
import 'package:info_saldo_apps/app/data/models/transaction_with_category.dart';
import 'package:info_saldo_apps/app/modules/transaction/controllers/transaction_controller.dart';

class TransactionPage extends StatelessWidget {
  final TransactionWithCategory? transactionWithCategory;
  TransactionPage({super.key, this.transactionWithCategory});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller
    final c = Get.put(TransactionController(editData: transactionWithCategory));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          transactionWithCategory == null
              ? 'Tambah Transaksi'
              : 'Update Transaksi',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF5656B4),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// TOGGLE PEMASUKAN / PENGELUARAN
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Obx(
                    () => Expanded(
                      child: _toggleButton(
                        title: 'Pemasukan',
                        active: c.isIncome.value,
                        onTap: () => c.switchType(2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Obx(
                    () => Expanded(
                      child: _toggleButton(
                        title: 'Pengeluaran',
                        active: !c.isIncome.value,
                        onTap: () => c.switchType(1),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// FORM INPUT
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _input(
                    c.amountController,
                    'Jumlah',
                    keyboard: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Kategori',
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 5),

                  Obx(
                    () => FutureBuilder<List<Category>>(
                      future: c.getCategories(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return const LinearProgressIndicator();
                        final categories = snapshot.data!;

                        return DropdownButton<Category>(
                          isExpanded: true,
                          hint: const Text('Pilih Kategori'),
                          value: c.selectedCategory.value,
                          items: categories
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.name),
                                ),
                              )
                              .toList(),
                          onChanged: (val) => c.selectedCategory.value = val,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),
                  _dateInput(context, c.dateController),
                  const SizedBox(height: 10),
                  _input(c.nameController, 'Keterangan'),
                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5656B4),
                      ),
                      onPressed: c.saveTransaction,
                      child: Text(
                        transactionWithCategory == null ? 'Tambah' : 'Update',
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

  Widget _input(
    TextEditingController c,
    String hint, {
    TextInputType? keyboard,
  }) {
    return TextField(
      controller: c,
      keyboardType: keyboard,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hint,
      ),
    );
  }

  Widget _dateInput(BuildContext context, TextEditingController controller) {
    return TextField(
      controller: controller,
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
          controller.text = DateFormat('yyyy-MM-dd').format(date);
        }
      },
    );
  }
}
