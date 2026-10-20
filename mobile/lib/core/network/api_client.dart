import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response, MultipartFile, FormData;
import '../utils/local_storage.dart';

class ApiClient extends GetxService {
  late final Dio _dio;
  bool _initialized = false;

  ApiClient() {
    _initDio();
  }

  // Configurable base URL with sensible local and production defaults
  static String get baseUrl {
    const configuredUrl = String.fromEnvironment('API_BASE_URL');
    if (configuredUrl.isNotEmpty) return configuredUrl;

    if (kReleaseMode) {
      return 'https://api.basma-academy.com/api';
    }

    // Default for Android Emulator is 10.0.2.2, iOS Simulator / Desktop is localhost
    if (!kIsWeb && Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api';
    }
    return 'http://127.0.0.1:8000/api';
  }

  /// Helper method to extract actual Laravel error messages / validation errors
  static String parseErrorMessage(dynamic error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data != null && data is Map) {
        if (data['errors'] != null && data['errors'] is Map) {
          final errorsMap = data['errors'] as Map;
          final messages = <String>[];
          errorsMap.forEach((key, value) {
            if (value is List && value.isNotEmpty) {
              messages.add(value.first.toString());
            } else if (value != null) {
              messages.add(value.toString());
            }
          });
          if (messages.isNotEmpty) {
            return messages.join('\n');
          }
        }
        if (data['message'] != null && data['message'].toString().isNotEmpty) {
          return data['message'].toString();
        }
      }
      return error.message ?? 'An unexpected error occurred.';
    }
    return error.toString();
  }

  @override
  void onInit() {
    super.onInit();
    _initDio();
  }

  void _initDio() {
    if (_initialized) return;
    _initialized = true;

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'bypass-tunnel-reminder': 'true',
        },
      ),
    );

    if (!kIsWeb) {
      final adapter = _dio.httpClientAdapter;
      if (adapter is IOHttpClientAdapter) {
        adapter.createHttpClient = () {
          final client = HttpClient();
          client.badCertificateCallback = (
            X509Certificate cert,
            String host,
            int port,
          ) => true;
          return client;
        };
      }
    }

    // Secure token interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = LocalStorage.getToken();
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          final realMsg = ApiClient.parseErrorMessage(e);
          debugPrint(
            '[API Error] Status: ${e.response?.statusCode} - Msg: $realMsg',
          );
          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get(path, queryParameters: queryParameters, options: options);
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post(path, data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    return await _dio.delete(path, data: data, options: options);
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.put(path, data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.patch(path, data: data, queryParameters: queryParameters, options: options);
  }
}
