import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'local_notification_service.dart';

class FirebaseMessagingService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    try {
      await LocalNotificationService.init();

      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint('[FCM] Permission status: ${settings.authorizationStatus}');

      String? token = await _messaging.getToken();
      if (token != null) {
        debugPrint('[FCM] Device Token: $token');
      }

      _messaging.onTokenRefresh.listen((newToken) {
        debugPrint('[FCM] Token refreshed: $newToken');
      });

      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('[FCM] Received foreground message: ${message.notification?.title}');
        final title = message.notification?.title ?? message.data['title'] ?? 'إشعار جديد';
        final body = message.notification?.body ?? message.data['body'] ?? '';
        final payload = message.data['route'] ?? message.data['payload'];

        if (title.isNotEmpty) {
          LocalNotificationService.showNotification(
            id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
            title: title,
            body: body,
            payload: payload?.toString(),
          );
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('[FCM] App opened via notification: ${message.notification?.title}');
      });

    } catch (e) {
      debugPrint('[FCM] Initialization failed: $e');
    }
  }

  // Subscribe user to their academic stream topic
  static Future<void> updateSubscription(String academicStream) async {
    try {
      // Clean string for firebase topic compliance (alphanumeric, underscores, hyphens only)
      final cleanTopic = 'stream_${academicStream.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_')}';
      await _messaging.subscribeToTopic(cleanTopic);
      debugPrint('[FCM] Subscribed to topic: $cleanTopic');
    } catch (e) {
      debugPrint('[FCM] Topic subscription failed: $e');
    }
  }

  static Future<void> unsubscribe(String academicStream) async {
    try {
      final cleanTopic = 'stream_${academicStream.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_')}';
      await _messaging.unsubscribeFromTopic(cleanTopic);
      debugPrint('[FCM] Unsubscribed from topic: $cleanTopic');
    } catch (e) {
      debugPrint('[FCM] Topic unsubscription failed: $e');
    }
  }

    static Future<String?> getToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      debugPrint('[FCM] Error fetching token: $e');
      return null;
    }
  }
}
