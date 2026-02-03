import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../courses/data/course_model.dart';

class QuestionRepository {
  final FirebaseFirestore _firestore;

  QuestionRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Question>> fetchQuestionsByCategory(String category) async {
    try {
      final querySnapshot = await _firestore
          .collection('questions')
          .where('category', isEqualTo: category)
          .get();

      return querySnapshot.docs
          .map((doc) => Question.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error fetching questions: $e');
      return [];
    }
  }

  Future<List<Question>> fetchAllQuestions() async {
    try {
      final querySnapshot = await _firestore.collection('questions').get();
      return querySnapshot.docs
          .map((doc) => Question.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error fetching all questions: $e');
      return [];
    }
  }
}
