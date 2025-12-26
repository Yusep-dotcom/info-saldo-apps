import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  //TODO: Implement SignupController

  TextEditingController emailC = TextEditingController(text: '123');
  TextEditingController passC = TextEditingController(text: '123');

  @override
  void onClose() {
    emailC.dispose();
    passC.dispose();

    super.onClose();
  }
}
