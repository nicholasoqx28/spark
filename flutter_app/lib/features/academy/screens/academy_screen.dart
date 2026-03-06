import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/models/course.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../../../shared/widgets/spark_badge.dart';

final _coursesProvider = FutureProvider<List<Course>>((ref) async {
  final api = ref.read(apiClientProvider);
  final res = await api.get<List<dynamic>>('/api/courses');
  return (res.data as List)
      .map((j) => Course.fromJson(j as Map<String, dynamic>))
      .toList();
});

class AcademyScreen extends ConsumerWidget {
  const AcademyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCourses = ref.watch(_coursesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Academy')),
      body: asyncCourses.when(
        loading: () => const LoadingOverlay(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (courses) {
          if (courses.isEmpty) {
            return const Center(
              child: Text('No courses available yet.',
                  style: TextStyle(color: Colors.grey)),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: courses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) => _CourseCard(course: courses[i]),
          );
        },
      ),
    );
  }
}

class _CourseCard extends ConsumerStatefulWidget {
  final Course course;
  const _CourseCard({required this.course});

  @override
  ConsumerState<_CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends ConsumerState<_CourseCard> {
  bool _enrolling = false;

  Future<void> _enroll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enrol in course'),
        content: Text('Join "${widget.course.title}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Enrol')),
        ],
      ),
    );

    if (confirmed != true) return;
    setState(() => _enrolling = true);

    try {
      final api = ref.read(apiClientProvider);
      await api.post<dynamic>(
        '/api/enrollments',
        data: {'courseId': widget.course.id},
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enrolled successfully!')),
        );
        ref.invalidate(_coursesProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _enrolling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.course;
    final user = ref.watch(authProvider).user;
    final canEnrol = user != null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(c.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                SparkBadge(label: c.level, color: levelColor(c.level)),
              ],
            ),
            const SizedBox(height: 6),
            Text(c.sport,
                style: const TextStyle(
                    color: Color(0xFF4F46E5), fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text(c.description,
                style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.menu_book_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text('${c.lessonCount} lessons',
                    style:
                        const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(width: 16),
                const Icon(Icons.group_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text('${c.enrollmentCount} enrolled',
                    style:
                        const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            if (canEnrol) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _enrolling ? null : _enroll,
                  child: _enrolling
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Enrol now'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
