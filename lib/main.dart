import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:info_saldo_apps/app/data/local/database.dart';
import 'package:info_saldo_apps/app/routes/app_pages.dart';
import 'package:info_saldo_apps/app/modules/auth/auth_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Inisialisasi Database dan AuthController di awal
  Get.put(AuthController(), permanent: true);
  if (!Get.isRegistered<AppDb>()) {
    Get.put(AppDb(), permanent: true);
  }

  if (!Get.isRegistered<AuthController>()) {
    Get.put(AuthController(), permanent: true);
  }

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
