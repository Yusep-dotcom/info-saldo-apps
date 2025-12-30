import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' as drift;
import 'package:info_saldo_apps/app/data/local/database.dart';
import 'package:info_saldo_apps/app/data/models/transaction_with_category.dart';

class TransactionController extends GetxController {
  final AppDb database = Get.find<AppDb>();
  final TransactionWithCategory? editData;

  TransactionController({this.editData});

  final isIncome = true.obs;
  final type = 2.obs; // 2 = income, 1 = expense
  final selectedCategory = Rxn<Category>();

  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    if (editData != null) {
      final data = editData!;
      amountController.text = data.transaction.amount.toString();
      nameController.text = data.transaction.title;
      dateController.text = DateFormat(
        'yyyy-MM-dd',
      ).format(data.transaction.transaction_date);

      selectedCategory.value = data.category;
      type.value = data.category.type;
      isIncome.value = (type.value == 2);
    }
  }

  void switchType(int newType) {
    isIncome.value = (newType == 2);
    type.value = newType;
    selectedCategory.value = null; // Reset kategori saat pindah tipe
  }

  Future<List<Category>> getCategories() {
    return database.getAllCategoriesRepo(type.value);
  }

  Future<void> saveTransaction() async {
    if (selectedCategory.value == null) {
      Get.snackbar('Error', 'Kategori wajib dipilih');
      return;
    }

    final now = DateTime.now();
    final dateValue = DateTime.parse(dateController.text);

    if (editData != null) {
      // EDIT
      await (database.update(
        database.transactions,
      )..where((tbl) => tbl.id.equals(editData!.transaction.id))).write(
        TransactionsCompanion(
          title: drift.Value(nameController.text),
          amount: drift.Value(int.parse(amountController.text)),
          transaction_date: drift.Value(dateValue),
          category_id: drift.Value(selectedCategory.value!.id),
          updateAt: drift.Value(now),
        ),
      );
    } else {
      // TAMBAH
      await database
          .into(database.transactions)
          .insert(
            TransactionsCompanion.insert(
              title: nameController.text,
              amount: int.parse(amountController.text),
              transaction_date: dateValue,
              category_id: drift.Value(selectedCategory.value!.id),
              createdAt: now,
              updateAt: now,
            ),
          );
    }

    Get.back(result: dateValue);
  }

  @override
  void onClose() {
    amountController.dispose();
    dateController.dispose();
    nameController.dispose();
    super.onClose();
  }
}
