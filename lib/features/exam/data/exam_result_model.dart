import 'package:cloud_firestore/cloud_firestore.dart';

enum ExamStatus { locked, open, inProgress, failed, passed }

class ExamResult {
  final String ticketId;
  final String courseId;
  final int correctAnswers;
  final int totalQuestions;
  final ExamStatus status;
  final DateTime timestamp;

  ExamResult({
    required this.ticketId,
    required this.courseId,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.status,
    required this.timestamp,
  });

  factory ExamResult.fromMap(Map<String, dynamic> map) {
    return ExamResult(
      ticketId: map['ticketId'] ?? '',
      courseId: map['courseId'] ?? '',
      correctAnswers: map['correctAnswers'] ?? 0,
      totalQuestions: map['totalQuestions'] ?? 0,
      status: ExamStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => ExamStatus.open,
      ),
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ticketId': ticketId,
      'courseId': courseId,
      'correctAnswers': correctAnswers,
      'totalQuestions': totalQuestions,
      'status': status.name,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
