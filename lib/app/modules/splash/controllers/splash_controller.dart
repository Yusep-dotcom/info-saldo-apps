import 'package:get/get.dart';

import 'package:info_saldo_apps/app/modules/auth/auth_wrapper.dart'; // Untuk log di console

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  void _startTimer() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.offAll(() => AuthWrapper()); 
  }
}