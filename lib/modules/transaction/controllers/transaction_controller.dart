import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionController extends GetxController {
  // Pengontrol untuk TextField
  final amountC = TextEditingController();
  final dateC = TextEditingController();
  final nameC = TextEditingController();

  // State untuk tipe transaksi dan kategori
  bool isIncome = true;
  Category? selectedCategory;
  DateTime? selectedDate;

  // Fungsi Toggle antara Pemasukan dan Pengeluaran
  void toggleType(bool val) {
    isIncome = val;
    update();
  }

  // Fungsi untuk mendapatkan data kategori (Placeholder untuk FutureBuilder)
  Future<List<Category>> getCategories() async {
    // Logic database Anda di sini
    // Contoh: return database.allCategories;
    return []; 
  }

  // Fungsi untuk mengatur tanggal yang dipilih ke TextField
  void setDate(DateTime picked) {
    selectedDate = picked;
    dateC.text = picked.toString().split(' ')[0]; // Format YYYY-MM-DD
    update();
  }

  // Fungsi untuk menyimpan data ke database
  Future<void> insertTransaction() async {
    // Logic insert ke database menggunakan amountC, dateC, nameC, dll.
    print("Transaksi disimpan: ${nameC.text}");
  }

  @override
  void onClose() {
    amountC.dispose();
    dateC.dispose();
    nameC.dispose();
    super.onClose();
  }
}