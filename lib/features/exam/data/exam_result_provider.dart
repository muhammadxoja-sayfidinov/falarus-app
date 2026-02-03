import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'exam_result_model.dart';

final examResultsProvider = StreamProvider<List<ExamResult>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('exam_results')
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
            .map((doc) => ExamResult.fromMap(doc.data()))
            .toList();
      });
});
