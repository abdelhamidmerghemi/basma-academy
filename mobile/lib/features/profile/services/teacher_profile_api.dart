import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';

class TeacherProfileApi extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<dio.Response> getTeacherProfile(int id) {
    return _apiClient.get('/teachers/$id');
  }
}
