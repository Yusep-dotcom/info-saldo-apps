import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_saldo_apps/app/modules/category/category_page.dart';
import 'package:info_saldo_apps/app/modules/transaction/view/transaction_page.dart';
import 'package:info_saldo_apps/app/modules/home/home_page.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DateTime selectedDate = DateTime.now();
  int currentIndex = 0;
  late List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _children = [HomePage(selectedDate: selectedDate), const CategoryPage()];
  }

  void updateView(int index, DateTime? date) {
    if (date != null) {
      selectedDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(date));
    }

    setState(() {
      currentIndex = index;
      _children = [HomePage(selectedDate: selectedDate), const CategoryPage()];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: currentIndex == 0
          ? CalendarAppBar(
              accent: const Color(0xFF5656B4),
              backButton: false,
              locale: 'id',
              onDateChanged: (value) {
                updateView(0, value);
              },
              firstDate: DateTime.now().subtract(const Duration(days: 140)),
              lastDate: DateTime.now(),
            )
          : PreferredSize(
              preferredSize: const Size.fromHeight(85),
              child: Container(
                height: 85,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 15),
                color: const Color(0xFF5656B4),
                child: Text(
                  'Category',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

      floatingActionButton: Visibility(
        visible: (currentIndex == 0) ? true : false,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TransactionPage()),
              );
            });
          },
          backgroundColor: Color(0xFF5656B4),
          shape: CircleBorder(),
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                updateView(0, DateTime.now());
              },
              icon: Icon(Icons.home),
            ),
            SizedBox(width: 20),
            IconButton(
              onPressed: () {
                updateView(1, null);
              },
              icon: Icon(Icons.list),
            ),
          ],
        ),
      ),
      body: _children[currentIndex],
    );
  }
}
