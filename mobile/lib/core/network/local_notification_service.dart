import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

    static Future<void> init() async {
    if (_initialized) return;

    try {
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _plugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('[LocalNotif] Notification tapped with payload: ${response.payload}');
          if (response.payload != null && response.payload!.isNotEmpty) {
            _handleNotificationPayload(response.payload!);
          } else {
            Get.toNamed('/notifications');
          }
        },
      );

      const androidChannel = AndroidNotificationChannel(
        'basma_high_importance_channel',
        'Basma Academy Notifications',
        description: 'High importance notifications for Basma Academy',
        importance: Importance.max,
      );

      final androidImplementation = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        await androidImplementation.createNotificationChannel(androidChannel);
      }

      _initialized = true;
      debugPrint('[LocalNotif] Initialized successfully');
    } catch (e) {
      debugPrint('[LocalNotif] Initialization failed: $e');
    }
  }

    static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_initialized) await init();

    try {
      const androidDetails = AndroidNotificationDetails(
        'basma_high_importance_channel',
        'Basma Academy Notifications',
        channelDescription: 'High importance notifications for Basma Academy',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _plugin.show(id, title, body, details, payload: payload);
    } catch (e) {
      debugPrint('[LocalNotif] Failed to show system notification: $e');
    }
  }

    static void showInAppBanner({
    required String title,
    required String body,
    String? payload,
    VoidCallback? onTap,
  }) {
    Get.snackbar(
      title,
      body,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 6),
      backgroundColor: const Color(0xFF1E293B),
      colorText: Colors.white,
      borderRadius: 16,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF2563EB).withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          CupertinoIcons.bell_fill,
          color: Color(0xFF38BDF8),
          size: 22,
        ),
      ),
      mainButton: TextButton(
        onPressed: () {
          Get.back(); // Dismiss snackbar
          if (onTap != null) {
            onTap();
          } else if (payload != null) {
            _handleNotificationPayload(payload);
          } else {
            Get.toNamed('/notifications');
          }
        },
        child: const Text(
          'عرض',
          style: TextStyle(
            color: Color(0xFF38BDF8),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onTap: (_) {
        if (onTap != null) {
          onTap();
        } else if (payload != null) {
          _handleNotificationPayload(payload);
        } else {
          Get.toNamed('/notifications');
        }
      },
    );
  }

  static void _handleNotificationPayload(String payload) {
    try {
      if (payload.contains('/catalog') || payload.contains('course')) {
        Get.toNamed('/catalog');
      } else {
        Get.toNamed('/notifications');
      }
    } catch (e) {
      Get.toNamed('/notifications');
    }
  }
}
