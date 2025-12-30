import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:info_saldo_apps/app/data/local/database.dart';
import 'package:info_saldo_apps/app/modules/category/controller/category_controller.dart';
import 'package:info_saldo_apps/app/routes/app_pages.dart';
import 'package:info_saldo_apps/app/modules/auth/auth_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.put(AppDb(), permanent: true);
  Get.put(AuthController(), permanent: true);
  Get.put<CategoryController>(CategoryController(), permanent: true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
      initialRoute: '/splash',
      onInit: () {
        print("GetMaterialApp Dimulai!");
      },
      theme: ThemeData(
        primaryColor: const Color(0xFF5656B4),
        useMaterial3: false,
      ),
    );
  }
}
