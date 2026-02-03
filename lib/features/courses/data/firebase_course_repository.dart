import 'package:cloud_firestore/cloud_firestore.dart';
import 'course_model.dart';

class FirebaseCourseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Course>> getCourses() async {
    final snapshot = await _firestore.collection('questions').get();

    final questions = snapshot.docs
        .map((d) => Question.fromFirestore(d.data()))
        .toList();

    final Map<String, Map<String, List<Question>>> grouped = {};

    for (final q in questions) {
      grouped.putIfAbsent(q.category, () => {});
      grouped[q.category]!.putIfAbsent(q.ticketId, () => []);
      grouped[q.category]![q.ticketId]!.add(q);
    }

    final List<Course> courses = [];

    grouped.forEach((category, ticketsMap) {
      final tickets = ticketsMap.entries.map((e) {
        final sortedQuestions = List<Question>.from(e.value);
        sortedQuestions.sort((a, b) => a.order.compareTo(b.order));
        return Ticket(
          id: e.key,
          title: 'Bilet ${e.key.split("_").last}',
          questions: sortedQuestions,
        );
      }).toList();

      // Numeric Sort: "ticket_1", "ticket_10"
      tickets.sort((a, b) {
        // Assume format "prefix_NUMBER" or just check numbers in string
        final int? numA = _extractNumber(a.id);
        final int? numB = _extractNumber(b.id);
        if (numA != null && numB != null) {
          return numA.compareTo(numB);
        }
        return a.id.compareTo(b.id);
      });

      courses.add(Course(id: category, title: category, tickets: tickets));
    });

    return courses;
  }

  int? _extractNumber(String text) {
    // Looks for the last sequence of digits in the string
    final match = RegExp(r'(\d+)').allMatches(text).lastOrNull;
    if (match != null) {
      return int.tryParse(match.group(0)!);
    }
    return null;
  }
}
