import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:info_saldo_apps/data/local/database.dart';
import 'package:info_saldo_apps/modules/auth/login/views/login_view.dart';
import 'package:info_saldo_apps/modules/home/main_page.dart';
import 'package:info_saldo_apps/routes/app_pages.dart';
import 'package:info_saldo_apps/modules/auth/auth_controller.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Inisialisasi Database dan AuthController di awal
  Get.put(AppDb(), permanent: true);
  Get.put(AuthController(), permanent: true);
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes, // Tetap gunakan ini untuk navigasi manual
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), // Memantau status login
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Jika ada data (user login), tampilkan MainPage
          if (snapshot.hasData) {
            return const MainPage(); 
          }

          // Jika tidak ada data (logout/belum login), tampilkan LoginView
          return  LoginView();
        },
      ),
      theme: ThemeData(
        primaryColor: const Color(0xFF5656B4),
        useMaterial3: false, // Gunakan false jika ingin gaya desain klasik
      ),
    );
  }
}