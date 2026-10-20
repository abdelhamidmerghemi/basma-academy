import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:basma_academy_mobile/core/network/api_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/theme/theme_service.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/firebase_messaging_service.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/local_storage.dart';
import '../services/auth_api.dart';
import '../models/user_model.dart';
import '../../catalog/controllers/catalog_controller.dart';

class AuthController extends GetxController {
  final currentStep = 0.obs;

  final pageController = PageController();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final otpController = TextEditingController();
  final emailOtpController = TextEditingController();
  final phoneOtpController = TextEditingController();

  final selectedLanguage = 'ar'.obs;
  final selectedStream = 'BAC_Sciences'.obs;
  final profileAvatarFile = Rxn<File>();
  final schoolNameController = TextEditingController();
  final wilayaCodeController = TextEditingController();

  final isLoading = false.obs;
  final isLoggedIn = false.obs;
  final userToken = ''.obs;
  final currentUser = Rxn<UserModel>();

  final otpSecondsRemaining = 0.obs;
  RxBool get otpCanResend => (otpSecondsRemaining.value == 0).obs;
  Timer? _otpTimer;

  void startOtpTimer() {
    _otpTimer?.cancel();
    otpSecondsRemaining.value = 59;
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (otpSecondsRemaining.value > 0) {
        otpSecondsRemaining.value--;
      } else {
        _otpTimer?.cancel();
      }
    });
  }

  final isRegisterFlow = false.obs;
  final isGoogleRegistration = false.obs;
  final googleId = ''.obs;
  final isPasswordVisible = false.obs;
  final isObscureProfilePassword = true.obs;

  final registerStep = 0.obs;

  Future<void> goToNextRegisterStep() async {
    final isValid = await checkRegistrationDetails();
    if (isValid) {
      registerStep.value = 1;
    }
  }

  void goToPreviousRegisterStep() {
    registerStep.value = 0;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  String getFormattedPhone() {
    String phone = phoneController.text
        .trim()
        .replaceAll(' ', '')
        .replaceAll('-', '');
    if (phone.startsWith('+213')) {
      phone = '0${phone.substring(4)}';
    } else if (phone.startsWith('213')) {
      phone = '0${phone.substring(3)}';
    } else if (!phone.startsWith('0') && phone.isNotEmpty) {
      phone = '0$phone';
    }
    return phone;
  }

  void toggleProfilePasswordVisibility() {
    isObscureProfilePassword.value = !isObscureProfilePassword.value;
  }

  void initializeEditProfileForm() {
    final user = currentUser.value;
    nameController.text = user?.name ?? '';
    phoneController.text = user?.phone ?? '';
    emailController.text = user?.email ?? '';
    schoolNameController.text = user?.studentProfile?.schoolName ?? '';
    wilayaCodeController.text = user?.studentProfile?.wilayaCode?.toString() ?? '';
    selectedStream.value = user?.academicStream ?? 'BAC_Sciences';
    profileAvatarFile.value = null;
    passwordController.clear();
  }

  late final AuthApi _authApi;

  @override
  void onInit() {
    super.onInit();
    _authApi = AuthApi(Get.find<ApiClient>());

    selectedLanguage.value = LocalStorage.getLanguage();
    userToken.value = LocalStorage.getToken();

    if (userToken.value.isNotEmpty) {
      isLoggedIn.value = true;
    }
  }

  Future<bool> checkAuthAndFetchProfile() async {
    final token = LocalStorage.getToken();
    if (token.isEmpty) {
      isLoggedIn.value = false;
      currentUser.value = null;
      return false;
    }

    try {
      final response = await _authApi.getProfile();
      if (response['success'] == true) {
        final rawUser = response['data'];
        currentUser.value = UserModel.fromJson(rawUser);
        isLoggedIn.value = true;
        userToken.value = token;
        return true;
      }
    } on ApiException catch (e) {
      debugPrint('Profile API exception: ${e.message}');
      if (e.statusCode == 401) {
        await logout();
      }
    } catch (e) {
      debugPrint('Profile fetch general error: $e');
    }
    return isLoggedIn.value;
  }

  void changeLanguage(String langCode) async {
    selectedLanguage.value = langCode;
    await LocalStorage.saveLanguage(langCode);

    Locale locale = Locale(
      langCode,
      langCode == 'ar' ? 'DZ' : (langCode == 'fr' ? 'FR' : 'US'),
    );
    Get.updateLocale(locale);

    Get.find<ThemeService>().updateThemeForLanguage(langCode);
  }

  void changeStream(String stream) {
    selectedStream.value = stream;
    // Persist to backend so the student's stream survives logout/re-login.
    // Fire-and-forget: UI is already updated optimistically above.
    updateProfile(stream: stream).catchError((e) {
      debugPrint('changeStream persist error: $e');
      return false;
    });
  }

  void nextStep() async {
    if (currentStep.value < 2) {
      currentStep.value++;
    } else {
      await LocalStorage.setOnboardingSeen();
      Get.toNamed(AppRoutes.login);
    }
  }

  Future<void> requestLoginOtp() async {
    final phone = getFormattedPhone();

    if (phoneController.text.trim().isEmpty) {
      Get.snackbar(
        'phone_number'.tr,
        '${'phone_number'.tr} ${'required'.tr}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    isRegisterFlow.value = false;

    try {
      final res = await _authApi.sendLoginOtp(phone);
      if (Get.currentRoute != AppRoutes.otp) {
        Get.toNamed(AppRoutes.otp);
      }
      Get.snackbar(
        'otp_title'.tr,
        res['message'] ?? 'Verification code sent.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 20),
      );
    } on ApiException catch (e) {
      Get.snackbar(
        'otp_title'.tr,
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('requestLoginOtp error: $e');
      Get.snackbar(
        'otp_title'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (isRegisterFlow.value) {
      await requestRegisterOtp();
    } else {
      await requestLoginOtp();
    }
    startOtpTimer();
  }

  Future<bool> checkRegistrationDetails() async {
    final phone = getFormattedPhone();
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (name.isEmpty) {
      Get.snackbar(
        'name'.tr,
        'name_required'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    }

    if (!isGoogleRegistration.value) {
      if (email.isEmpty) {
        Get.snackbar(
          'email'.tr,
          'email_required'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }
      if (password.isEmpty || password.length < 6) {
        Get.snackbar(
          'password'.tr,
          'password_min'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }
    }

    if (phoneController.text.trim().isEmpty) {
      Get.snackbar(
        'phone_number'.tr,
        '${'phone_number'.tr} ${'required'.tr}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    }

    isLoading.value = true;
    try {
      await _authApi.checkRegistration(phone, email.isNotEmpty ? email : null);
      return true;
    } on ApiException catch (e) {
      Get.snackbar(
        'register'.tr,
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    } catch (e) {
      Get.snackbar(
        'register'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> requestRegisterOtp() async {
    final phone = getFormattedPhone();
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (phoneController.text.trim().isEmpty) {
      Get.snackbar(
        'phone_number'.tr,
        '${'phone_number'.tr} ${'required'.tr}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (name.isEmpty) {
      Get.snackbar(
        'name'.tr,
        'name_required'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (!isGoogleRegistration.value) {
      if (email.isEmpty) {
        Get.snackbar(
          'email'.tr,
          'email_required'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }
      if (password.isEmpty || password.length < 6) {
        Get.snackbar(
          'password'.tr,
          'password_min'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }
    }

    isLoading.value = true;
    isRegisterFlow.value = true;

    try {
      final res = await _authApi.sendRegisterOtp(phone, email: email.isNotEmpty ? email : null);
      if (Get.currentRoute != AppRoutes.otp) {
        Get.toNamed(AppRoutes.otp);
      }
      Get.snackbar(
        'otp_title'.tr,
        res['message'] ?? 'Verification code sent.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 20),
      );
    } on ApiException catch (e) {
      Get.snackbar(
        'otp_title'.tr,
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('requestRegisterOtp error: $e');
      Get.snackbar(
        'otp_title'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtpAndLogin() async {
    final code = otpController.text.trim();

    if (code.isEmpty || code.length != 6) {
      Get.snackbar(
        'otp_title'.tr,
        'enter_otp_hint'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      if (isRegisterFlow.value) {
        final String? fcmToken = await FirebaseMessagingService.getToken();

        final Map<String, dynamic> requestData = {
          'name': nameController.text.trim(),
          'phone': getFormattedPhone(),
          'academic_stream': selectedStream.value,
          'language': selectedLanguage.value,
          'code': code,
          if (fcmToken != null && fcmToken.isNotEmpty) 'fcm_token': fcmToken,
          'platform': defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android',
        };

        if (isGoogleRegistration.value) {
          requestData['email'] = emailController.text.trim();
          requestData['google_id'] = googleId.value;
        } else {
          requestData['email'] = emailController.text.trim();
          requestData['password'] = passwordController.text;
        }

        final res = await _authApi.register(requestData);
        await _handleAuthSuccess(res['data']);
      } else {
        final res = await _authApi.login(getFormattedPhone(), code);
        await _handleAuthSuccess(res['data']);
      }
    } on ApiException catch (e) {
      Get.snackbar(
        'otp_title'.tr,
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    isLoading.value = true;
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        Get.snackbar(
          'Google Sign-In',
          'Could not retrieve Google authentication ID token.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }

      final res = await _authApi.googleLogin(idToken);

      if (res['success'] == true) {
        await _handleAuthSuccess(res['data']);
      } else if (res['user_not_found'] == true) {
        final googleData = res['google_data'];

        googleId.value = googleData['google_id'] ?? '';
        nameController.text = googleData['name'] ?? '';
        emailController.text = googleData['email'] ?? '';
        isGoogleRegistration.value = true;
        isRegisterFlow.value = true;

        Get.toNamed(AppRoutes.register);

        Get.snackbar(
          'Google Sign-In',
          'google_register_hint'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blueAccent,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Google Sign-In',
          res['message'] ?? 'Google authentication failed.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } on ApiException catch (e) {
      Get.snackbar(
        'Google Sign-In',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('Google Sign-In error: $e');

      // If user cancelled, fail silently
      if (e is GoogleSignInException &&
          e.code == GoogleSignInExceptionCode.canceled) {
        isLoading.value = false;
        return;
      }

      Get.snackbar(
        'Google Sign-In',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _handleAuthSuccess(Map<String, dynamic> data) async {
    final String token = data['access_token'];
    final Map<String, dynamic> rawUser = data['user'];

    final user = UserModel.fromJson(rawUser);

    await LocalStorage.saveToken(token);

    userToken.value = token;
    currentUser.value = user;
    isLoggedIn.value = true;

    // Sync the in-memory stream selector with the profile's actual stream.
    // This ensures AI tips and course filters are correct immediately.
    if (user.academicStream.isNotEmpty) {
      selectedStream.value = user.academicStream;
    }

    // Sync FCM device token with backend asynchronously
    FirebaseMessagingService.getToken().then((fcmToken) {
      if (fcmToken != null && fcmToken.isNotEmpty) {
        _authApi.storeDeviceToken(
          fcmToken,
          platform: defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android',
        );
      }
    });

    // Direct to catalog home
    Get.offAllNamed(AppRoutes.dashboard);
  }

    int? _streamCodeToId(String code) {
    const map = {
      'BAC_Sciences':  1,
      'BAC_Maths':     2,
      'BAC_Technique': 3,
      'BAC_Lettres':   4,
      'BAC_Languages': 5,
      'BAC_Gestion':   6,
    };
    return map[code];
  }

  Future<bool> updateProfile({
    String? name,
    String? email,
    String? password,
    String? stream,
    String? language,
    String? schoolName,
    int? wilayaCode,
    File? avatar,
  }) async {
    isLoading.value = true;
    try {
      dynamic data;
      final Map<String, dynamic> fields = {
        if (name != null && name.isNotEmpty) 'name': name,
        if (email != null && email.isNotEmpty) 'email': email,
        if (password != null && password.isNotEmpty) 'password': password,
        if (language != null && language.isNotEmpty) 'language': language,
        if (schoolName != null && schoolName.isNotEmpty) 'school_name': schoolName,
        'wilaya_code': wilayaCode,
      };

      // Backend expects stream_id (int), not stream code (string)
      if (stream != null && stream.isNotEmpty) {
        final streamId = _streamCodeToId(stream);
        if (streamId != null) fields['stream_id'] = streamId;
      }

      if (avatar != null) {
        fields['_method'] = 'PUT';
        fields['avatar'] = await dio.MultipartFile.fromFile(
          avatar.path,
          filename: avatar.path.split('/').last,
        );
        data = dio.FormData.fromMap(fields);
      } else {
        data = fields;
      }

      final response = await _authApi.updateProfile(data);
      if (response['success'] == true) {
        final updatedUser = UserModel.fromJson(response['data']);
        currentUser.value = updatedUser;
        await LocalStorage.saveUser(updatedUser);

        // Persist local preference for stream
        if (stream != null) {
          selectedStream.value = stream;

          // Reload home catalog list immediately
          if (Get.isRegistered<CatalogController>()) {
            Get.find<CatalogController>().fetchCourses();
          }
        }

        Get.snackbar(
          'success'.tr,
          'profile_updated_success'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      }
    } on ApiException catch (e) {
      Get.snackbar(
        'error'.tr,
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('updateProfile error: $e');
      Get.snackbar(
        'error'.tr,
        'unexpected_error'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  Future<void> logout() async {
    try {
      await _authApi.logout();
      await GoogleSignIn.instance.signOut();
    } on ApiException catch (e) {
      Get.snackbar(
        'logout'.tr,
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      await LocalStorage.clearToken();

      userToken.value = '';
      currentUser.value = null;
      isLoggedIn.value = false;

      nameController.clear();
      phoneController.clear();
      emailController.clear();
      passwordController.clear();
      schoolNameController.clear();
      wilayaCodeController.clear();
      otpController.clear();
      isGoogleRegistration.value = false;
      isRegisterFlow.value = false;
      googleId.value = '';

      Get.offAllNamed(AppRoutes.login);
    }
  }
}
