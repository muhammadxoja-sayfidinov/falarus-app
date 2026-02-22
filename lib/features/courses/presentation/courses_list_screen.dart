import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/design/app_theme.dart';
import '../../../../core/design/background_scaffold.dart';

import '../data/course_model.dart';
import '../data/course_providers.dart';

class CoursesListScreen extends ConsumerWidget {
  const CoursesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesProvider);

    return BackgroundScaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: AppTheme.mondeluxPrimary, // Dark green icons/text
            floating: true,
            title: Text(
              AppLocalizations.of(context)!.selectCourse,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                color: AppTheme.mondeluxPrimary,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.person_outline),
                onPressed: () => context.push('/profile'),
              ),
            ],
          ),

          coursesAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  color: AppTheme.mondeluxPrimary,
                ),
              ),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(
                child: Text(
                  'Error loading courses: $err',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
            data: (courses) {
              if (courses.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      "No courses available.",
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  ),
                );
              }

              // Responsive Layout Logic
              return SliverLayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.crossAxisExtent > 600;
                  final itemCount = courses.length + 2; // + VNJ, RVP

                  if (isWide) {
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 400,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 1.5, // Adjust card ratio
                            ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildCourseItem(courses, index),
                          childCount: itemCount,
                        ),
                      ),
                    );
                  } else {
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildCourseItem(courses, index),
                          ),
                          childCount: itemCount,
                        ),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCourseItem(List<Course> courses, int index) {
    if (index < courses.length) {
      final course = courses[index];
      return _CourseCard(course: course);
    } else {
      final dummyIndex = index - courses.length;
      if (dummyIndex == 0) {
        return const _DummyCourseCard(
          title: "VNJ",
          imageAsset: "assets/images/vnj.png",
        );
      } else {
        return const _DummyCourseCard(
          title: "RVP",
          imageAsset: "assets/images/pvp.png",
        );
      }
    }
  }
}

class _DummyCourseCard extends StatelessWidget {
  final String title;
  final String imageAsset;

  const _DummyCourseCard({required this.title, required this.imageAsset});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.mondeluxPrimary.withValues(alpha: 0.9),
            AppTheme.mondeluxSecondary.withValues(alpha: 0.9),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.mondeluxSecondary.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Decorative Background Watermark
            Positioned(
              right: -20,
              bottom: -20,
              child: Transform.rotate(
                angle: -0.2,
                child: Opacity(
                  opacity: 0.08,
                  child: Image.asset(
                    imageAsset,
                    width: 140,
                    height: 140,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Content
            Opacity(
              opacity: 0.7, // Slightly dimmed to indicate "coming soon"
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 24,
                ),
                child: Row(
                  children: [
                    // Leading Image
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: 70,
                        height: 70,
                        child: Image.asset(
                          imageAsset,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.lock,
                                color: Colors.white,
                                size: 40,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),

                    // Title
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Coming Soon Badge (Overlay)
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.comingSoon,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final Course course;

  const _CourseCard({required this.course});

  String _getCourseImage(String courseId) {
    // Map IDs to assets
    final lowerId = courseId.toLowerCase();
    if (lowerId.contains('patent')) return 'assets/images/patent.png';
    if (lowerId.contains('rvp')) return 'assets/images/pvp.png';
    if (lowerId.contains('vnj')) return 'assets/images/vnj.png';
    // Fallback or default
    return 'assets/images/patent.png';
  }

  @override
  Widget build(BuildContext context) {
    final imageAsset = _getCourseImage(course.id);
    final totalQuestions = course.tickets.fold<int>(
      0,
      (sum, ticket) =>
          sum +
          ticket.questions.fold<int>(
            0,
            (qSum, question) => qSum + question.subQuestions.length,
          ),
    );

    // Normal Card Layout
    return GestureDetector(
      onTap: () => context.push('/course/${course.id}'),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.mondeluxPrimary, AppTheme.mondeluxSecondary],
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.mondeluxSecondary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Decorative Background Watermark
              Positioned(
                right: -20,
                bottom: -20,
                child: Transform.rotate(
                  angle: -0.2,
                  child: Opacity(
                    opacity: 0.1, // Subtle watermark
                    child: Image.asset(
                      imageAsset,
                      width: 140,
                      height: 140,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // Decorative Circle Top Right
              Positioned(
                top: -30,
                right: -30,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 24,
                ),
                child: Row(
                  children: [
                    // Leading Image Icon - With glow for pop
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: 70,
                        height: 70,
                        child: Image.asset(
                          imageAsset,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.school,
                              color: Colors.white,
                              size: 40,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),

                    // Middle Text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.title,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.courseContentStats(
                                totalQuestions,
                                course.tickets.length,
                              ),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Trailing Arrow
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
