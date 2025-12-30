import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/rekap_controller.dart';

class RekapView extends GetView<RekapController> {
  const RekapView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RekapView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'RekapView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
