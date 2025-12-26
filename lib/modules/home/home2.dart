import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:info_saldo_apps/modules/auth/auth_controller.dart';

class Home2 extends StatelessWidget {
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Home 2'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => authC.logout(),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
