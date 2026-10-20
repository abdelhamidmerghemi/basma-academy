import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/api_exception.dart';
import '../models/announcement_model.dart';
import '../models/comment_model.dart';
import '../services/announcement_api.dart';

class AnnouncementController extends GetxController {
  final AnnouncementApi _announcementApi = Get.put(AnnouncementApi());

  final announcements = <AnnouncementModel>[].obs;
  final isLoading = false.obs;

  // Track comments for a specific announcement dynamically
  final comments = <CommentModel>[].obs;
  final isLoadingComments = false.obs;
  final isSubmittingComment = false.obs;

  final commentTextController = TextEditingController();
  final commentFocusNode = FocusNode();
  final commentTextRx = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAnnouncements();
  }

  @override
  void onClose() {
    commentTextController.dispose();
    commentFocusNode.dispose();
    super.onClose();
  }

  Future<void> fetchAnnouncements() async {
    isLoading.value = true;
    try {
      final response = await _announcementApi.getAnnouncements();
      if (response.data['success'] == true) {
        final List list = response.data['data'] ?? [];
        announcements.value = list.map((json) => AnnouncementModel.fromJson(json)).toList();
      }
    } on ApiException catch (e) {
      debugPrint('fetchAnnouncements API exception: ${e.message}');
    } catch (e) {
      debugPrint('fetchAnnouncements error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  final _viewedIds = <int>{};

  Future<void> recordView(int id) async {
    final idx = announcements.indexWhere((element) => element.id == id);
    if (idx != -1 && announcements[idx].isViewed) {
      return;
    }

    if (_viewedIds.contains(id)) return;
    _viewedIds.add(id);

    try {
      final response = await _announcementApi.recordView(id);
      if (response.data['success'] == true) {
        if (idx != -1) {
          final old = announcements[idx];
          announcements[idx] = AnnouncementModel(
            id: old.id,
            userId: old.userId,
            teacherId: old.teacherId,
            teacherName: old.teacherName,
            content: old.content,
            imagePath: old.imagePath,
            likesCount: old.likesCount,
            commentsCount: old.commentsCount,
            viewsCount: response.data['views_count'] ?? (old.viewsCount + 1),
            isLiked: old.isLiked,
            isViewed: true,
            createdAt: old.createdAt,
            teacherAvatarUrl: old.teacherAvatarUrl,
          );
        }
      }
    } catch (e) {
      debugPrint('recordView error: $e');
    }
  }

  Future<void> likeAnnouncement(int id) async {
    try {
      final response = await _announcementApi.likeAnnouncement(id);
      if (response.data['success'] == true) {
        final idx = announcements.indexWhere((element) => element.id == id);
        if (idx != -1) {
          final old = announcements[idx];
          announcements[idx] = AnnouncementModel(
            id: old.id,
            userId: old.userId,
            teacherId: old.teacherId,
            teacherName: old.teacherName,
            content: old.content,
            imagePath: old.imagePath,
            likesCount: response.data['likes_count'] ?? old.likesCount,
            commentsCount: old.commentsCount,
            isLiked: response.data['is_liked'] ?? !old.isLiked,
            createdAt: old.createdAt,
            teacherAvatarUrl: old.teacherAvatarUrl,
          );
        }
      }
    } on ApiException catch (e) {
      debugPrint('likeAnnouncement API exception: ${e.message}');
    } catch (e) {
      debugPrint('likeAnnouncement error: $e');
    }
  }

  Future<void> fetchComments(int announcementId) async {
    isLoadingComments.value = true;
    comments.clear();
    commentTextController.clear();
    commentTextRx.value = '';
    try {
      final response = await _announcementApi.getComments(announcementId);
      if (response.data['success'] == true) {
        final List list = response.data['data'] ?? [];
        comments.value = list.map((json) => CommentModel.fromJson(json)).toList();
      }
    } on ApiException catch (e) {
      debugPrint('fetchComments API exception: ${e.message}');
    } catch (e) {
      debugPrint('fetchComments error: $e');
    } finally {
      isLoadingComments.value = false;
    }
  }

  Future<bool> addComment(int announcementId, [String? textOverride]) async {
    final txt = textOverride ?? commentTextController.text.trim();
    if (txt.trim().isEmpty) return false;

    isSubmittingComment.value = true;
    try {
      final response = await _announcementApi.addComment(
        announcementId,
        {'content': txt},
      );
      if (response.data['success'] == true) {
        final newComment = CommentModel.fromJson(response.data['data']);
        comments.add(newComment);
        commentTextController.clear();
        commentTextRx.value = '';
        commentFocusNode.unfocus();

        final idx = announcements.indexWhere((element) => element.id == announcementId);
        if (idx != -1) {
          final old = announcements[idx];
          announcements[idx] = AnnouncementModel(
            id: old.id,
            userId: old.userId,
            teacherId: old.teacherId,
            teacherName: old.teacherName,
            content: old.content,
            imagePath: old.imagePath,
            likesCount: old.likesCount,
            commentsCount: old.commentsCount + 1,
            isLiked: old.isLiked,
            createdAt: old.createdAt,
            teacherAvatarUrl: old.teacherAvatarUrl,
          );
        }
        return true;
      }
    } on ApiException catch (e) {
      debugPrint('addComment API exception: ${e.message}');
    } catch (e) {
      debugPrint('addComment error: $e');
    } finally {
      isSubmittingComment.value = false;
    }
    return false;
  }
}
