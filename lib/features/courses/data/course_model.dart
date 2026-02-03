enum QuestionType { text, image, audio, audioDouble }

enum AnswerType { singleChoice, multipleChoice, written }

class SubQuestion {
  final String text;
  final List<String> options;
  final int correctOptionIndex;
  final String? correctTextAnswer; // For written answers

  SubQuestion({
    required this.text,
    required this.options,
    required this.correctOptionIndex,
    this.correctTextAnswer,
  });

  factory SubQuestion.fromMap(Map<String, dynamic> map) {
    // Robustly handle options list
    List<String> parsedOptions = [];
    if (map['options'] != null) {
      if (map['options'] is List) {
        parsedOptions = (map['options'] as List)
            .map((e) => e.toString())
            .toList();
      }
    }

    return SubQuestion(
      text: map['text']?.toString() ?? '',
      options: parsedOptions,
      correctOptionIndex: (map['correct'] is int) ? map['correct'] : 0,
      correctTextAnswer: map['correctTextAnswer']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'options': options,
      'correct': correctOptionIndex,
      'correctTextAnswer': correctTextAnswer,
    };
  }
}

class Question {
  final String id;
  final String ticketId;
  final String category; // 'Patent', 'Russian' etc.
  final QuestionType type;
  final AnswerType answerType;
  final int order;

  final String? descriptionText; // "Listen to the dialogue..." or "Read..."
  final String? mediaUrl; // audio file or image url

  // Unified list of sub-questions.
  // For 'text'/'image' types, this list will contain exactly 1 element.
  // For 'audioDouble', it will contain 2+ elements.
  final List<SubQuestion> subQuestions;

  Question({
    required this.id,
    required this.ticketId,
    required this.category,
    required this.type,
    required this.answerType,
    required this.order,
    this.descriptionText,
    this.mediaUrl,
    required this.subQuestions,
  });

  factory Question.fromFirestore(Map<String, dynamic> map) {
    return Question(
      id: map['id']?.toString() ?? '',
      ticketId: map['ticketId']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      type: QuestionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => QuestionType.text,
      ),
      answerType: AnswerType.values.firstWhere(
        (e) => e.name == map['answerType'],
        orElse: () => AnswerType.singleChoice,
      ),
      order: (map['order'] is int) ? map['order'] : 0,
      descriptionText: map['descriptionText']?.toString(),
      mediaUrl: map['mediaUrl']?.toString(),
      subQuestions:
          (map['subQuestions'] as List<dynamic>?)
              ?.map((e) => SubQuestion.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ticketId': ticketId,
      'category': category,
      'type': type.name,
      'answerType': answerType.name,
      'order': order,
      'descriptionText': descriptionText,
      'mediaUrl': mediaUrl,
      'subQuestions': subQuestions.map((e) => e.toMap()).toList(),
    };
  }
}

class Ticket {
  final String id;
  final String title;
  final List<Question> questions;

  Ticket({required this.id, required this.title, required this.questions});
}

class Course {
  final String id;
  final String title;
  final List<Ticket> tickets;

  Course({required this.id, required this.title, required this.tickets});
}
