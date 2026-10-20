class CommentModel {
  final int id;
  final String userName;
  final String content;
  final DateTime createdAt;
  final String? userAvatarUrl;

  CommentModel({
    required this.id,
    required this.userName,
    required this.content,
    required this.createdAt,
    this.userAvatarUrl,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? 0,
      userName: json['user'] != null ? json['user']['name'] ?? 'Student' : 'Student',
      content: json['content'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      userAvatarUrl: json['user'] != null ? json['user']['avatar_url'] : null,
    );
  }
}
