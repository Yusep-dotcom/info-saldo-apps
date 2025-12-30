import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/rekap_controller.dart';

class RekapView extends StatelessWidget {
  RekapView({super.key});

  final c = Get.put(RekapController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          'Rekap Pengeluaran',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF5656B4),
      ),
      body: Column(
        children: [
          /// HEADER NAVIGASI BULAN
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.chevron_left,
                    color: Color(0xFF5656B4),
                  ),
                  onPressed: c.prevMonth,
                ),
                Obx(
                  () => SizedBox(
                    width: 150,
                    child: Text(
                      c.monthLabel,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => IconButton(
                    icon: Icon(
                      Icons.chevron_right,
                      color: c.canGoNext
                          ? const Color(0xFF5656B4)
                          : Colors.grey,
                    ),
                    onPressed: c.canGoNext ? c.nextMonth : null,
                  ),
                ),
              ],
            ),
          ),

          /// KONTEN UTAMA
          Expanded(
            child: Obx(() {
              if (c.totalExpense.value == 0) {
                return const Center(
                  child: Text('Tidak ada data pengeluaran di bulan ini'),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    /// DONUT CHART
                    SizedBox(
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 60,
                              sections: c.summary.asMap().entries.map((entry) {
                                final index = entry.key;
                                final e = entry.value;
                                // List warna sederhana
                                List<Color> colors = [
                                  Colors.purple,
                                  Colors.blue,
                                  Colors.orange,
                                  Colors.red,
                                  Colors.green,
                                ];
                                return PieChartSectionData(
                                  color: colors[index % colors.length],
                                  value: e.amount.toDouble(),
                                  title: '',
                                  radius: 30,
                                );
                              }).toList(),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                NumberFormat.currency(
                                  locale: 'id',
                                  symbol: 'Rp ',
                                  decimalDigits: 0,
                                ).format(c.totalExpense.value),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                    const Divider(),

                    /// LIST DETAIL KATEGORI
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: c.summary.length,
                      itemBuilder: (_, i) {
                        final item = c.summary[i];
                        final percent =
                            (item.amount / c.totalExpense.value * 100)
                                .toStringAsFixed(1);

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.purple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$percent%',
                              style: const TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          title: Text(item.name),
                          trailing: Text(
                            NumberFormat.currency(
                              locale: 'id',
                              symbol: 'Rp ',
                              decimalDigits: 0,
                            ).format(item.amount),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
