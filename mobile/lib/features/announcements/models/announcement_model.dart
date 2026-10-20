class AnnouncementModel {
  final int id;
  final int userId;
  final int? teacherId;
  final String teacherName;
  final String content;
  final String? imagePath;
  final int likesCount;
  final int commentsCount;
  final int viewsCount;
  final bool isLiked;
  final bool isViewed;
  final DateTime createdAt;
  final String? teacherAvatarUrl;

  AnnouncementModel({
    required this.id,
    this.userId = 0,
    this.teacherId,
    required this.teacherName,
    required this.content,
    this.imagePath,
    required this.likesCount,
    required this.commentsCount,
    this.viewsCount = 0,
    required this.isLiked,
    this.isViewed = false,
    required this.createdAt,
    this.teacherAvatarUrl,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    final author = json['author'];
    String? avatarUrl;
    int? teacherProfileId;
    int authorUserId = json['user_id'] ?? 0;

    if (author != null) {
      authorUserId = author['id'] ?? authorUserId;
      teacherProfileId = author['teacher_profile']?['id'];
      avatarUrl = author['avatar_path'] ??
          author['avatar_url'] ??
          author['teacher_profile']?['avatar_path'] ??
          author['student_profile']?['avatar_path'];
    }

    return AnnouncementModel(
      id: json['id'] ?? 0,
      userId: authorUserId,
      teacherId: teacherProfileId,
      teacherName: author != null ? author['name'] ?? 'Teacher' : 'Teacher',
      content: json['content'] ?? '',
      imagePath: json['image_path'],
      likesCount: json['likes_count'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
      viewsCount: json['views_count'] ?? 0,
      isLiked: json['is_liked'] ?? false,
      isViewed: json['is_viewed'] ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      teacherAvatarUrl: avatarUrl,
    );
  }
}
