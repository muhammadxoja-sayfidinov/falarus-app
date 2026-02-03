import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/design/app_theme.dart';
import '../../../../core/design/background_scaffold.dart';
import '../../../../core/design/glass_container.dart';
import '../../courses/data/course_providers.dart';
import '../../courses/data/course_model.dart';
import 'question_widgets.dart';
import 'package:falarus/l10n/generated/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/exam_result_model.dart';

class ExamRunnerScreen extends ConsumerStatefulWidget {
  final String ticketId;

  const ExamRunnerScreen({super.key, required this.ticketId});

  @override
  ConsumerState<ExamRunnerScreen> createState() => _ExamRunnerScreenState();
}

class _ExamRunnerScreenState extends ConsumerState<ExamRunnerScreen> {
  late PageController _pageController;
  late ScrollController _indicatorScrollController;
  int _currentIndex = 0;

  // State keys: "${questionId}_${subQuestionIndex}"
  final Map<String, int> _answers = {}; // key -> selectedOptionIndex
  final Map<String, String> _textAnswers = {}; // key -> textAnswer
  // Track which written answers have been "checked" by the user
  final Set<String> _checkedSubQuestions = {};
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _indicatorScrollController = ScrollController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _indicatorScrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentIndicator() {
    if (!_indicatorScrollController.hasClients) return;

    // Fixed width/margin from the indicator container: width(44) + margin(4*2) = 52
    const double indicatorWidthWithMargin = 52.0;
    final double targetOffset =
        (_currentIndex * indicatorWidthWithMargin) -
        (MediaQuery.of(context).size.width / 2) +
        (indicatorWidthWithMargin / 2);

    _indicatorScrollController.animateTo(
      targetOffset.clamp(
        0.0,
        _indicatorScrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  String _getKey(String qId, int subCIndex) => "${qId}_$subCIndex";

  void _submitExam(Ticket ticket) {
    setState(() {
      _isSubmitted = true;
    });
    // Calculate Score
    int correct = 0;
    int totalSubQuestions = 0;

    for (var q in ticket.questions) {
      for (int i = 0; i < q.subQuestions.length; i++) {
        totalSubQuestions++;
        final subQ = q.subQuestions[i];
        final key = _getKey(q.id, i);

        if (q.answerType == AnswerType.written) {
          if (subQ.correctTextAnswer != null &&
              _textAnswers[key]?.trim().toLowerCase() ==
                  subQ.correctTextAnswer!.trim().toLowerCase()) {
            correct++;
          }
        } else {
          // Multiple choice
          if (_answers[key] == subQ.correctOptionIndex) {
            correct++;
          }
        }
      }
    }

    // Determine Status
    final status = correct >= 20 ? ExamStatus.passed : ExamStatus.failed;

    // Save to Firestore
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final result = ExamResult(
        ticketId: ticket.id,
        courseId: 'unknown',
        correctAnswers: correct,
        totalQuestions: totalSubQuestions,
        status: status,
        timestamp: DateTime.now(),
      );

      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('exam_results')
          .doc(ticket.id)
          .set(result.toMap(), SetOptions(merge: true));
    }

    // Show Result Dialog
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent, // Transparent for GlassContainer
        insetPadding: const EdgeInsets.all(24),
        child: GlassContainer(
          color: AppTheme.mondeluxSurfaceSecond, // Use standard surface color
          borderRadius: BorderRadius.circular(24),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Result Icon / Title
              Text(
                status == ExamStatus.passed
                    ? AppLocalizations.of(context)!.passed
                    : AppLocalizations.of(context)!.failed,
                style: GoogleFonts.outfit(
                  color: status == ExamStatus.passed
                      ? AppTheme
                            .mondeluxPrimary // Emerald green
                      : const Color(0xFFE57373), // Soft red
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Score
              Text(
                "$correct / $totalSubQuestions",
                style: GoogleFonts.outfit(
                  color: AppTheme.textPrimary,
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.correctAnswers,
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.pop(); // Close dialog
                    context.pop(); // Go back to course screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.mondeluxPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.finish,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncCourses = ref.watch(coursesProvider);

    return asyncCourses.when(
      loading: () => const BackgroundScaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => BackgroundScaffold(
        body: Center(
          child: Text(
            'Error loading exam: $error',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      data: (courses) {
        Ticket? ticket;
        try {
          ticket = courses
              .expand((c) => c.tickets)
              .firstWhere((t) => t.id == widget.ticketId);
        } catch (e) {
          // Ticket not found
        }

        if (ticket == null || ticket.questions.isEmpty) {
          return BackgroundScaffold(
            body: Center(
              child: Text(AppLocalizations.of(context)!.errorLoadingTicket),
            ),
          );
        }

        return BackgroundScaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            actionsIconTheme: const IconThemeData(
              color: AppTheme.mondeluxPrimary,
            ),
            iconTheme: const IconThemeData(color: AppTheme.mondeluxPrimary),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                children: [
                  // Question Indicators
                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SingleChildScrollView(
                      controller: _indicatorScrollController,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: List.generate(ticket.questions.length, (
                          index,
                        ) {
                          final question = ticket!.questions[index];

                          // Check if question is answered
                          bool isAnswered = true;
                          bool isCorrect = false;

                          for (
                            int i = 0;
                            i < question.subQuestions.length;
                            i++
                          ) {
                            final key = _getKey(question.id, i);
                            if (question.answerType == AnswerType.written) {
                              if ((_textAnswers[key] ?? '').trim().isEmpty ||
                                  !_checkedSubQuestions.contains(key)) {
                                isAnswered = false;
                                break;
                              }
                              // Check if correct
                              if (question.subQuestions[i].correctTextAnswer !=
                                      null &&
                                  _textAnswers[key]?.trim().toLowerCase() ==
                                      question
                                          .subQuestions[i]
                                          .correctTextAnswer!
                                          .trim()
                                          .toLowerCase()) {
                                isCorrect = true;
                              }
                            } else {
                              if (!_answers.containsKey(key)) {
                                isAnswered = false;
                                break;
                              }
                              // Check if correct
                              if (_answers[key] ==
                                  question.subQuestions[i].correctOptionIndex) {
                                isCorrect = true;
                              }
                            }
                          }

                          Color indicatorColor;
                          if (!isAnswered) {
                            indicatorColor = const Color(0xFF90A4AE);
                          } else if (isCorrect) {
                            indicatorColor = const Color(0xFF0B5444);
                          } else {
                            indicatorColor = Colors.red;
                          }

                          final isCurrent = index == _currentIndex;

                          return GestureDetector(
                            onTap: () {
                              _pageController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 44,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isCurrent
                                    ? indicatorColor
                                    : indicatorColor.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(12),
                                border: isCurrent
                                    ? Border.all(
                                        color: AppTheme.mondeluxPrimary,
                                        width: 2.5,
                                      )
                                    : Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.3,
                                        ),
                                        width: 1,
                                      ),
                                boxShadow: isCurrent
                                    ? [
                                        BoxShadow(
                                          color: indicatorColor.withValues(
                                            alpha: 0.4,
                                          ),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${index + 1}',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),

                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      physics: const ClampingScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                        _scrollToCurrentIndicator();
                      },
                      itemCount: ticket.questions.length,
                      itemBuilder: (context, index) {
                        final question = ticket!.questions[index];

                        // Prepare subAnswers map for this specific question
                        final Map<int, int> subAnswers = {};
                        final Map<int, String> subTexts = {};

                        for (int i = 0; i < question.subQuestions.length; i++) {
                          final key = _getKey(question.id, i);
                          if (_answers.containsKey(key)) {
                            subAnswers[i] = _answers[key]!;
                          }
                          if (_textAnswers.containsKey(key)) {
                            subTexts[i] = _textAnswers[key]!;
                          }
                        }

                        return QuestionWidget(
                          question: question,
                          selectedAnswers: subAnswers,
                          textAnswers: subTexts,
                          isSubmitted: _isSubmitted,
                          // Filter checks to only those for this question
                          checkedSubQuestions: _checkedSubQuestions
                              .where((k) => k.startsWith("${question.id}_"))
                              .map((k) {
                                // Extract just the subIndex from key "${question.id}_${subIndex}"
                                final parts = k.split('_');
                                return int.tryParse(parts.last) ?? -1;
                              })
                              .toSet(),
                          onOptionSelected: (subIndex, optionIndex) {
                            if (_isSubmitted) return;
                            setState(() {
                              _answers[_getKey(question.id, subIndex)] =
                                  optionIndex;
                            });
                          },
                          onTextAnswerChanged: (subIndex, text) {
                            if (_isSubmitted) return;
                            // Cannot change if already checked
                            if (_checkedSubQuestions.contains(
                              _getKey(question.id, subIndex),
                            ))
                              return;

                            setState(() {
                              _textAnswers[_getKey(question.id, subIndex)] =
                                  text;
                            });
                          },
                          onCheckPressed: (subIndex) {
                            setState(() {
                              _checkedSubQuestions.add(
                                _getKey(question.id, subIndex),
                              );
                            });
                          },
                        );
                      },
                    ),
                  ),

                  // Navigation Bar
                  Builder(
                    builder: (context) {
                      // Check if ALL questions are answered
                      bool areAllQuestionsAnswered = true;
                      for (var q in ticket!.questions) {
                        for (int i = 0; i < q.subQuestions.length; i++) {
                          final key = _getKey(q.id, i);
                          if (q.answerType == AnswerType.written) {
                            if ((_textAnswers[key] ?? '').trim().isEmpty ||
                                !_checkedSubQuestions.contains(key)) {
                              areAllQuestionsAnswered = false;
                              break;
                            }
                          } else {
                            if (!_answers.containsKey(key)) {
                              areAllQuestionsAnswered = false;
                              break;
                            }
                          }
                        }
                        if (!areAllQuestionsAnswered) break;
                      }

                      if (!areAllQuestionsAnswered)
                        return const SizedBox.shrink();

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 16,
                              offset: const Offset(0, -4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.mondeluxPrimary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 48,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: _isSubmitted
                                ? null
                                : () => _submitExam(ticket!),
                            child: Text(
                              AppLocalizations.of(context)!.submit,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
