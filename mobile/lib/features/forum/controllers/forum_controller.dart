import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../models/forum_post_model.dart';
import '../models/forum_reply_model.dart';
import '../services/forum_api.dart';
import '../../catalog/services/catalog_api.dart';
import '../../catalog/models/subject_model.dart';
import '../../../core/theme/premium_interactions.dart';

class ForumController extends GetxController {
  final ForumApi _api = ForumApi();
  final CatalogApi _catalogApi = CatalogApi();
  final ImagePicker _picker = ImagePicker();

  final RxList<ForumPostModel> posts = <ForumPostModel>[].obs;
  final RxList<SubjectModel> subjects = <SubjectModel>[].obs;

  final RxBool isLoadingFeed = false.obs;
  final RxBool isLoadingDetails = false.obs;
  final RxBool isSubmitting = false.obs;

  final Rxn<ForumPostModel> currentPost = Rxn<ForumPostModel>();

  final RxnInt selectedSubjectId = RxnInt();
  final RxString selectedType = 'all'.obs; // 'all', 'question', 'discussion', 'resource'
  final RxString sortBy = 'latest'.obs; // 'latest', 'popular', 'unanswered'

  final TextEditingController searchController = TextEditingController();
  final TextEditingController replyContentController = TextEditingController();

  final TextEditingController createTitleController = TextEditingController();
  final TextEditingController createContentController = TextEditingController();
  final RxString createType = 'question'.obs; // 'question', 'discussion', 'resource'
  final RxnInt createSubjectId = RxnInt();
  final Rxn<File> createSelectedImage = Rxn<File>();

  @override
  void onInit() {
    super.onInit();
    fetchSubjects();
    fetchFeed();
  }

  @override
  void onClose() {
    searchController.dispose();
    replyContentController.dispose();
    createTitleController.dispose();
    createContentController.dispose();
    super.onClose();
  }

