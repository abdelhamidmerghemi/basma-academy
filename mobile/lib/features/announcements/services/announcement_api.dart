import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';

class AnnouncementApi extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<dio.Response> getAnnouncements() {
    return _apiClient.get('/announcements');
  }

  Future<dio.Response> likeAnnouncement(int id) {
    return _apiClient.post('/announcements/$id/like');
  }

  Future<dio.Response> getComments(int announcementId) {
    return _apiClient.get('/announcements/$announcementId/comments');
  }

  Future<dio.Response> addComment(int announcementId, Map<String, dynamic> data) {
    return _apiClient.post('/announcements/$announcementId/comments', data: data);
  }

  Future<dio.Response> recordView(int id) {
    return _apiClient.post('/announcements/$id/view');
  }
}
