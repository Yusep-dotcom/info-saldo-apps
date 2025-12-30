part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const SIGNUP = _Paths.SIGNUP;
  static const LOGIN = _Paths.LOGIN;
  static const SPLASH = _Paths.SPLASH;
  static const MAIN = _Paths.MAIN;
  static const REKAP = _Paths.REKAP;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const SIGNUP = '/signup';
  static const LOGIN = '/login';
  static const SPLASH = '/splash';
  static const MAIN = '/main';
  static const REKAP = '/rekap';
}
