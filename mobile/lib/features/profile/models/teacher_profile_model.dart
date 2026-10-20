import '../../catalog/models/course_model.dart';
import '../../announcements/models/announcement_model.dart';

class TeacherProfileModel {
  final int id;
  final int userId;
  final String name;
  final String? avatarUrl;
  final String headline;
  final String bio;
  final int coursesCount;
  final int announcementsCount;
  final double averageRating;
  final int reviewsCount;
  final List<CourseModel> courses;
  final List<AnnouncementModel> announcements;

  TeacherProfileModel({
    required this.id,
    required this.userId,
    required this.name,
    this.avatarUrl,
    required this.headline,
    required this.bio,
    required this.coursesCount,
    required this.announcementsCount,
    required this.averageRating,
    required this.reviewsCount,
    required this.courses,
    required this.announcements,
  });

  factory TeacherProfileModel.fromJson(Map<String, dynamic> json) {
    return TeacherProfileModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      name: json['name'] ?? 'Teacher',
      avatarUrl: json['avatar_url'],
      headline: json['headline'] ?? '',
      bio: json['bio'] ?? '',
      coursesCount: json['courses_count'] ?? 0,
      announcementsCount: json['announcements_count'] ?? 0,
      averageRating: double.tryParse(json['average_rating']?.toString() ?? '5.0') ?? 5.0,
      reviewsCount: json['reviews_count'] ?? 0,
      courses: json['courses'] != null
          ? (json['courses'] as List).map((e) => CourseModel.fromJson(e)).toList()
          : [],
      announcements: json['announcements'] != null
          ? (json['announcements'] as List).map((e) => AnnouncementModel.fromJson(e)).toList()
          : [],
    );
  }
}
