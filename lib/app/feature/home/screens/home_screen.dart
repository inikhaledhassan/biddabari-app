import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/connectivity_controller.dart';
import '../controllers/course_controller.dart';
import '../widgets/course_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courseController = Get.find<CourseController>();
    final connectivityController = Get.find<ConnectivityController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text('BiddaBari Courses'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Obx(
            () => connectivityController.isOnline.value
                ? const SizedBox.shrink()
                : Container(
                    width: double.infinity,
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      'ইন্টারনেট সংযোগ নেই',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await courseController.getCourses();
              },
              child: Obx(() {
                if (courseController.loader.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (courseController.courses.isEmpty) {
                  return Obx(
                    () => !connectivityController.isOnline.value
                        ? _NoInternetView(onRetry: courseController.getCourses)
                        : ListView(
                            children: const [
                              SizedBox(height: 120),
                              Center(child: Text('কোনো কোর্স পাওয়া যায়নি')),
                            ],
                          ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemBuilder: (context, index) {
                    final course = courseController.courses[index];
                    return CourseCard(course: course);
                  },
                  itemCount: courseController.courses.length,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoInternetView extends StatelessWidget {
  final Future<void> Function() onRetry;

  const _NoInternetView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 100),
        Icon(Icons.wifi_off, size: 56, color: Colors.grey.shade400),
        const SizedBox(height: 12),
        const Text(
          'ইন্টারনেট সংযোগ নেই',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          'দয়া করে আপনার ইন্টারনেট চেক করে আবার চেষ্টা করুন',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 16),
        Center(
          child: OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('আবার চেষ্টা করুন'),
          ),
        ),
      ],
    );
  }
}
