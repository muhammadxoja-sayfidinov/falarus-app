import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/design/app_theme.dart';
import '../../../../core/design/background_scaffold.dart';
import '../data/course_providers.dart';
import '../../exam/data/exam_result_provider.dart';
import '../../exam/data/exam_result_model.dart';
import 'package:falarus/l10n/generated/app_localizations.dart';

import '../data/course_model.dart';
import '../../auth/data/user_provider.dart';
import '../../auth/data/user_model.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseDetailScreen extends ConsumerWidget {
  final String courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCourses = ref.watch(coursesProvider);
    final asyncUser = ref.watch(userDocProvider);
    final user = asyncUser.value;
    final isPremium = user?.status == UserStatus.premium;

    return asyncCourses.when(
      loading: () => const BackgroundScaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) =>
          BackgroundScaffold(body: Center(child: Text('Error: $error'))),
      data: (courses) {
        Course? course;
        try {
          course = courses.firstWhere((c) => c.id == courseId);
        } catch (_) {}

        if (course == null) {
          return const BackgroundScaffold(
            body: Center(child: Text("Course not found")),
          );
        }

        return BackgroundScaffold(
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.transparent,
                foregroundColor: AppTheme.mondeluxPrimary,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    course.title,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.mondeluxPrimary,
                    ),
                  ),
                  centerTitle: true,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final ticket = course!.tickets[index];
                    final isLocked = !isPremium && index >= 3;

                    // Check exam result
                    final examResults =
                        ref.watch(examResultsProvider).asData?.value ?? [];
                    final result = examResults.cast<ExamResult?>().firstWhere(
                      (r) => r?.ticketId == ticket.id,
                      orElse: () => null,
                    );

                    Color statusColor = AppTheme.mondeluxSecondary;
                    IconData statusIcon = Icons.play_arrow_rounded;
                    String statusText =
                        AppLocalizations.of(context)?.open ?? "Open";
                    if (isLocked) {
                      statusColor = Colors.grey;
                      statusIcon = Icons.lock_outline;
                      statusText =
                          AppLocalizations.of(context)?.locked ?? "Locked";
                    } else if (result != null) {
                      // ...
                      final correct = result.correctAnswers;
                      final total = result.totalQuestions;
                      final incorrect = total - correct;

                      if (result.status == ExamStatus.passed) {
                        statusColor =
                            AppTheme.mondeluxPrimary; // Green for passed
                        statusIcon = Icons.check_circle;
                        statusText =
                            "${AppLocalizations.of(context)!.currentScore} $correct";
                      } else if (result.status == ExamStatus.failed) {
                        statusColor = const Color(0xFFE57373); // Red for failed
                        statusIcon = Icons.cancel;
                        statusText =
                            "${AppLocalizations.of(context)!.mistakes} $incorrect";
                      }
                    }

                    return GestureDetector(
                      onTap: isLocked
                          ? () async {
                              final Uri url = Uri.parse(
                                'https://t.me/farmon_creator',
                              );
                              if (!await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              )) {
                                debugPrint('Could not launch $url');
                              }
                            }
                          : () {
                              // Start exam
                              context.push('/exam/${ticket.id}');
                            },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: isLocked
                              ? Colors.white.withValues(alpha: 0.3)
                              : (result != null
                                    ? statusColor
                                    : Colors.white.withValues(alpha: 0.9)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(
                            color: isLocked
                                ? Colors.white.withValues(alpha: 0.4)
                                : (result != null
                                      ? Colors.white.withValues(alpha: 0.2)
                                      : Colors.white),
                            width: 1.5,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          children: [
                            // Subtle background number moved to bottom right
                            Positioned(
                              bottom: -15,
                              right: -5,
                              child: Text(
                                ticket.id.replaceAll(RegExp(r'\D'), ''),
                                style: GoogleFonts.outfit(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w900,
                                  color: (result != null && !isLocked)
                                      ? Colors.white.withValues(alpha: 0.08)
                                      : AppTheme.mondeluxPrimary.withValues(
                                          alpha: 0.04,
                                        ),
                                ),
                              ),
                            ),

                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Status Icon or Lock - PERFECTLY CENTERED
                                    isLocked
                                        ? const Icon(
                                            Icons.lock_outline_rounded,
                                            size: 28,
                                            color: Colors.black26,
                                          )
                                        : result != null
                                        ? Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(
                                                alpha: 0.2,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              statusIcon,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          )
                                        : Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: AppTheme.mondeluxPrimary
                                                  .withValues(alpha: 0.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.play_arrow_rounded,
                                              color: AppTheme.mondeluxPrimary,
                                              size: 20,
                                            ),
                                          ),
                                    const SizedBox(height: 4),
                                    FittedBox(
                                      child: Text(
                                        '${AppLocalizations.of(context)!.ticket} ${index + 1}',
                                        style: GoogleFonts.outfit(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: isLocked
                                              ? Colors.black38
                                              : (result != null
                                                    ? Colors.white
                                                    : AppTheme.textPrimary),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    FittedBox(
                                      child: Text(
                                        statusText,
                                        style: GoogleFonts.outfit(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: isLocked
                                              ? Colors.black26
                                              : (result != null
                                                    ? Colors.white.withValues(
                                                        alpha: 0.8,
                                                      )
                                                    : AppTheme.mondeluxPrimary
                                                          .withValues(
                                                            alpha: 0.7,
                                                          )),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }, childCount: course.tickets.length),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
