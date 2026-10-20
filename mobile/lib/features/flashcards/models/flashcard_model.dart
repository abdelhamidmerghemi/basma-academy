class FlashcardModel {
  final int id;
  final int deckId;
  final String questionText;
  final String answerText;
  final String? explanationText;

  FlashcardModel({
    required this.id,
    required this.deckId,
    required this.questionText,
    required this.answerText,
    this.explanationText,
  });

  factory FlashcardModel.fromJson(Map<String, dynamic> json) {
    return FlashcardModel(
      id: json['id'] as int,
      deckId: json['deck_id'] as int? ?? 1,
      questionText: json['question_text'] as String? ?? '',
      answerText: json['answer_text'] as String? ?? '',
      explanationText: json['explanation_text'] as String?,
    );
  }
}
