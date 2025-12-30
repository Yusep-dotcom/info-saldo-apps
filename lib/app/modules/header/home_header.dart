import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_saldo_apps/app/data/local/database.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final AppDb database = Get.find<AppDb>();

    return SizedBox(
      height: 280,
      child: Stack(
        children: [
          Container(
            height: 230,
            decoration: const BoxDecoration(
              color: Color(0xFF5656B4),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.menu, color: Colors.white),
                    Text(
                      'Home',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Icon(Icons.more_vert, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),

          Positioned(
            left: 20,
            right: 20,
            bottom: 0,
            child: StreamBuilder<Map<String, int>>(
              stream: database.watchSummary(),
              builder: (context, snapshot) {
                final income = snapshot.data?['income'] ?? 0;
                final expense = snapshot.data?['expense'] ?? 0;
                final saldo = snapshot.data?['saldo'] ?? 0;

                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 8,
                        spreadRadius: 1,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text('Saldo Total'),
                      const SizedBox(height: 6),
                      Text(
                        'Rp $saldo',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _summaryItem('Penghasilan', income),
                          _summaryItem('Pengeluaran', expense),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String title, int value) {
    return Column(
      children: [
        Text(title),
        const SizedBox(height: 4),
        Text('Rp $value', style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
