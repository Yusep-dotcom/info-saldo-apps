import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:info_saldo_apps/modules/auth/auth_controller.dart';
import 'package:info_saldo_apps/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({super.key});

  final emailC = TextEditingController();
  final passC = TextEditingController();

  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoginView'),
        backgroundColor: Color(0xFF5656B4),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: emailC,
                decoration: InputDecoration(
                  hintText: 'Masukan email anda',
                  label: Text('Email'),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passC,
                decoration: InputDecoration(
                  hintText: 'Masukan password anda',
                  label: Text('Password'),
                ),
              ),
              SizedBox(height: 20),
          
              ElevatedButton(
                onPressed: () => authC.login(emailC.text, passC.text),
                child: Text('Login'),
              ),
              SizedBox(height: 8,),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Belum punya akun? '),
                  TextButton(
                    onPressed: () => Get.toNamed(Routes.SIGNUP),
                    child: Text('Daftar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
