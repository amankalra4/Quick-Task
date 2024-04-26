import 'package:get/get.dart';
import '../exports.dart';
part 'routes.dart';

class Pages {
  static const initial = Routes.login;

  static final routes = [
    GetPage(
      name: Paths.login,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Paths.register,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Paths.home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Paths.tasks,
      page: () => TasksView(),
      binding: TasksBinding(),
    )
  ];
}
