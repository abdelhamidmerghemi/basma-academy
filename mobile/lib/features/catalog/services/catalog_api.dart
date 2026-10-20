import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';

class CatalogApi extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<dio.Response> getSubjects([Map<String, dynamic>? queryParameters]) {
    return _apiClient.get('/subjects', queryParameters: queryParameters);
  }

  Future<dio.Response> getCourses(Map<String, dynamic> queryParameters) {
    return _apiClient.get('/courses', queryParameters: queryParameters);
  }

  Future<dio.Response> getCourseDetails(int id) {
    return _apiClient.get('/courses/$id');
  }

  Future<dio.Response> addReview(int courseId, {required double rating, required String comment}) {
    return _apiClient.post(
      '/courses/$courseId/reviews',
      data: {
        'rating': rating,
        'comment': comment,
      },
    );
  }
}
