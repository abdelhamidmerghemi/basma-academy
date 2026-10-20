import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';

class FlashcardApi extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<dio.Response> getDecks({int? subjectId}) {
    final Map<String, dynamic> params = {};
    if (subjectId != null) {
      params['subject_id'] = subjectId;
    }
    return _apiClient.get('/flashcard-decks', queryParameters: params);
  }

  Future<dio.Response> reviewCard(int cardId, int grade) {
    return _apiClient.post('/flashcards/$cardId/review', data: {
      'grade': grade,
    });
  }
}
