import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';

class StudyTipApi extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<dio.Response> getStudyTips() {
    return _apiClient.get('/study-tips');
  }
}
