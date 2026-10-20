import 'dart:io';
import 'package:dio/dio.dart' as dio;
import '../../../core/network/api_client.dart';

class ForumApi {
  final ApiClient _client = ApiClient();

  Future<dio.Response> getPosts(Map<String, dynamic> query) {
    return _client.get('/forum', queryParameters: query);
  }

  Future<dio.Response> getPostDetails(int postId) {
    return _client.get('/forum/$postId');
  }

  Future<dio.Response> createPost({
    required String title,
    required String content,
    required String type,
    int? subjectId,
    File? imageFile,
  }) async {
    final Map<String, dynamic> data = {
      'title': title,
      'content': content,
      'type': type,
    };
    if (subjectId != null) {
      data['subject_id'] = subjectId;
    }
    if (imageFile != null && imageFile.existsSync()) {
      data['image'] = await dio.MultipartFile.fromFile(imageFile.path);
    }

    final formData = dio.FormData.fromMap(data);
    return _client.post('/forum', data: formData);
  }

  Future<dio.Response> addReply({
    required int postId,
    required String content,
    File? imageFile,
  }) async {
    final Map<String, dynamic> data = {
      'content': content,
    };
    if (imageFile != null && imageFile.existsSync()) {
      data['image'] = await dio.MultipartFile.fromFile(imageFile.path);
    }

    final formData = dio.FormData.fromMap(data);
    return _client.post('/forum/$postId/replies', data: formData);
  }

  Future<dio.Response> togglePostLike(int postId) {
    return _client.post('/forum/$postId/like');
  }

  Future<dio.Response> toggleReplyLike(int replyId) {
    return _client.post('/forum/replies/$replyId/like');
  }

  Future<dio.Response> markBestAnswer(int replyId) {
    return _client.post('/forum/replies/$replyId/best-answer');
  }

  Future<dio.Response> recordView(int postId) {
    return _client.post('/forum/$postId/view');
  }
}
