import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/models/user_model.dart';

class LocalStorage {
  static late final SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Language Code
  static Future<void> saveLanguage(String langCode) async {
    await _prefs.setString('language_code', langCode);
  }

  static String getLanguage() {
    return _prefs.getString('language_code') ?? 'ar';
  }

  // Theme Mode
  static Future<void> saveThemeMode(bool isDark) async {
    await _prefs.setBool('is_dark_mode', isDark);
  }

  static bool getThemeMode() {
    return _prefs.getBool('is_dark_mode') ?? true;
  }

  // Auth Token
  static Future<void> saveToken(String token) async {
    await _prefs.setString('user_token', token);
  }

  static String getToken() {
    return _prefs.getString('user_token') ?? '';
  }

  static Future<void> clearToken() async {
    await _prefs.remove('user_token');
  }

  // User profile details
  static Future<void> saveUser(UserModel user) async {
    await _prefs.setString('user_profile', jsonEncode(user.toJson()));
  }

  static UserModel? getUser() {
    final String? userStr = _prefs.getString('user_profile');
    if (userStr == null) return null;
    try {
      return UserModel.fromJson(jsonDecode(userStr));
    } catch (e) {
      return null;
    }
  }

  static Future<void> clearUser() async {
    await _prefs.remove('user_profile');
  }

  // Onboarding Seen Flag
  static Future<void> setOnboardingSeen() async {
    await _prefs.setBool('onboarding_seen', true);
  }

  static bool hasSeenOnboarding() {
    return _prefs.getBool('onboarding_seen') ?? false;
  }

  static Future<void> reset() async {
    await _prefs.clear();
  }
}
