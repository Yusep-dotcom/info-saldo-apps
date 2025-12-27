import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_saldo_apps/app/data/local/database.dart';
import 'package:info_saldo_apps/app/data/models/transaction_with_category.dart';
import 'package:info_saldo_apps/app/modules/auth/auth_controller.dart';
import 'package:intl/intl.dart';

class TransactionPage extends StatefulWidget {
  final TransactionWithCategory? transactionwithCategory;
  const TransactionPage({super.key, this.transactionwithCategory});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  bool isIncome = true;
  final database = Get.find<AppDb>();
  List<String> list = ['Makan', 'Jajan', 'Transportasi'];
  TextEditingController kategoriController = TextEditingController();
  TextEditingController dateControler = TextEditingController();
  TextEditingController amountControler = TextEditingController();
  TextEditingController namaControler = TextEditingController();
  Category? selectedCategory;
  late int type;

  late String dropDownValue = list.last;

  final authC = Get.find<AuthController>();

  Future insert(int amount, DateTime date, String name, int category_id) async {
    DateTime now = DateTime.now();
    final row = await database
        .into(database.transactions)
        .insertReturning(
          TransactionsCompanion.insert(
            title: name,
            category_id: category_id,
            transaction_date: date,
            amount: amount,
            createdAt: now,
            updateAt: now,
          ),
        );
    print('apa ini' + row.toString());
  }

  Future<List<Category>> getAllCategories(int type) async {
    return database.getAllCategoriesRepo(type);
  }

  @override
  void initState() {
    super.initState();

    type = 2;

    if (widget.transactionwithCategory != null) {
      updateTransactionView(widget.transactionwithCategory!);
    }
  }

  void updateTransactionView(TransactionWithCategory data) {
    amountControler.text = data.transaction.amount.toString();
    namaControler.text = data.transaction.title;
    dateControler.text = DateFormat(
      'yyyy-MM-dd',
    ).format(data.transaction.transaction_date);

    selectedCategory = data.category;

    isIncome = data.category.type == 2;
    type = data.category.type;
    (type == 1) ? isIncome = true : isIncome = false;
  }

  void dispose() {
    database.close();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actionsPadding: EdgeInsets.only(top: 15),
        title: Text(
          'Tambah Transaksi',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),

        backgroundColor: Color(0xFF5656B4),
        toolbarHeight: 85,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isIncome = true;
                        type = (isIncome) ? 2 : 1;
                        selectedCategory = null;
                      });
                    },
                    child: Container(
                      width: 40,
                      margin: EdgeInsets.only(top: 20, left: 16),
                      padding: EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: isIncome ? Color(0xFF5656B4) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0xFF5656B4), width: 2),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Pemasukan',
                        style: GoogleFonts.montserrat(
                          color: isIncome ? Colors.white : Color(0xFF5656B4),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),

                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isIncome = false;
                        type = (isIncome) ? 2 : 1;
                        selectedCategory = null;
                      });
                    },
                    child: Container(
                      width: 40,
                      margin: EdgeInsets.only(top: 20, right: 16),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: isIncome ? Colors.white : Color(0xFF5656B4),
                        border: Border.all(color: Color(0xFF5656B4), width: 2),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Pengeluaran",
                        style: GoogleFonts.montserrat(
                          color: isIncome ? Color(0xFF5656B4) : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: amountControler,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hint: Text('Jumlah'),
                    ),
                  ),
                  SizedBox(height: 10),

                  Text(
                    'Kategori: ',
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  FutureBuilder<List<Category>>(
                    future: getAllCategories(type),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        final categories = snapshot.data!;

                        // SET DEFAULT SEKALI SAJA
                        if (selectedCategory == null) {
                          selectedCategory = categories.first;
                        }

                        return DropdownButton<Category>(
                          isExpanded: true,
                          value: selectedCategory,
                          icon: Icon(Icons.arrow_downward),
                          items: categories.map((Category item) {
                            return DropdownMenuItem<Category>(
                              value: item,
                              child: Text(item.name),
                            );
                          }).toList(),
                          onChanged: (Category? value) {
                            setState(() {
                              selectedCategory = value;
                            });
                          },
                        );
                      }

                      return Center(child: Text('Data kosong'));
                    },
                  ),

                  SizedBox(height: 10),
                  TextFormField(
                    controller: dateControler,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hint: Text('Tanggal'),
                    ),
                    onTap: () async {
                      DateTime? PickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2025),
                        lastDate: DateTime(2099),
                      );
                      if (PickedDate != null) {
                        String formatedDate = DateFormat(
                          'yyyy-MM-dd',
                        ).format(PickedDate);

                        dateControler.text = formatedDate;
                      }
                    },
                  ),

                  SizedBox(height: 10),
                  TextField(
                    controller: namaControler,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hint: Text('Ketik disini untuk keterangan'),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          insert(
                            int.parse(amountControler.text),
                            DateTime.parse(dateControler.text),
                            namaControler.text,
                            selectedCategory!.id,
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF5656B4),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Tambah', style: GoogleFonts.montserrat()),
                      ),
                      ElevatedButton(
                        onPressed: () => authC.logout(),
                        child: Icon(Icons.logout),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
