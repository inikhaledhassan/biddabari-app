import 'package:biddabari/app/feature/home/models/course_model.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../util/api-list.dart';
import '../../../core/server.dart';

class CourseRepository {
  static Server server = Server();
  static final _storage = GetStorage();
  static const _cacheKey = 'cached_courses';

  static CourseModel? getCachedCourses() {
    final cached = _storage.read(_cacheKey);
    if (cached == null) return null;
    try {
      return CourseModel.fromJson(Map<String, dynamic>.from(cached));
    } catch (e) {
      return null;
    }
  }

  static Future<CourseModel?> getCourses() async {
    try {
      final response = await server.getRequestWithToken(
        endPoint: APIList.courses,
      );
      if (response != null && response.statusCode == 200) {
        final courseModel = CourseModel.fromJson(response.data);
        await _storage.write(_cacheKey, response.data);
        return courseModel;
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    return null;
  }
}
