part of 'pages.dart';

abstract class Routes {
  static const login = Paths.login;
  static const register = Paths.register;
  static const home = Paths.home;
  static const tasks = Paths.tasks;
}

abstract class Paths {
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const tasks = '/tasks';
}
