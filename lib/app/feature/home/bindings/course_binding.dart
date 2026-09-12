import 'package:get/get.dart';

import '../../../core/connectivity_controller.dart';
import '../controllers/course_controller.dart';

class CourseBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ConnectivityController>()) {
      Get.put(ConnectivityController(), permanent: true);
    }
    Get.lazyPut(() => CourseController());
  }
}
