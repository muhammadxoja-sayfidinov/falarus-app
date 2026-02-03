import 'package:flutter/material.dart';
import 'package:falarus/l10n/generated/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:audioplayers/audioplayers.dart';

import '../../courses/data/course_model.dart';
import '../../../../core/design/app_theme.dart';

class QuestionWidget extends StatelessWidget {
  final Question question;
  // Map of subQuestionIndex -> selectedOptionIndex
  final Map<int, int> selectedAnswers;
  // Map of subQuestionIndex -> textAnswer
  final Map<int, String> textAnswers;

  // Set of subQuestion indexes that have been "checked" (for written answers)
  final Set<int> checkedSubQuestions;
  final ValueChanged<int> onCheckPressed;

  final Function(int subIndex, int optionIndex) onOptionSelected;
  final Function(int subIndex, String text) onTextAnswerChanged;
  final bool isSubmitted;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.selectedAnswers,
    required this.textAnswers,
    required this.checkedSubQuestions,
    required this.onOptionSelected,
    required this.onTextAnswerChanged,
    required this.onCheckPressed,
    required this.isSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Description Text (Long text, title, or instruction)
          if (question.descriptionText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  question.descriptionText!,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    height: 1.5,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ),

          // Universal Media Display logic
          if (question.mediaUrl != null)
            _buildMedia(question.mediaUrl!, question.type),

          // Render all sub-questions
          // If it's a normal QuestionType.text, subQuestions has 1 item.
          // If audioDouble, it has multiple.
          for (int i = 0; i < question.subQuestions.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: _SubQuestionItem(
                subQuestion: question.subQuestions[i],
                index: i,
                totalSubQuestions: question.subQuestions.length,
                selectedOptionIndex: selectedAnswers[i],
                textAnswer: textAnswers[i],
                answerType: question.answerType,
                isSubmitted: isSubmitted,
                isChecked: checkedSubQuestions.contains(i),
                onOptionSelected: (idx) => onOptionSelected(i, idx),
                onTextChanged: (val) => onTextAnswerChanged(i, val),
                onCheckPressed: () => onCheckPressed(i),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMedia(String url, QuestionType type) {
    bool isAudio =
        type == QuestionType.audio ||
        type == QuestionType.audioDouble ||
        url.toLowerCase().contains('mp3') ||
        url.toLowerCase().contains('wav') ||
        url.toLowerCase().contains('m4a');

    bool isImage =
        type == QuestionType.image ||
        url.toLowerCase().contains('png') ||
        url.toLowerCase().contains('jpg') ||
        url.toLowerCase().contains('jpeg') ||
        url.toLowerCase().contains('webp');

    if (isAudio) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: FirebaseAudioWidget(pathOrUrl: url),
      );
    }

    if (isImage) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: FirebaseImageWidget(pathOrUrl: url, fit: BoxFit.contain),
      );
    }

    return const SizedBox.shrink();
  }
}

class _SubQuestionItem extends StatelessWidget {
  final SubQuestion subQuestion;
  final int index;
  final int totalSubQuestions;
  final int? selectedOptionIndex;
  final String? textAnswer;
  final AnswerType answerType;
  final bool isSubmitted;
  final bool isChecked;
  final ValueChanged<int> onOptionSelected;
  final ValueChanged<String> onTextChanged;
  final VoidCallback onCheckPressed;

