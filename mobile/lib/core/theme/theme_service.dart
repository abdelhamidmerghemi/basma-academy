import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/local_storage.dart';
import 'theme_config.dart';

class ThemeService extends GetxController {
  final _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;

  ThemeMode get themeMode => _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    _isDarkMode.value = LocalStorage.getThemeMode();
  }

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    LocalStorage.saveThemeMode(_isDarkMode.value);
    Get.changeThemeMode(themeMode);
  }

  // Forces GetX to rebuild themes with the correct localized typography fonts
  void updateThemeForLanguage(String languageCode) {
    Get.changeTheme(_isDarkMode.value
        ? ThemeConfig.getDarkTheme(languageCode)
        : ThemeConfig.getLightTheme(languageCode));
  }
}
