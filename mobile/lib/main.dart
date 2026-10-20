import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:basma_academy_mobile/firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:basma_academy_mobile/core/bindings/initial_binding.dart';
import 'package:basma_academy_mobile/core/lang/translation_service.dart';
import 'package:basma_academy_mobile/core/routes/app_routes.dart';
import 'package:basma_academy_mobile/core/theme/theme_config.dart';
import 'package:basma_academy_mobile/core/utils/local_storage.dart';
import 'package:basma_academy_mobile/core/network/firebase_messaging_service.dart';
import 'package:basma_academy_mobile/core/theme/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessagingService.init();
  await GoogleSignIn.instance.initialize();
  await LocalStorage.init();
  //await LocalStorage.reset();

  // Register ThemeService early so it's available in MyApp
  Get.put<ThemeService>(ThemeService(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final String savedLang = LocalStorage.getLanguage();
    final themeService = Get.find<ThemeService>();

    return Obx(
      () => GetMaterialApp(
        title: 'Basma Academy',
        debugShowCheckedModeBanner: false,

        translations: TranslationService(),
        locale: Locale(
          savedLang,
          savedLang == 'ar' ? 'DZ' : (savedLang == 'fr' ? 'FR' : 'US'),
        ),
        fallbackLocale: TranslationService.fallbackLocale,

        initialBinding: InitialBinding(),
        initialRoute: AppRoutes.splash,
        getPages: AppRoutes.routes,

        theme: ThemeConfig.getLightTheme(savedLang),
        darkTheme: ThemeConfig.getDarkTheme(savedLang),
        themeMode: themeService.themeMode,
      ),
    );
  }
}
