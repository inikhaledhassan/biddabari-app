import 'package:get/get.dart';

import '../app/feature/home/bindings/course_binding.dart';
import '../app/feature/home/screens/course_details_screen.dart';
import '../app/feature/home/screens/home_screen.dart';
import '../app/feature/splash/screens/screens.dart';
import 'routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.initial,
      page: () => const SplashScreen(),
      transition: Transition.fade,
      binding: CourseBinding(),
    ),

    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      transition: Transition.fade,
      binding: CourseBinding(),
    ),

    GetPage(
      name: Routes.courseDetails,
      page: () => CourseDetailsScreen(courseId: Get.arguments as int),
      transition: Transition.fade,
      binding: CourseBinding(),
    ),
  ];
}
