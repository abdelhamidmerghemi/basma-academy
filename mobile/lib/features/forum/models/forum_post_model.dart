import 'forum_reply_model.dart';

class ForumPostModel {
  final int id;
  final String type; // 'question', 'discussion', 'resource'
  final String title;
  final String content;
  final String? imagePath;
  final bool isSolved;
  final int viewsCount;
  final int likesCount;
  final int repliesCount;
  final bool isLiked;
  final bool isViewed;
  final int userId;
  final String userName;
  final String userAvatar;
  final int? subjectId;
  final String? subjectNameAr;
  final String? subjectNameFr;
  final String? subjectNameEn;
  final ForumReplyModel? bestReply;
  final List<ForumReplyModel> replies;
  final DateTime createdAt;

  ForumPostModel({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    this.imagePath,
    required this.isSolved,
    required this.viewsCount,
    required this.likesCount,
    required this.repliesCount,
    required this.isLiked,
    this.isViewed = false,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    this.subjectId,
    this.subjectNameAr,
    this.subjectNameFr,
    this.subjectNameEn,
    this.bestReply,
    this.replies = const [],
    required this.createdAt,
  });

  factory ForumPostModel.fromJson(Map<String, dynamic> json) {
    List<ForumReplyModel> repliesList = [];
    if (json['replies'] != null && json['replies'] is List) {
      repliesList = (json['replies'] as List)
          .map((r) => ForumReplyModel.fromJson(r))
          .toList();
    }

    return ForumPostModel(
      id: (json['id'] as int?) ?? 0,
      type: json['type'] as String? ?? 'question',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      imagePath: json['image_path'] as String?,
      isSolved: json['is_solved'] ?? false,
      viewsCount: (json['views_count'] as int?) ?? 0,
      likesCount: (json['likes_count'] as int?) ?? 0,
      repliesCount: (json['replies_count'] as int?) ?? 0,
      isLiked: json['is_liked'] ?? false,
      isViewed: json['is_viewed'] ?? false,
      userId: (json['user_id'] as int?) ?? 0,
      userName: json['user_name'] as String? ?? 'طالب',
      userAvatar: json['user_avatar'] as String? ?? 'assets/images/placeholder_avatar.png',
      subjectId: json['subject_id'] as int?,
      subjectNameAr: json['subject_name_ar'] as String?,
      subjectNameFr: json['subject_name_fr'] as String?,
      subjectNameEn: json['subject_name_en'] as String?,
      bestReply: json['best_reply'] != null
          ? ForumReplyModel.fromJson(json['best_reply'])
          : null,
      replies: repliesList,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  ForumPostModel copyWith({
    bool? isLiked,
    bool? isViewed,
    int? viewsCount,
    int? likesCount,
    int? repliesCount,
    bool? isSolved,
    List<ForumReplyModel>? replies,
  }) {
    return ForumPostModel(
      id: id,
      type: type,
      title: title,
      content: content,
      imagePath: imagePath,
      isSolved: isSolved ?? this.isSolved,
      viewsCount: viewsCount ?? this.viewsCount,
      likesCount: likesCount ?? this.likesCount,
      repliesCount: repliesCount ?? this.repliesCount,
      isLiked: isLiked ?? this.isLiked,
      isViewed: isViewed ?? this.isViewed,
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      subjectId: subjectId,
      subjectNameAr: subjectNameAr,
      subjectNameFr: subjectNameFr,
      subjectNameEn: subjectNameEn,
      bestReply: bestReply,
      replies: replies ?? this.replies,
      createdAt: createdAt,
    );
  }
}
