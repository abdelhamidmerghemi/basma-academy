import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../../../../core/network/api_client.dart';

class LessonProgressApi {
  final ApiClient _apiClient = Get.find<ApiClient>();

    Future<Response> updateProgress(
    int lessonId, {
    required int secondsWatched,
    required int lastPositionSeconds,
    required bool isCompleted,
  }) async {
    return await _apiClient.post(
      '/lessons/$lessonId/progress',
      data: {
        'seconds_watched': secondsWatched,
        'last_position_seconds': lastPositionSeconds,
        'is_completed': isCompleted,
      },
    );
  }
}
