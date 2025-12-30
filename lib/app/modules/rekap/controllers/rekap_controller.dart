import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:info_saldo_apps/app/data/local/database.dart';
import 'package:drift/drift.dart' as drift;

class RekapController extends GetxController {
  final AppDb db = Get.find<AppDb>();

  final summary = <_RekapItem>[].obs;
  final totalExpense = 0.obs;

  late DateTime currentMonth;
  final Rx<DateTime> selectedMonth = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    final now = DateTime.now();
    currentMonth = DateTime(now.year, now.month);
    selectedMonth.value = currentMonth;
    loadRekap(); // Ambil data pertama kali
  }

  // 🔙 PREV: Pindah ke bulan lalu & ambil data
  void prevMonth() {
    final m = selectedMonth.value;
    selectedMonth.value = DateTime(m.year, m.month - 1, 1);
    loadRekap();
  }

  // 🔜 NEXT: Pindah ke bulan depan (jika diijinkan) & ambil data
  void nextMonth() {
    if (!canGoNext) return;
    final s = selectedMonth.value;
    selectedMonth.value = DateTime(s.year, s.month + 1, 1);
    loadRekap();
  }

  // Cek apakah boleh maju (tidak boleh melebihi bulan sekarang)
  bool get canGoNext {
    final s = selectedMonth.value;
    return !(s.year == currentMonth.year && s.month == currentMonth.month);
  }

  String get monthLabel =>
      DateFormat('MMMM yyyy', 'id_ID').format(selectedMonth.value);

  Future<void> loadRekap() async {
    final start = DateTime(selectedMonth.value.year, selectedMonth.value.month);
    final end = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month + 1,
    );

    final data = await db
        .customSelect(
          '''
      SELECT c.name, SUM(t.amount) as total
      FROM transactions t
      JOIN categories c ON c.id = t.category_id
      WHERE c.type = 1
      AND t.transaction_date >= ?
      AND t.transaction_date < ?
      GROUP BY c.id
      ''',
          variables: [
            drift.Variable<DateTime>(start),
            drift.Variable<DateTime>(end),
          ],
        )
        .get();

    summary.clear();
    totalExpense.value = 0;

    for (final row in data) {
      final totalValue = row.data['total'] as int;
      summary.add(
        _RekapItem(name: row.data['name'] as String, amount: totalValue),
      );
      totalExpense.value += totalValue;
    }
  }
}

class _RekapItem {
  final String name;
  final int amount;
  _RekapItem({required this.name, required this.amount});
}
