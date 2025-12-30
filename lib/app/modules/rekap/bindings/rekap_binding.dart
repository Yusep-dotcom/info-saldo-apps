import 'package:get/get.dart';

import '../controllers/rekap_controller.dart';

class RekapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RekapController>(
      () => RekapController(),
    );
  }
}
