import 'quiz_question_model.dart';

class QuizModel {
  final int id;
  final int? lessonId;
  final int? subjectId;
  final String title;
  final int timeLimitMinutes;
  final int questionsCount;
  final List<QuizQuestionModel> questions;

  QuizModel({
    required this.id,
    this.lessonId,
    this.subjectId,
    required this.title,
    required this.timeLimitMinutes,
    required this.questionsCount,
    required this.questions,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'],
      lessonId: json['lesson_id'],
      subjectId: json['subject_id'],
      title: json['title'] ?? '',
      timeLimitMinutes: json['time_limit_minutes'] ?? 0,
      questionsCount: json['questions_count'] ?? (json['questions'] as List?)?.length ?? 0,
      questions: json['questions'] != null
          ? (json['questions'] as List)
              .map((q) => QuizQuestionModel.fromJson(q))
              .toList()
          : [],
    );
  }
}