  const _SubQuestionItem({
    required this.subQuestion,
    required this.index,
    required this.totalSubQuestions,
    required this.selectedOptionIndex,
    required this.textAnswer,
    required this.answerType,
    required this.isSubmitted,
    required this.isChecked,
    required this.onOptionSelected,
    required this.onTextChanged,
    required this.onCheckPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // If there are multiple subquestions (e.g. audioDouble), number them.
          if (totalSubQuestions > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                "${index + 1}. ${subQuestion.text}",
                style: GoogleFonts.outfit(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            )
          else if (subQuestion.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                subQuestion.text,
                style: GoogleFonts.outfit(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          if (answerType == AnswerType.written)
            _WrittenAnswerInput(
              isSubmitted: isSubmitted,
              isChecked: isChecked,
              initialValue: textAnswer,
              correctAnswer: subQuestion.correctTextAnswer,
              onChanged: onTextChanged,
              onCheckPressed: onCheckPressed,
            )
          else
            _buildOptions(),
        ],
      ),
    );
  }

  Widget _buildOptions() {
    final isAnswered = selectedOptionIndex != null;

    return Column(
      children: List.generate(subQuestion.options.length, (optIndex) {
        final isSelected = selectedOptionIndex == optIndex;
        Color? cardColor;
        Color? borderColor;
        final optionText = subQuestion.options[optIndex];
        final isImageOption =
            optionText.toLowerCase().endsWith('.jpg') ||
            optionText.toLowerCase().endsWith('.png') ||
            optionText.toLowerCase().endsWith('.jpeg');

        // Show validation IMMEDIATELY if answered (or if submitted, though answered covers it)
        if (isAnswered || isSubmitted) {
          if (optIndex == subQuestion.correctOptionIndex) {
            borderColor = const Color(0xFF0B5444);
            cardColor = const Color(0xFF0B5444).withValues(alpha: 0.12);
          } else if (isSelected && optIndex != subQuestion.correctOptionIndex) {
            borderColor = Colors.red;
            cardColor = Colors.red.withValues(alpha: 0.12);
          }
        } else if (isSelected) {
          borderColor = AppTheme.mondeluxPrimary;
          cardColor = AppTheme.mondeluxPrimary;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            // Disable selection if already answered OR submitted
            onTap: (isAnswered || isSubmitted)
                ? null
                : () => onOptionSelected(optIndex),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                color: cardColor ?? Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: borderColor ?? AppTheme.textDisabled,
                  width: borderColor != null ? 2.5 : 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.mondeluxPrimary.withValues(
                            alpha: 0.15,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: (isAnswered || isSubmitted)
                            ? (optIndex == subQuestion.correctOptionIndex
                                  ? const Color(0xFF2F7D68)
                                  : (isSelected
                                        ? const Color(0xFFE57373)
                                        : AppTheme.textDisabled))
                            : (isSelected
                                  ? AppTheme.mondeluxPrimary
                                  : AppTheme.textDisabled),
                        width: 2.5,
                      ),
                      color: (isAnswered || isSubmitted)
                          ? (optIndex == subQuestion.correctOptionIndex
                                ? const Color(0xFF0B5444)
                                : (isSelected
                                      ? Colors.red
                                      : Colors.transparent))
                          : (isSelected
                                ? AppTheme.mondeluxPrimary
                                : Colors.transparent),
                    ),
                    child: (isAnswered || isSubmitted)
                        ? (optIndex == subQuestion.correctOptionIndex)
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white, // White on Green
                                )
                              : (isSelected
                                    ? const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white, // White on Red
                                      )
                                    : null)
                        : (isSelected
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: isImageOption
                        ? FirebaseImageWidget(pathOrUrl: optionText)
                        : Text(
                            optionText,
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 16,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _WrittenAnswerInput extends StatefulWidget {
  final bool isSubmitted;
  final bool isChecked;
  final String? initialValue;
  final String? correctAnswer;
  final ValueChanged<String> onChanged;
  final VoidCallback onCheckPressed;

  const _WrittenAnswerInput({
    required this.isSubmitted,
    required this.isChecked,
    required this.initialValue,
    required this.correctAnswer,
    required this.onChanged,
    required this.onCheckPressed,
  });

  @override
  State<_WrittenAnswerInput> createState() => _WrittenAnswerInputState();
}

class _WrittenAnswerInputState extends State<_WrittenAnswerInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant _WrittenAnswerInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != _controller.text && !widget.isChecked) {
      // Only update from parent if not locally edited newly
      // For simplicity, we trust the controller unless forced.
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isCorrect = false;
    if (widget.isChecked && widget.correctAnswer != null) {
      isCorrect =
          _controller.text.trim().toLowerCase() ==
          widget.correctAnswer!.trim().toLowerCase();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.isChecked
                        ? (isCorrect ? const Color(0xFF0B5444) : Colors.red)
                        : AppTheme.textDisabled,
                    width: widget.isChecked ? 2.5 : 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  enabled: !widget.isSubmitted && !widget.isChecked,
                  style: TextStyle(color: AppTheme.textPrimary, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Type your answer here...',
                    hintStyle: TextStyle(
                      color: AppTheme.textSecondary.withValues(alpha: 0.6),
                    ),
                    border: InputBorder.none,
                    filled: false, // Ensure theme-level filling is off
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  onChanged: widget.onChanged,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Check button
            if (!widget.isChecked && !widget.isSubmitted)
              Padding(
                padding: const EdgeInsets.only(top: 8), // slightly align
                child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.mondeluxPrimary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _controller.text.trim().isNotEmpty
                      ? widget.onCheckPressed
                      : null,
                  icon: const Icon(Icons.check),
                ),
              ),
          ],
        ),

        // Validation Message
        if (widget.isChecked && !isCorrect && widget.correctAnswer != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Text(
              AppLocalizations.of(
                context,
              )!.correctAnswer(widget.correctAnswer!),
              style: GoogleFonts.outfit(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        if (widget.isChecked && isCorrect)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Text(
              AppLocalizations.of(context)!.correct,
              style: GoogleFonts.outfit(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
      ],
    );
  }
}

class _AudioPlayerWidget extends StatefulWidget {
  final String url;
  const _AudioPlayerWidget({required this.url});
  @override
  State<_AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<_AudioPlayerWidget> {
  late AudioPlayer player;
  bool isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();

    // Set up listeners
    player.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });

    player.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          _duration = newDuration;
        });
      }
    });

