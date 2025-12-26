import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_saldo_apps/routes/app_pages.dart';
import 'package:info_saldo_apps/modules/auth/auth_controller.dart';

import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text('SignupView', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            TextField(
              controller: controller.emailC,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukan email',
                label: Text('Email'),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: controller.passC,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukan Pas  sword',
                label: Text('Password'),
              ),
            ),

            SizedBox(height: 30),

            ElevatedButton(
              onPressed: () =>
                  authC.signUp(controller.emailC.text, controller.passC.text),
              child: Text('Daftar'),
            ),

            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sudah Punya Akun? '),
                TextButton(
                  onPressed: () => Get.toNamed(Routes.LOGIN),
                  child: Text('Login', style: GoogleFonts.montserrat()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
