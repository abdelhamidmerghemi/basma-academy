class QuizAnswerModel {
  final int id;
  final int questionId;
  final String answerText;

  QuizAnswerModel({
    required this.id,
    required this.questionId,
    required this.answerText,
  });

  factory QuizAnswerModel.fromJson(Map<String, dynamic> json) {
    return QuizAnswerModel(
      id: json['id'],
      questionId: json['question_id'] ?? 0,
      answerText: json['answer_text'] ?? '',
    );
  }
}
