import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:info_saldo_apps/app/data/models/transaction_with_category.dart';
import 'package:info_saldo_apps/app/data/local/tables/category.dart';
import 'package:info_saldo_apps/app/data/local/tables/transaction.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

@DriftDatabase(tables: [Categories, Transactions])
class AppDb extends _$AppDb {
  static final AppDb _instance = AppDb._internal();

  factory AppDb() => _instance;

  AppDb._internal() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // =========================
  // CATEGORY
  // =========================

  Future<List<Category>> getAllCategoriesRepo(int type) async {
    return await (select(
      categories,
    )..where((tbl) => tbl.type.equals(type))).get();
  }

  Future updateCategoryRepo(int id, String name) async {
    return (update(categories)..where((tbl) => tbl.id.equals(id))).write(
      CategoriesCompanion(name: Value(name)),
    );
  }

  /// ❗️AMAN: hapus kategori TIDAK menghapus transaksi
  Future deleteCategoryRepo(int id) async {
    return (delete(categories)..where((tbl) => tbl.id.equals(id))).go();
  }

  // =========================
  // TRANSACTION
  // =========================

  Future<void> deleteTransaction(int id) async {
    await (delete(transactions)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// 🔑 QUERY PALING PENTING
  /// kategori boleh null → transaksi tetap tampil
  Stream<List<TransactionWithCategory>> getTransactionByDateRepo(
    DateTime date,
  ) {
    final query = select(transactions).join([
      leftOuterJoin(
        categories,
        categories.id.equalsExp(transactions.category_id),
      ),
    ])..where(transactions.transaction_date.equals(date));

    return query.watch().map((rows) {
      return rows.map((row) {
        return TransactionWithCategory(
          transaction: row.readTable(transactions),
          category:
              row.readTableOrNull(categories) ??
              Category(
                id: -1,
                name: 'Kategori dihapus',
                type: 0,
                createdAt: DateTime.now(),
                updateAt: DateTime.now(),
              ),
        );
      }).toList();
    });
  }

  Stream<List<TransactionWithCategory>> getAllTransactionsWithCategoryRepo(
    DateTime date,
  ) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(Duration(days: 1));

    final query = select(transactions).join([
      leftOuterJoin(
        categories,
        categories.id.equalsExp(transactions.category_id),
      ),
    ])..where(transactions.transaction_date.isBetweenValues(start, end));

    return query.watch().map((rows) {
      return rows.map((row) {
        return TransactionWithCategory(
          transaction: row.readTable(transactions),
          category:
              row.readTableOrNull(categories) ??
              Category(
                id: -1,
                name: 'Kategori dihapus',
                type: 0,
                createdAt: DateTime.now(),
                updateAt: DateTime.now(),
              ),
        );
      }).toList();
    });
  }

  Stream<List<TransactionWithCategory>> getAllTransactionsWithCategory() {
    final query = select(transactions).join([
      leftOuterJoin(
        categories,
        categories.id.equalsExp(transactions.category_id),
      ),
    ])..orderBy([OrderingTerm.desc(transactions.transaction_date)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return TransactionWithCategory(
          transaction: row.readTable(transactions),
          category:
              row.readTableOrNull(categories) ??
              Category(
                id: -1,
                name: 'Kategori dihapus',
                type: 0,
                createdAt: DateTime.now(),
                updateAt: DateTime.now(),
              ),
        );
      }).toList();
    });
  }

  Stream<Map<String, int>> watchSummary() {
    final query = select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.category_id)),
    ]);

    return query.watch().map((rows) {
      int income = 0;
      int expense = 0;

      for (final row in rows) {
        final trx = row.readTable(transactions);
        final cat = row.readTable(categories);

        if (cat.type == 2) {
          income += trx.amount;
        } else if (cat.type == 1) {
          expense += trx.amount;
        }
      }

      return {'income': income, 'expense': expense, 'saldo': income - expense};
    });
  }
}

// =========================
// DATABASE CONNECTION
// =========================

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'info_saldo_db.sqlite'));
    return NativeDatabase(file);
  });
}
