import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/routes.dart';
import '../../../../util/api-list.dart';
import '../models/course_model.dart';
import 'discount_countdown.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Get.toNamed(Routes.courseDetails, arguments: course.id ?? 0);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_bannerUrl.isNotEmpty)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Hero(
                  tag: 'course-banner-${course.id}',
                  child: CachedNetworkImage(
                    imageUrl: _bannerUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        Container(color: Colors.grey.shade200),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title ?? '',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if ((course.subTitle ?? '').isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      course.subTitle ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      if (_hasDiscount) ...[
                        Text(
                          '৳${course.price ?? 0}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '৳$_discountPrice',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ] else
                        Text(
                          '৳${course.price ?? 0}',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if ((course.durationInMonth ?? '').isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(
                          '· ${course.durationInMonth} month',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (_hasDiscount &&
                      (course.discountEndDate ?? '').isNotEmpty) ...[
                    const SizedBox(height: 4),
                    DiscountCountdown(
                      endDate: course.discountEndDate!,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.red.shade400,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatItem(
                        icon: Icons.menu_book_outlined,
                        label: 'Class',
                        value: course.totalClass ?? '0',
                      ),
                      _StatItem(
                        icon: Icons.assignment_outlined,
                        label: 'Exam',
                        value: '${course.totalExam ?? 0}',
                      ),
                      _StatItem(
                        icon: Icons.live_tv_outlined,
                        label: 'Live',
                        value: '${course.totalLive ?? 0}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          '$value $label',
          style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
        ),
      ],
    );
  }
}
