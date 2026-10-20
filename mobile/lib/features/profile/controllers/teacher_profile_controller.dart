import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../models/teacher_profile_model.dart';
import '../services/teacher_profile_api.dart';
import '../../../core/network/api_exception.dart';
import '../../announcements/controllers/announcement_controller.dart';
import '../../announcements/models/announcement_model.dart';

import '../../../core/utils/param_parser.dart';

class TeacherProfileController extends GetxController {
  final TeacherProfileApi _api = Get.put(TeacherProfileApi());

  final teacherProfile = Rxn<TeacherProfileModel>();
  final isLoading = false.obs;
  final selectedTabIndex = 0.obs; // 0: Courses, 1: Announcements

  @override
  void onInit() {
    super.onInit();
    final teacherId = ParamParser.extractId(Get.arguments);
    debugPrint('flutter: [TeacherProfileController] Get.arguments=${Get.arguments} -> extracted teacherId=$teacherId');
    if (teacherId != null) {
      fetchTeacherProfile(teacherId);
    }
  }

  Future<void> fetchTeacherProfile(int id) async {
    isLoading.value = true;
    try {
      debugPrint('flutter: [TeacherProfileController] Fetching profile for teacher ID=$id');
      final response = await _api.getTeacherProfile(id);
      if (response.data['success'] == true) {
        teacherProfile.value = TeacherProfileModel.fromJson(response.data['data']);
        debugPrint('flutter: [TeacherProfileController] Profile loaded: name=${teacherProfile.value?.name}, user_id=${teacherProfile.value?.userId}, profile_id=${teacherProfile.value?.id}');
      }
    } on ApiException catch (e) {
      debugPrint('fetchTeacherProfile API exception: ${e.message}');
    } catch (e) {
      debugPrint('fetchTeacherProfile error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> likeAnnouncement(int id) async {
    final announcementCtrl = Get.find<AnnouncementController>();
    await announcementCtrl.likeAnnouncement(id);

    if (teacherProfile.value != null) {
      final currentProfile = teacherProfile.value!;
      final idx = currentProfile.announcements.indexWhere((a) => a.id == id);
      if (idx != -1) {
        final updatedAnnouncements = List<AnnouncementModel>.from(currentProfile.announcements);
        final old = updatedAnnouncements[idx];

        final ctrlItem = announcementCtrl.announcements.firstWhereOrNull((a) => a.id == id);

        updatedAnnouncements[idx] = AnnouncementModel(
          id: old.id,
          userId: old.userId,
          teacherId: old.teacherId,
          teacherName: old.teacherName,
          content: old.content,
          imagePath: old.imagePath,
          likesCount: ctrlItem?.likesCount ?? (old.isLiked ? old.likesCount - 1 : old.likesCount + 1),
          commentsCount: old.commentsCount,
          viewsCount: old.viewsCount,
          isLiked: ctrlItem?.isLiked ?? !old.isLiked,
          isViewed: old.isViewed,
          createdAt: old.createdAt,
          teacherAvatarUrl: old.teacherAvatarUrl,
        );

        teacherProfile.value = TeacherProfileModel(
          id: currentProfile.id,
          userId: currentProfile.userId,
          name: currentProfile.name,
          avatarUrl: currentProfile.avatarUrl,
          headline: currentProfile.headline,
          bio: currentProfile.bio,
          coursesCount: currentProfile.coursesCount,
          announcementsCount: currentProfile.announcementsCount,
          averageRating: currentProfile.averageRating,
          reviewsCount: currentProfile.reviewsCount,
          courses: currentProfile.courses,
          announcements: updatedAnnouncements,
        );
      }
    }
  }
}