  Future<void> fetchSubjects() async {
    try {
      final res = await _catalogApi.getSubjects();
      if (res.data['success'] == true) {
        final List list = res.data['data'] ?? [];
        subjects.value = list.map((json) => SubjectModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('fetchSubjects error: $e');
    }
  }

  Future<void> fetchFeed() async {
    isLoadingFeed.value = true;
    try {
      final Map<String, dynamic> query = {};
      if (selectedSubjectId.value != null) {
        query['subject_id'] = selectedSubjectId.value;
      }
      if (selectedType.value != 'all') {
        query['type'] = selectedType.value;
      }
      if (searchController.text.trim().isNotEmpty) {
        query['search'] = searchController.text.trim();
      }
      query['sort_by'] = sortBy.value;

      final res = await _api.getPosts(query);
      if (res.data['success'] == true) {
        final List list = res.data['data'] ?? [];
        posts.value = list.map((json) => ForumPostModel.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('fetchFeed error: $e');
    } finally {
      isLoadingFeed.value = false;
    }
  }

  Future<void> fetchPostDetails(int postId) async {
    isLoadingDetails.value = true;
    try {
      final res = await _api.getPostDetails(postId);
      if (res.data['success'] == true) {
        currentPost.value = ForumPostModel.fromJson(res.data['data']);
      }
    } catch (e) {
      debugPrint('fetchPostDetails error: $e');
    } finally {
      isLoadingDetails.value = false;
    }
  }

  void setCreateType(String type) {
    HapticHelper.selectionClick();
    createType.value = type;
  }

  void setCreateSubjectId(int? id) {
    createSubjectId.value = id;
  }

  Future<void> pickNewPostImage() async {
    HapticHelper.selectionClick();
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (file != null) {
      createSelectedImage.value = File(file.path);
    }
  }

  void clearNewPostImage() {
    createSelectedImage.value = null;
  }

  void clearCreatePostForm() {
    createTitleController.clear();
    createContentController.clear();
    createType.value = 'question';
    createSubjectId.value = null;
    createSelectedImage.value = null;
  }

  Future<bool> submitNewPost() async {
    final title = createTitleController.text.trim();
    final content = createContentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      Get.snackbar(
        'error'.tr,
        'error_fill_fields'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        colorText: Colors.white,
      );
      return false;
    }

    HapticHelper.mediumTap();
    isSubmitting.value = true;

    try {
      final res = await _api.createPost(
        title: title,
        content: content,
        type: createType.value,
        subjectId: createSubjectId.value,
        imageFile: createSelectedImage.value,
      );
      if (res.data['success'] == true) {
        final newPost = ForumPostModel.fromJson(res.data['data']);
        posts.insert(0, newPost);
        clearCreatePostForm();
        return true;
      }
    } catch (e) {
      debugPrint('submitNewPost error: $e');
    } finally {
      isSubmitting.value = false;
    }
    return false;
  }

  Future<void> addReply(int postId, {File? imageFile}) async {
    final text = replyContentController.text.trim();
    if (text.isEmpty) return;

    isSubmitting.value = true;
    try {
      final res = await _api.addReply(postId: postId, content: text, imageFile: imageFile);
      if (res.data['success'] == true) {
        replyContentController.clear();
        final newReply = ForumReplyModel.fromJson(res.data['data']);

        if (currentPost.value != null && currentPost.value!.id == postId) {
          final updatedReplies = List<ForumReplyModel>.from(currentPost.value!.replies)..add(newReply);
          currentPost.value = currentPost.value!.copyWith(
            repliesCount: currentPost.value!.repliesCount + 1,
            replies: updatedReplies,
          );
        }

        final index = posts.indexWhere((p) => p.id == postId);
        if (index != -1) {
          posts[index] = posts[index].copyWith(
            repliesCount: posts[index].repliesCount + 1,
          );
        }
      }
    } catch (e) {
      debugPrint('addReply error: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> togglePostLike(int postId) async {
    final index = posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = posts[index];
      final newIsLiked = !post.isLiked;
      final newCount = newIsLiked ? post.likesCount + 1 : _max(0, post.likesCount - 1);

      posts[index] = post.copyWith(isLiked: newIsLiked, likesCount: newCount);
      if (currentPost.value?.id == postId) {
        currentPost.value = currentPost.value!.copyWith(isLiked: newIsLiked, likesCount: newCount);
      }

      try {
        await _api.togglePostLike(postId);
      } catch (e) {
        posts[index] = post;
        if (currentPost.value?.id == postId) {
          currentPost.value = post;
        }
      }
    }
  }

  Future<void> toggleReplyLike(int replyId) async {
    if (currentPost.value == null) return;
    final replies = List<ForumReplyModel>.from(currentPost.value!.replies);
    final index = replies.indexWhere((r) => r.id == replyId);
    if (index != -1) {
      final reply = replies[index];
      final newIsLiked = !reply.isLiked;
      final newCount = newIsLiked ? reply.likesCount + 1 : (reply.likesCount - 1);
      replies[index] = reply.copyWith(isLiked: newIsLiked, likesCount: newCount);

      currentPost.value = currentPost.value!.copyWith(replies: replies);

      try {
        await _api.toggleReplyLike(replyId);
      } catch (e) {
        replies[index] = reply;
        currentPost.value = currentPost.value!.copyWith(replies: replies);
      }
    }
  }

  Future<void> markBestAnswer(int replyId) async {
    if (currentPost.value == null) return;
    try {
      final res = await _api.markBestAnswer(replyId);
      if (res.data['success'] == true) {
        fetchPostDetails(currentPost.value!.id);
      }
    } catch (e) {
      debugPrint('markBestAnswer error: $e');
    }
  }

  void filterBySubject(int? subjectId) {
    if (selectedSubjectId.value == subjectId) {
      selectedSubjectId.value = null;
    } else {
      selectedSubjectId.value = subjectId;
    }
    fetchFeed();
  }

  void filterByType(String type) {
    selectedType.value = type;
    fetchFeed();
  }

  bool get hasActiveFilters =>
      selectedSubjectId.value != null ||
      selectedType.value != 'all' ||
      sortBy.value != 'latest';

  void resetFilters() {
    selectedSubjectId.value = null;
    selectedType.value = 'all';
    sortBy.value = 'latest';
    fetchFeed();
  }

  void setSortBy(String sort) {
    sortBy.value = sort;
    fetchFeed();
  }

  Future<void> recordView(int id) async {
    final idx = posts.indexWhere((p) => p.id == id);
    if (idx != -1 && posts[idx].isViewed) return;

    try {
      final res = await _api.recordView(id);
      if (res.data['success'] == true && idx != -1) {
        final updatedCount = (res.data['data']['views_count'] as int?) ?? (posts[idx].viewsCount + 1);
        posts[idx] = posts[idx].copyWith(
          isViewed: true,
          viewsCount: updatedCount,
        );
      }
    } catch (e) {
      debugPrint('recordView error: $e');
    }
  }

  String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return 'min_ago'.trParams({'min': '${diff.inMinutes}'});
    if (diff.inHours < 24) return 'hours_ago'.trParams({'hours': '${diff.inHours}'});
    return 'days_ago'.trParams({'days': '${diff.inDays}'});
  }

  int _max(int a, int b) => a > b ? a : b;
}
