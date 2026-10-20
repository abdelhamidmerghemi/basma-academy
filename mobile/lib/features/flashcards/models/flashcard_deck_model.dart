import 'flashcard_model.dart';

class FlashcardDeckModel {
  final int id;
  final int subjectId;
  final String title;
  final String? description;
  final List<FlashcardModel> cards;

  FlashcardDeckModel({
    required this.id,
    required this.subjectId,
    required this.title,
    this.description,
    required this.cards,
  });

  factory FlashcardDeckModel.fromJson(Map<String, dynamic> json) {
    var rawCards = json['cards'] as List? ?? [];
    List<FlashcardModel> parsedCards = rawCards
        .map((c) => FlashcardModel.fromJson(c as Map<String, dynamic>))
        .toList();

    return FlashcardDeckModel(
      id: json['id'] as int,
      subjectId: json['subject_id'] as int? ?? 1,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      cards: parsedCards,
    );
  }
}
