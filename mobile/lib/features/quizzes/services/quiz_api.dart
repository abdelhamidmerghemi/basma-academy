import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../../../../core/network/api_client.dart';

class QuizApi {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<Response> getQuizzes({int? subjectId, int? lessonId}) async {
    final query = <String, dynamic>{};
    if (subjectId != null) query['subject_id'] = subjectId;
    if (lessonId != null) query['lesson_id'] = lessonId;
    return await _apiClient.get('/quizzes', queryParameters: query);
  }

  Future<Response> getQuiz(int quizId) async {
    return await _apiClient.get('/quizzes/$quizId');
  }

  Future<Response> submitQuiz(int quizId, Map<int, int> answers) async {
    final answersPayload = <String, dynamic>{};
    answers.forEach((qId, aId) {
      answersPayload[qId.toString()] = aId;
    });

    return await _apiClient.post(
      '/quizzes/$quizId/submit',
      data: {'answers': answersPayload},
    );
  }
}
