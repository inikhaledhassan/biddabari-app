import 'package:get/get.dart';
import '../../../core/connectivity_controller.dart';
import '../../../core/server.dart';
import '../models/course_model.dart';
import '../repository/course_repository.dart';

class CourseController extends GetxController {
  static Server server = Server();

  final courses = <Course>[].obs;

  final loader = false.obs;

  @override
  void onInit() {
    _loadCachedCourses();
    getCourses();
    ever(Get.find<ConnectivityController>().isOnline, (isOnline) {
      if (isOnline == true) {
        getCourses();
      }
    });
    super.onInit();
  }

  void _loadCachedCourses() {
    final cached = CourseRepository.getCachedCourses();
    if (cached?.courses?.isNotEmpty ?? false) {
      courses.value = cached!.courses!;
    }
  }

  Future getCourses() async {
    if (courses.isEmpty) {
      loader.value = true;
    }

    final courseData = await CourseRepository.getCourses();

    if (courseData != null) {
      courses.value = courseData.courses ?? [];
    }
    loader.value = false;
  }
}
