import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';

class AiTutorApi extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<dio.Response> getHistory() {
    return _apiClient.get('/ai/history');
  }

  Future<dio.Response> sendPrompt(String prompt, String streamCode, {String? imagePath}) async {
    if (imagePath != null && imagePath.isNotEmpty) {
      final formData = dio.FormData.fromMap({
        'prompt': prompt,
        'stream_code': streamCode,
        'image': await dio.MultipartFile.fromFile(imagePath),
      });
      return _apiClient.post(
        '/ai/chat',
        data: formData,
        options: dio.Options(
          responseType: dio.ResponseType.plain,
          receiveTimeout: const Duration(seconds: 90),
          sendTimeout: const Duration(seconds: 30),
          headers: {
            'Accept': 'text/event-stream, application/json',
          },
        ),
      );
    }

    return _apiClient.post(
      '/ai/chat',
      data: {
        'prompt': prompt,
        'stream_code': streamCode,
      },
      options: dio.Options(
        responseType: dio.ResponseType.plain,
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'text/event-stream, application/json',
        },
      ),
    );
  }

  Future<dio.Response> clearHistory() {
    return _apiClient.delete('/ai/clear');
  }
}