    player.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          _position = newPosition;
        });
      }
    });

    player.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          isPlaying = false;
          _position = Duration.zero;
        });
      }
    });

    // Preload source
    player.setSource(UrlSource(widget.url));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Audio Icon and Slider
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  size: 36,
                ),
                color: AppTheme.mondeluxPrimary,
                onPressed: () async {
                  if (isPlaying) {
                    await player.pause();
                  } else {
                    await player.play(UrlSource(widget.url));
                  }
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppTheme.mondeluxPrimary,
                    inactiveTrackColor: AppTheme.textDisabled.withValues(
                      alpha: 0.3,
                    ),
                    thumbColor: AppTheme.mondeluxPrimary,
                    overlayColor: AppTheme.mondeluxPrimary.withValues(
                      alpha: 0.1,
                    ),
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                    trackHeight: 3,
                  ),
                  child: Slider(
                    min: 0,
                    max: _duration.inSeconds.toDouble(),
                    value: _position.inSeconds.toDouble().clamp(
                      0,
                      _duration.inSeconds.toDouble(),
                    ),
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await player.seek(position);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_position),
                  style: GoogleFonts.outfit(
                    color: AppTheme.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formatDuration(_duration),
                  style: GoogleFonts.outfit(
                    color: AppTheme.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FirebaseImageWidget extends StatefulWidget {
  final String pathOrUrl;
  final BoxFit fit;

  const FirebaseImageWidget({
    super.key,
    required this.pathOrUrl,
    this.fit = BoxFit.contain,
  });

  @override
  State<FirebaseImageWidget> createState() => _FirebaseImageWidgetState();
}

final Map<String, String> _mediaCache = {};

class _FirebaseImageWidgetState extends State<FirebaseImageWidget> {
  late Future<String> _downloadUrlFuture;

  @override
  void initState() {
    super.initState();
    _downloadUrlFuture = _resolveUrl();
  }

  Future<String> _resolveUrl() async {
    final path = widget.pathOrUrl;
    if (path.startsWith('http')) {
      return path;
    }

    if (_mediaCache.containsKey(path)) return _mediaCache[path]!;

    try {
      String bucketPath;
      final lower = path.toLowerCase();
      if (lower.contains('png') ||
          lower.contains('jpg') ||
          lower.contains('jpeg') ||
          lower.contains('webp')) {
        bucketPath = 'foto_questions/$path';
      } else {
        bucketPath = path;
      }

      final url = await FirebaseStorage.instance
          .ref(bucketPath)
          .getDownloadURL();
      _mediaCache[path] = url;
      return url;
    } catch (e) {
      try {
        final url = await FirebaseStorage.instance.ref(path).getDownloadURL();
        _mediaCache[path] = url;
        return url;
      } catch (e2) {
        debugPrint("Image not found: $path");
        rethrow;
      }
    }
  }

  @override
  void didUpdateWidget(covariant FirebaseImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pathOrUrl != oldWidget.pathOrUrl) {
      _downloadUrlFuture = _resolveUrl();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _downloadUrlFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppTheme.mondeluxPrimary,
              ),
            ),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Icon(Icons.broken_image, color: Colors.red),
                const SizedBox(height: 8),
                Text(
                  "Image not found: ${widget.pathOrUrl}",
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: snapshot.data!,
            fit: widget.fit,
            width: double.infinity, // allow full width
            // removed fixed height
            placeholder: (context, url) => const SizedBox(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppTheme.mondeluxPrimary,
                ),
              ),
            ),
            errorWidget: (_, __, ___) =>
                const Center(child: Icon(Icons.error, color: Colors.white)),
          ),
        );
      },
    );
  }
}

class FirebaseAudioWidget extends StatefulWidget {
  final String pathOrUrl;
  const FirebaseAudioWidget({super.key, required this.pathOrUrl});

  @override
  State<FirebaseAudioWidget> createState() => _FirebaseAudioWidgetState();
}

class _FirebaseAudioWidgetState extends State<FirebaseAudioWidget> {
  Future<String>? _resolvedUrlFuture;

  @override
  void initState() {
    super.initState();
    _resolvedUrlFuture = _resolveUrl();
  }

  Future<String> _resolveUrl() async {
    final path = widget.pathOrUrl;
    if (path.startsWith('http')) {
      return path;
    }

    // Check local static cache
    if (_mediaCache.containsKey(path)) return _mediaCache[path]!;

    try {
      String bucketPath;
      final lower = path.toLowerCase();
      if (lower.contains('mp3') ||
          lower.contains('wav') ||
          lower.contains('m4a')) {
        bucketPath = 'audio_questions/$path';
      } else if (lower.contains('png') ||
          lower.contains('jpg') ||
          lower.contains('jpeg') ||
          lower.contains('webp')) {
        bucketPath = 'foto_questions/$path';
      } else {
        bucketPath = path; // Root
      }

      final url = await FirebaseStorage.instance
          .ref(bucketPath)
          .getDownloadURL();
      _mediaCache[path] = url;
      return url;
    } catch (e) {
      // Fallback to searching root if folder attempt failed
      try {
        final url = await FirebaseStorage.instance.ref(path).getDownloadURL();
        _mediaCache[path] = url;
        return url;
      } catch (e2) {
        debugPrint("Could not find $path in storage");
        rethrow;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _resolvedUrlFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 60,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Audio not found: ${widget.pathOrUrl}",
              style: const TextStyle(color: Colors.red, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          );
        }
        return _AudioPlayerWidget(url: snapshot.data!);
      },
    );
  }
}
