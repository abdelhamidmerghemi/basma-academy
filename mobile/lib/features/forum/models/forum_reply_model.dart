class ForumReplyModel {
  final int id;
  final int userId;
  final String userName;
  final String userAvatar;
  final String content;
  final String? imagePath;
  final bool isBestAnswer;
  final int likesCount;
  final bool isLiked;
  final DateTime createdAt;

  ForumReplyModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    this.imagePath,
    required this.isBestAnswer,
    required this.likesCount,
    required this.isLiked,
    required this.createdAt,
  });

  factory ForumReplyModel.fromJson(Map<String, dynamic> json) {
    return ForumReplyModel(
      id: (json['id'] as int?) ?? 0,
      userId: (json['user_id'] as int?) ?? 0,
      userName: json['user_name'] as String? ?? 'طالب',
      userAvatar: json['user_avatar'] as String? ?? 'assets/images/placeholder_avatar.png',
      content: json['content'] as String? ?? '',
      imagePath: json['image_path'] as String?,
      isBestAnswer: json['is_best_answer'] ?? false,
      likesCount: (json['likes_count'] as int?) ?? 0,
      isLiked: json['is_liked'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  ForumReplyModel copyWith({
    bool? isLiked,
    int? likesCount,
    bool? isBestAnswer,
  }) {
    return ForumReplyModel(
      id: id,
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      content: content,
      imagePath: imagePath,
      isBestAnswer: isBestAnswer ?? this.isBestAnswer,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt,
    );
  }
}
