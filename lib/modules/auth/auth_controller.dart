import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:info_saldo_apps/routes/app_pages.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  void login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('ERROR', 'Email dan password harus diisi');
      return;
    }
    ;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar("Berhasil", "Login sukses");
    } on FirebaseAuthException catch (e) {
      print("ERROR CODE: ${e.code}");
      print("ERROR MESSAGE: ${e.message}");

      Get.snackbar("Login Gagal", e.code);
    }
  }

  void signUp(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('ERORR', 'Email dan password harus diisi');
      return;
    } else if (password.length < 6) {
      Get.snackbar('Input salah', 'Password minimal lebih dari 6 karakter');
      return;
    }

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        Get.snackbar('Selamat Datang', 'Akun berhasil dibuat');
        Get.offAllNamed(Routes.HOME);
      }

      Get.snackbar('berhasil', 'Akun anda berhasil dibuat');
    } on FirebaseAuthException catch (e) {
      print('ERROR: ${e.code}');
      Get.snackbar('Pendaftaran Gagal', e.message ?? e.code);
    }
  }

  void logout() async {
    try {
      await auth.signOut();

      Get.snackbar('Logout', 'Anda berhasil logout');
    } catch (e) {
      Get.snackbar('ERROR', 'Gagal logout: $e');
    }
  }
}
