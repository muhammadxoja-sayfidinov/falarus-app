import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../features/courses/data/course_model.dart';
// If uuid is needed: import 'package:uuid/uuid.dart';

class FirebaseImporter {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Accepts an asset path, loads it, parses it, and uploads to Firestore
  // Default path set to assets/test.csv for convenience during dev
  Future<void> uploadCsvToFirestore({
    String assetPath = 'assets/test.csv',
  }) async {
    debugPrint('🚀 CSV import started from: $assetPath');

    try {
      final csvString = await rootBundle.loadString(assetPath);

      // Disable number parsing to keep IDs as strings (e.g. "001" stays "001")
      List<List<dynamic>> rows = const CsvToListConverter(
        eol: '\n',
        fieldDelimiter: ',',
        shouldParseNumbers: false,
      ).convert(csvString);

      // Skip header if empty or just headers
      if (rows.isEmpty) return;

      // Check if first row is header. Usually yes. We skip it.
      final dataRows = rows.skip(1);

      WriteBatch batch = _firestore.batch();
      int batchCount = 0;
      int totalCount = 0;
      int errorCount = 0;

      for (var i = 0; i < dataRows.length; i++) {
        final row = dataRows.elementAt(i);
        final rowIndex = i + 2; // Correct for 1-based index including header

        if (row.length < 2) continue;

        try {
          // Columns Mapping:
          // ... (same as before)

          String id = row[0].toString().trim();
          String typeStr = row[1].toString().trim();
          String answerTypeStr = row[2].toString().trim();
          String category = row[3].toString().trim();

          String? descriptionText =
              (row.length > 4 &&
                  row[4].toString() != 'null' &&
                  row[4].toString().trim().isNotEmpty)
              ? row[4].toString()
              : null;

          String? mediaFilename =
              (row.length > 5 &&
                  row[5].toString() != 'null' &&
                  row[5].toString().trim().isNotEmpty)
              ? row[5].toString()
              : null;

          String? questionsJsonStr =
              (row.length > 6 && row[6].toString() != 'null')
              ? row[6]?.toString()
              : null;

          String? subQuestionsJsonStr =
              (row.length > 7 && row[7].toString() != 'null')
              ? row[7]?.toString()
              : null;

          String? correctTextAnswerRaw =
              (row.length > 8 && row[8].toString() != 'null')
              ? row[8]?.toString()
              : null;

          QuestionType type = QuestionType.values.firstWhere(
            (e) => e.name == typeStr,
            orElse: () => QuestionType.text,
          );

          AnswerType answerType = AnswerType.values.firstWhere(
            (e) => e.name == answerTypeStr,
            orElse: () => AnswerType.singleChoice,
          );

          // Resolve Media URL from Firebase Storage if filename exists
          String? mediaUrl;
          if (mediaFilename != null) {
            try {
              String bucketPath;
              if (type == QuestionType.image) {
                bucketPath = 'foto_questions/$mediaFilename';
              } else if (type == QuestionType.audio ||
                  type == QuestionType.audioDouble) {
                bucketPath = 'audio_questions/$mediaFilename';
              } else {
                bucketPath = 'other/$mediaFilename'; // Fallback
              }

              debugPrint('🔍 resolving URL for: $bucketPath');
              mediaUrl = await FirebaseStorage.instance
                  .ref(bucketPath)
                  .getDownloadURL();
              debugPrint('✅ Resolved: $mediaUrl');
            } catch (e) {
              debugPrint('⚠️ Could not resolve URL for $mediaFilename: $e');
              // Fallback: keep filename or set to null?
              // Let's keep the filename so we know what was intended,
              // but the UI checks for full URL usually.
              // Maybe valid for caching if we implemented that.
              mediaUrl = mediaFilename;
            }
          }

          // ID & Order Logic
          List<String> idParts = id.split('_');
          String ticketId = idParts.length >= 2
              ? "${idParts[0]}_${idParts[1]}"
              : id;

          int order = 0;
          if (idParts.isNotEmpty) {
            String lastPart = idParts.last;
            if (type == QuestionType.audioDouble) {
              if (lastPart == '12')
                order = 1;
              else if (lastPart == '34')
                order = 3;
              else
                order = int.tryParse(lastPart) ?? 0;
              id = "${id}_audio";
            } else {
              order = int.tryParse(lastPart) ?? 0;
            }
          }

          List<SubQuestion> subQuestions = [];

          if (subQuestionsJsonStr != null &&
              subQuestionsJsonStr.trim().isNotEmpty) {
            final parsed = _safeJsonDecode(
              subQuestionsJsonStr,
              "Row $rowIndex col 7 (subQuestionsJson)",
            );
            if (parsed != null) {
              if (parsed is List) {
                subQuestions = parsed
                    .map((e) => SubQuestion.fromMap(e as Map<String, dynamic>))
                    .toList();
              } else if (parsed is Map) {
                subQuestions = [
                  SubQuestion.fromMap(parsed as Map<String, dynamic>),
                ];
              }
            }
          }

          if (subQuestions.isEmpty &&
              questionsJsonStr != null &&
              questionsJsonStr.trim().isNotEmpty) {
            final parsed = _safeJsonDecode(
              questionsJsonStr,
              "Row $rowIndex col 6 (questionsJson)",
            );
            if (parsed != null) {
              if (parsed is List) {
                subQuestions = parsed
                    .map((e) => SubQuestion.fromMap(e as Map<String, dynamic>))
                    .toList();
              } else if (parsed is Map) {
                subQuestions = [
                  SubQuestion.fromMap(parsed as Map<String, dynamic>),
                ];
              }
            }
          }

          if (subQuestions.length == 1 && correctTextAnswerRaw != null) {
            final old = subQuestions[0];
            subQuestions[0] = SubQuestion(
              text: old.text,
              options: old.options,
              correctOptionIndex: old.correctOptionIndex,
              correctTextAnswer: correctTextAnswerRaw,
            );
          }

          if (subQuestions.isEmpty && correctTextAnswerRaw != null) {
            subQuestions = [
              SubQuestion(
                text: descriptionText ?? '',
                options: [],
                correctOptionIndex: 0,
                correctTextAnswer: correctTextAnswerRaw,
              ),
            ];
          }

          if (subQuestions.isEmpty) {
            debugPrint(
              "⚠️ Warning: No subquestions found for ID: $id at Row $rowIndex. Skipping.",
            );
            errorCount++;
            continue;
          }

          Question question = Question(
            id: id,
            ticketId: ticketId,
            category: category,
            type: type,
            answerType: answerType,
            order: order,
            descriptionText: descriptionText,
            mediaUrl: mediaUrl,
            subQuestions: subQuestions,
          );

          DocumentReference docRef = _firestore.collection('questions').doc(id);
          batch.set(docRef, question.toMap());
          batchCount++;
          totalCount++;

          if (batchCount >= 400) {
            await batch.commit();
            batch = _firestore.batch();
            batchCount = 0;
            debugPrint('Saved batch of 400...');
          }
        } catch (e) {
          debugPrint('❌ Error processing row $rowIndex (${row[0]}): $e');
          errorCount++;
        }
      }

      if (batchCount > 0) {
        await batch.commit();
      }

      debugPrint(
        "✅ CSV import completed! Valid: $totalCount, Errors: $errorCount",
      );
    } catch (e, stack) {
      debugPrint("❌ Fatal Error loading/parsing CSV: $e");
      debugPrint(stack.toString());
    }
  }

  /// Safely decodes JSON and logs specific error if it fails
  dynamic _safeJsonDecode(String jsonStr, String contextInfo) {
    try {
      // Normalize: Sometimes CSV export might escape double quotes like "" -> "
      // The CsvToListConverter usually handles standard CSV escaping,
      // but if the string was manually messed up we might need to be careful.
      // For now, we assume CsvToListConverter did its job for the outer CSV layer.
      return jsonDecode(jsonStr);
    } catch (e) {
      debugPrint("🚨 JSON Parse Error [$contextInfo]: $e");
      debugPrint("   Questionable Content: $jsonStr");
      return null;
    }
  }
}
