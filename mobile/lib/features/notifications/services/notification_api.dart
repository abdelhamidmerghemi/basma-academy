import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';

class NotificationApi extends GetxService {
  final _client = Get.find<ApiClient>();

  Future<dio.Response> getNotifications() async {
    try {
      return await _client.get('/notifications');
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<dio.Response> getUnreadCount() async {
    try {
      return await _client.get('/notifications/unread-count');
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<dio.Response> markAsRead(int notificationId) async {
    try {
      return await _client.patch('/notifications/$notificationId/read');
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  Future<dio.Response> markAllAsRead() async {
    try {
      return await _client.post('/notifications/read-all');
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }
}
