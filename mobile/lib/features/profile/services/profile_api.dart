import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';

class ProfileApi extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<dio.Response> getOrders() {
    return _apiClient.get('/orders');
  }

  Future<dio.Response> submitOrder(dio.FormData data) {
    return _apiClient.post('/orders', data: data);
  }
}
