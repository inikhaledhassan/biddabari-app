import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../util/api-list.dart';
import '../controllers/course_controller.dart';
import '../models/course_model.dart';
import '../widgets/discount_countdown.dart';

class CourseDetailsScreen extends StatelessWidget {
  final int courseId;

  const CourseDetailsScreen({super.key, required this.courseId});

  Course? _findCourse(List<Course> courses) {
    for (final course in courses) {
      if (course.id == courseId) return course;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CourseController>();
    return Obx(() {
      final course = _findCourse(controller.courses);
      if (course == null) {
        return const Scaffold(
          body: Center(child: Text('কোর্সটি পাওয়া যায়নি')),
        );
      }
      return _CourseDetailsView(course: course, courseId: courseId);
    });
  }
}

class _CourseDetailsView extends StatelessWidget {
  final Course course;
  final int courseId;

  const _CourseDetailsView({required this.course, required this.courseId});

  String get _bannerUrl {
    final banner = course.banner ?? '';
    if (banner.isEmpty) return '';
    final index = banner.indexOf('/backend');
    final path = index != -1 ? banner.substring(index) : '/$banner';
    return '${APIList.imageServer}$path';
  }

  int get _discountPrice {
    final price = course.price ?? 0;
    final amount = course.discountAmount ?? 0;
    if (amount <= 0) return price;
    final discounted = price - amount;
    return discounted < 0 ? 0 : discounted;
  }

  bool get _hasDiscount => (course.discountAmount ?? 0) > 0;

  int get _discountPercent {
    final price = course.price ?? 0;
    if (price <= 0) return 0;
    return (((course.discountAmount ?? 0) / price) * 100).round();
  }

  bool get _isEnrolled =>
      (course.orderStatus ?? 'false').toLowerCase() == 'true';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 220,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'course-banner-$courseId',
                child: _bannerUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: _bannerUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: Colors.grey.shade200),
                        errorWidget: (context, url, error) =>
                            Container(color: Colors.grey.shade200),
                      )
                    : Container(color: Colors.grey.shade200),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                24 + MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title ?? '',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if ((course.subTitle ?? '').isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      course.subTitle ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (_hasDiscount) ...[
                        Text(
                          '৳${course.price ?? 0}',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey.shade500,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '৳$_discountPrice',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$_discountPercent% OFF',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ),
                      ] else
                        Text(
                          '৳${course.price ?? 0}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  if (_hasDiscount &&
                      (course.discountEndDate ?? '').isNotEmpty) ...[
                    const SizedBox(height: 4),
                    DiscountCountdown(
                      endDate: course.discountEndDate!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade400,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _InfoStat(
                          icon: Icons.menu_book_outlined,
                          label: 'Total Class',
                          value: course.totalClass ?? '0',
                        ),
                        _InfoStat(
                          icon: Icons.assignment_outlined,
                          label: 'Total Exam',
                          value: '${course.totalExam ?? 0}',
                        ),
                        _InfoStat(
                          icon: Icons.live_tv_outlined,
                          label: 'Live Class',
                          value: '${course.totalLive ?? 0}',
                        ),
                        _InfoStat(
                          icon: Icons.calendar_month_outlined,
                          label: 'Duration',
                          value: '${course.durationInMonth ?? '0'} month',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Course Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _DetailRow(label: 'Course ID', value: '${course.id ?? '-'}'),
                  _DetailRow(
                    label: 'Duration',
                    value: '${course.durationInMonth ?? '-'} month',
                  ),
                  _DetailRow(
                    label: 'Total Class',
                    value: course.totalClass ?? '-',
                  ),
                  _DetailRow(
                    label: 'Total Exam',
                    value: '${course.totalExam ?? '-'}',
                  ),
                  _DetailRow(
                    label: 'Total Live Class',
                    value: '${course.totalLive ?? '-'}',
                  ),
                  _DetailRow(
                    label: 'Regular Price',
                    value: '৳${course.price ?? 0}',
                  ),
                  if (_hasDiscount) ...[
                    _DetailRow(
                      label: 'Discount Amount',
                      value: '৳${course.discountAmount ?? 0}',
                    ),
                    _DetailRow(
                      label: 'Discounted Price',
                      value: '৳$_discountPrice',
                    ),
                    _DetailRow(
                      label: 'Discount Start',
                      value: course.discountStartDate ?? '-',
                    ),
                    _DetailRow(
                      label: 'Discount End',
                      value: course.discountEndDate ?? '-',
                    ),
                  ],
                  _DetailRow(
                    label: 'Enrollment Status',
                    value: _isEnrolled ? 'Enrolled' : 'Not Enrolled',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 22, color: Colors.grey.shade700),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
