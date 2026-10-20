class QuestionBreakdownModel {
  final int questionId;
  final String questionText;
  final int? selectedAnswerId;
  final int? correctAnswerId;
  final bool isCorrect;
  final String? explanation;

  QuestionBreakdownModel({
    required this.questionId,
    required this.questionText,
    this.selectedAnswerId,
    this.correctAnswerId,
    required this.isCorrect,
    this.explanation,
  });

  factory QuestionBreakdownModel.fromJson(Map<String, dynamic> json) {
    return QuestionBreakdownModel(
      questionId: json['question_id'],
      questionText: json['question_text'] ?? '',
      selectedAnswerId: json['selected_answer_id'],
      correctAnswerId: json['correct_answer_id'],
      isCorrect: json['is_correct'] ?? false,
      explanation: json['explanation'],
    );
  }
}

class QuizResultModel {
  final int attemptId;
  final int score;
  final int correctCount;
  final int totalQuestions;
  final int earnedPoints;
  final int totalPoints;
  final bool passed;
  final List<QuestionBreakdownModel> breakdown;

  QuizResultModel({
    required this.attemptId,
    required this.score,
    required this.correctCount,
    required this.totalQuestions,
    required this.earnedPoints,
    required this.totalPoints,
    required this.passed,
    required this.breakdown,
  });

  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    return QuizResultModel(
      attemptId: json['attempt_id'] ?? 0,
      score: json['score'] ?? 0,
      correctCount: json['correct_count'] ?? 0,
      totalQuestions: json['total_questions'] ?? 0,
      earnedPoints: json['earned_points'] ?? 0,
      totalPoints: json['total_points'] ?? 0,
      passed: json['passed'] ?? false,
      breakdown: json['breakdown'] != null
          ? (json['breakdown'] as List)
              .map((b) => QuestionBreakdownModel.fromJson(b))
              .toList()
          : [],
    );
  }
}
