class ReviewModel {
  final int id;
  final double rating;
  final String comment;
  final String userName;
  final String? userAvatar;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.rating,
    required this.comment,
    required this.userName,
    this.userAvatar,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? 0,
      rating: double.tryParse(json['rating']?.toString() ?? '5.0') ?? 5.0,
      comment: json['comment'] ?? '',
      userName: json['user'] != null ? json['user']['name'] ?? 'Student' : 'Student',
      userAvatar: json['user'] != null ? json['user']['avatar_url'] : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}
