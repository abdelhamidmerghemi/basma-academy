import 'quiz_answer_model.dart';

class QuizQuestionModel {
  final int id;
  final int quizId;
  final String questionText;
  final int points;
  final int sortOrder;
  final List<QuizAnswerModel> answers;

  QuizQuestionModel({
    required this.id,
    required this.quizId,
    required this.questionText,
    required this.points,
    required this.sortOrder,
    required this.answers,
  });

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    return QuizQuestionModel(
      id: json['id'],
      quizId: json['quiz_id'] ?? 0,
      questionText: json['question_text'] ?? '',
      points: json['points'] ?? 1,
      sortOrder: json['sort_order'] ?? 1,
      answers: json['answers'] != null
          ? (json['answers'] as List)
              .map((a) => QuizAnswerModel.fromJson(a))
              .toList()
          : [],
    );
  }
}
