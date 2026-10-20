import 'subject_model.dart';
import 'lesson_model.dart';
import 'review_model.dart';

class CourseModel {
  final int id;
  final String title;
  final String teacherName;
  final String? teacherAvatarUrl;
  final double priceDzd;
  final String academicStream;
  final int? subjectId;
  final String? thumbnailPath;
  final String? description;
  final double averageRating;
  final int reviewsCount;
  final bool isUnlocked;
  final SubjectModel? subject;
  final List<LessonModel>? lessons;
  final List<ReviewModel>? reviews;

  CourseModel({
    required this.id,
    required this.title,
    required this.teacherName,
    this.teacherAvatarUrl,
    required this.priceDzd,
    required this.academicStream,
    this.subjectId,
    this.thumbnailPath,
    this.description,
    required this.averageRating,
    required this.reviewsCount,
    required this.isUnlocked,
    this.subject,
    this.lessons,
    this.reviews,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    final teacherName = (json['teacher_name'] as String?)
        ?? (json['teacher_profile']?['user']?['name'] as String?)
        ?? (json['teacher']?['name'] as String?)
        ?? 'أستاذ المحتوى';

    final teacherAvatarUrl = (json['teacher_avatar'] as String?)
        ?? (json['teacher_profile']?['avatar_path'] as String?);

    return CourseModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      teacherName: teacherName,
      teacherAvatarUrl: teacherAvatarUrl,
      priceDzd: double.tryParse(json['price_dzd']?.toString() ?? '0') ?? 0.0,
      academicStream: json['academic_stream'] ?? '',
      subjectId: json['subject_id'],
      thumbnailPath: json['thumbnail_path'],
      description: json['description'],
      averageRating: double.tryParse(json['average_rating']?.toString() ?? '5.0') ?? 5.0,
      reviewsCount: json['reviews_count'] ?? 0,
      isUnlocked: json['is_unlocked'] ?? false,
      subject: json['subject'] != null ? SubjectModel.fromJson(json['subject']) : null,
      lessons: json['lessons'] != null
          ? (json['lessons'] as List).map((e) => LessonModel.fromJson(e)).toList()
          : null,
      reviews: json['reviews'] != null
          ? (json['reviews'] as List).map((e) => ReviewModel.fromJson(e)).toList()
          : null,
    );
  }

  CourseModel copyWith({
    bool? isUnlocked,
    List<LessonModel>? lessons,
    List<ReviewModel>? reviews,
  }) {
    return CourseModel(
      id: id,
      title: title,
      teacherName: teacherName,
      teacherAvatarUrl: teacherAvatarUrl,
      priceDzd: priceDzd,
      academicStream: academicStream,
      subjectId: subjectId,
      thumbnailPath: thumbnailPath,
      description: description,
      averageRating: averageRating,
      reviewsCount: reviewsCount,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      subject: subject,
      lessons: lessons ?? this.lessons,
      reviews: reviews ?? this.reviews,
    );
  }
}
