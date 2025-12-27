import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_saldo_apps/app/routes/app_pages.dart';
import 'package:info_saldo_apps/app/modules/auth/auth_controller.dart';

import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(140),
        child: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 160,
          foregroundColor: Colors.black,
          title: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Daftar',
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(26),
          child: Column(
            children: [
              SizedBox(height: 10),

              // ini untuk email
              inputField(
                controller: controller.emailC,
                hint: 'Masukan email anda',
                isPassword: false,
                colorSide: Colors.grey.shade300,
              ),

              SizedBox(height: 10),

              // ini untuk password
              inputField(
                controller: controller.passC,
                hint: 'Masukan password anda',
                isPassword: true,
                colorSide: Colors.grey.shade300,
              ),

              SizedBox(height: 10),

              // ini untuk password
              inputField(
                controller: controller.passC,
                hint: 'Ulangi password anda',
                isPassword: true,
                colorSide: Colors.grey.shade300,
              ),

              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => authC.signUp(
                    controller.emailC.text,
                    controller.passC.text,
                  ),
                  child: Text(
                    'Buat akun anda',
                    style: GoogleFonts.poppins(fontSize: 17),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5656B4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              Text('Atau', style: GoogleFonts.poppins(fontSize: 10)),

              SizedBox(height: 20),

              socialButton(
                color: Color(0xFF5656B4),
                icon: Icons.facebook,
                teks: 'Masuk dengan facebook',
              ),

              SizedBox(height: 10),

              socialButton(
                color: Colors.red,
                icon: Icons.g_mobiledata,
                teks: 'Masuk dengan google',
              ),

              SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Sudah punya akun?', style: GoogleFonts.poppins()),
                  TextButton(
                    onPressed: () => Get.offAllNamed(Routes.LOGIN),
                    child: Text(
                      'Login',
                      style: GoogleFonts.poppins(color: Color(0xFF5656B4)),
                    ),
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

class socialButton extends StatelessWidget {
  const socialButton({
    super.key,
    required this.color,
    required this.icon,
    required this.teks,
  });

  final String? teks;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,

      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(icon),
        label: Text('$teks', style: GoogleFonts.poppins(color: color)),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.grey.shade300,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class inputField extends StatelessWidget {
  const inputField({
    super.key,
    required this.controller,
    required this.hint,
    this.isPassword = true,
    required this.colorSide,
  });

  final TextEditingController controller;
  final String hint;
  final bool isPassword;
  final Color colorSide;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          obscureText: isPassword,

          style: GoogleFonts.poppins(fontSize: 14),
          decoration: InputDecoration(
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: hint,
            hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colorSide),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }
}
