import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:info_saldo_apps/app/data/local/database.dart';
import 'package:info_saldo_apps/app/data/models/transaction_with_category.dart';
import 'package:info_saldo_apps/app/modules/transaction/view/transaction_page.dart';
import 'package:info_saldo_apps/app/modules/header/home_header.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final AppDb database = Get.find<AppDb>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HomeHeader(),

        Expanded(
          child: StreamBuilder<List<TransactionWithCategory>>(
            stream: database.getAllTransactionsWithCategory(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final transactions = snapshot.data!;
              if (transactions.isEmpty) {
                return const Center(child: Text('Belum ada transaksi'));
              }

              final grouped = _groupByDate(transactions);

              return ListView(
                padding: const EdgeInsets.all(16),
                children: grouped.entries.map((entry) {
                  return _buildDateSection(entry.key, entry.value);
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }

  // ================= GROUP BY DATE =================
  Map<DateTime, List<TransactionWithCategory>> _groupByDate(
    List<TransactionWithCategory> data,
  ) {
    final Map<DateTime, List<TransactionWithCategory>> map = {};

    for (final item in data) {
      final date = DateTime(
        item.transaction.transaction_date.year,
        item.transaction.transaction_date.month,
        item.transaction.transaction_date.day,
      );

      map.putIfAbsent(date, () => []);
      map[date]!.add(item);
    }

    final sortedKeys = map.keys.toList()..sort((a, b) => b.compareTo(a));

    return {for (final k in sortedKeys) k: map[k]!};
  }

  // ================= UI DATE SECTION =================
  Widget _buildDateSection(DateTime date, List<TransactionWithCategory> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _formatDateLabel(date),
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),

        ...items.map((item) => _transactionItem(item)),

        const SizedBox(height: 20),
      ],
    );
  }

  String _formatDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (date == today) return 'Hari Ini';
    if (date == yesterday) return 'Kemarin';

    return DateFormat('dd MMMM yyyy', 'id').format(date);
  }

  // ================= TRANSACTION CARD =================
  Widget _transactionItem(TransactionWithCategory item) {
    final isExpense = item.category.type == 1;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(
          isExpense ? Icons.arrow_upward : Icons.arrow_downward,
          color: isExpense ? Colors.red : Colors.blue,
        ),
        title: Text(
          'Rp ${item.transaction.amount}',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${item.category.name} • ${item.transaction.title}',
          style: GoogleFonts.montserrat(fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                database.deleteTransaction(item.transaction.id);
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Get.to(() => TransactionPage(transactionWithCategory: item));
              },
            ),
          ],
        ),
      ),
    );
  }
}
