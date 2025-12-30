import 'package:flutter/material.dart';

import 'package:info_saldo_apps/app/modules/category/view/category_page.dart';
import 'package:info_saldo_apps/app/modules/home/home_page.dart';
import 'package:info_saldo_apps/app/modules/transaction/view/transaction_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // 1. Variabel untuk mencatat halaman mana yang aktif
  int currentIndex = 0;

  // 2. List halaman yang akan ditampilkan
  // Pastikan urutannya sama dengan urutan BottomNavigationBarItem
  final List<Widget> widgetOptions = [
    HomePage(),
    const TransactionPage(), // Sekarang jadi tab tengah
    const CategoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tampilan body berubah sesuai index yang dipilih
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: widgetOptions.elementAt(currentIndex),
      ),

      // Navbar bawah dengan 3 menu
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Biar posisi icon tetap stabil
        currentIndex: currentIndex,
        onTap: (index) {
          // 3. Fungsi setState untuk me-refresh layar saat icon di-klik
          setState(() {
            currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF5656B4),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline), // Icon untuk transaksi
            label: 'Transaction',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Category'),
        ],
      ),
    );
  }
}
