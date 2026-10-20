import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';

class AuthApi {
  final ApiClient _apiClient;

  AuthApi(this._apiClient);

  Future<Map<String, dynamic>> sendLoginOtp(String phone) async {
    try {
      final response = await _apiClient.post(
        '/auth/send-login-otp',
        data: {'phone': phone},
      );
      if (response.data['success'] == true) {
        return Map<String, dynamic>.from(response.data);
      }
      throw ApiException(
        message: response.data['message'] ?? 'Failed to send OTP.',
        statusCode: response.statusCode,
      );
    } catch (e) {
      throw _handleError(e, 'Failed to send login OTP.');
    }
  }

  Future<Map<String, dynamic>> checkRegistration(String phone, String? email) async {
    try {
      final response = await _apiClient.post(
        '/auth/check-registration',
        data: {
          'phone': phone,
          if (email != null && email.isNotEmpty) 'email': email,
        },
      );
      if (response.data['success'] == true) {
        return Map<String, dynamic>.from(response.data);
      }
      throw ApiException(
        message: response.data['message'] ?? 'Validation failed.',
        statusCode: response.statusCode,
      );
    } catch (e) {
      throw _handleError(e, 'Validation failed.');
    }
  }

  Future<Map<String, dynamic>> sendRegisterOtp(String phone, {String? email}) async {
    try {
      final response = await _apiClient.post(
        '/auth/send-register-otp',
        data: {
          'phone': phone,
          if (email != null && email.isNotEmpty) 'email': email,
        },
      );
      if (response.data['success'] == true) {
        return Map<String, dynamic>.from(response.data);
      }
      throw ApiException(
        message: response.data['message'] ?? 'Failed to send OTP.',
        statusCode: response.statusCode,
      );
    } catch (e) {
      throw _handleError(e, 'Failed to send registration OTP.');
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post('/register', data: data);
      if (response.data['success'] == true) {
        return Map<String, dynamic>.from(response.data);
      }
      throw ApiException(
        message: response.data['message'] ?? 'Registration failed.',
        statusCode: response.statusCode,
      );
    } catch (e) {
      throw _handleError(e, 'Registration failed.');
    }
  }

  Future<Map<String, dynamic>> login(String phone, String code) async {
    try {
      final response = await _apiClient.post(
        '/login',
        data: {'phone': phone, 'code': code},
      );
      if (response.data['success'] == true) {
        return Map<String, dynamic>.from(response.data);
      }
      throw ApiException(
        message: response.data['message'] ?? 'Invalid code.',
        statusCode: response.statusCode,
      );
    } catch (e) {
      throw _handleError(e, 'Verification failed.');
    }
  }

  Future<Map<String, dynamic>> googleLogin(String idToken) async {
    try {
      final response = await _apiClient.post(
        '/auth/google',
        data: {'id_token': idToken},
      );
      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      throw _handleError(e, 'Google Sign-In failed.');
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.post('/logout');
    } catch (e) {
      // Ignore failures on logout to ensure local data is cleared regardless
    }
  }

  Future<void> storeDeviceToken(String fcmToken, {String platform = 'ios'}) async {
    try {
      await _apiClient.post(
        '/device-token',
        data: {
          'fcm_token': fcmToken,
          'platform': platform,
        },
      );
    } catch (e) {
      // Non-blocking sync
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _apiClient.get('/profile');
      if (response.data['success'] == true) {
        return Map<String, dynamic>.from(response.data);
      }
      throw ApiException(
        message: response.data['message'] ?? 'Failed to load profile.',
        statusCode: response.statusCode,
      );
    } catch (e) {
      throw _handleError(e, 'Failed to load profile.');
    }
  }

  Future<Map<String, dynamic>> updateProfile(dynamic data) async {
    try {
      final response = data is FormData
          ? await _apiClient.post('/profile', data: data)
          : await _apiClient.put('/profile', data: data);
      if (response.data['success'] == true) {
        return Map<String, dynamic>.from(response.data);
      }
      throw ApiException(
        message: response.data['message'] ?? 'Failed to update profile.',
        statusCode: response.statusCode,
      );
    } catch (e) {
      throw _handleError(e, 'Failed to update profile.');
    }
  }

  ApiException _handleError(dynamic error, String fallbackMessage) {
    if (error is ApiException) return error;
    if (error is DioException) {
      final message = ApiClient.parseErrorMessage(error);
      return ApiException(
        message: message.isNotEmpty ? message : fallbackMessage,
        statusCode: error.response?.statusCode,
      );
    }
    return ApiException(message: error.toString());
  }
}
