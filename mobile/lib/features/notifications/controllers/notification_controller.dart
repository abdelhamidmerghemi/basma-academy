import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/routes/app_routes.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../models/notification_model.dart';
import '../services/notification_api.dart';

class NotificationController extends GetxController {
  final _api = NotificationApi();

  final notifications = <NotificationModel>[].obs;
  final unreadCount = 0.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUnreadCount();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final response = await _api.getNotifications();
      if (response.data['success'] == true) {
        final List list = response.data['data'] ?? [];
        notifications.value =
            list.map((json) => NotificationModel.fromJson(json)).toList();
        unreadCount.value =
            notifications.where((n) => !n.isRead).length;
      }
    } on ApiException catch (e) {
      debugPrint('fetchNotifications error: ${e.message}');
    } catch (e) {
      debugPrint('fetchNotifications unknown error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUnreadCount() async {
    try {
      final response = await _api.getUnreadCount();
      if (response.data['success'] == true) {
        unreadCount.value = response.data['unread_count'] ?? 0;
      }
    } catch (_) {
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      final idx = notifications.indexWhere((n) => n.id == id);
      if (idx != -1 && !notifications[idx].isRead) {
        final old = notifications[idx];
        final updated = NotificationModel(
          id: old.id,
          titleAr: old.titleAr,
          titleFr: old.titleFr,
          titleEn: old.titleEn,
          bodyAr: old.bodyAr,
          bodyFr: old.bodyFr,
          bodyEn: old.bodyEn,
          title: old.title,
          body: old.body,
          type: old.type,
          payload: old.payload,
          imageUrl: old.imageUrl,
          isRead: true,
          createdAt: old.createdAt,
        );
        notifications[idx] = updated;
        unreadCount.value = notifications.where((n) => !n.isRead).length;
      }
      await _api.markAsRead(id);
    } catch (e) {
      debugPrint('markAsRead error: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      notifications.value = notifications
          .map((old) => NotificationModel(
                id: old.id,
                titleAr: old.titleAr,
                titleFr: old.titleFr,
                titleEn: old.titleEn,
                bodyAr: old.bodyAr,
                bodyFr: old.bodyFr,
                bodyEn: old.bodyEn,
                title: old.title,
                body: old.body,
                type: old.type,
                payload: old.payload,
                imageUrl: old.imageUrl,
                isRead: true,
                createdAt: old.createdAt,
              ))
          .toList();
      unreadCount.value = 0;
      await _api.markAllAsRead();
    } catch (e) {
      debugPrint('markAllAsRead error: $e');
    }
  }

    void handleNotificationTap(NotificationModel item) {
    if (!item.isRead) {
      markAsRead(item.id);
    }

    try {
      if (Get.context != null && Navigator.of(Get.context!).canPop()) {
        Navigator.of(Get.context!).pop();
      } else {
        Get.back();
      }
    } catch (_) {}

    Future.microtask(() {
      void navigateToTab(int tabIndex) {
        if (Get.isRegistered<DashboardController>()) {
          Get.find<DashboardController>().changeTab(tabIndex);
        } else {
          Get.offAllNamed(AppRoutes.dashboard);
          Future.delayed(const Duration(milliseconds: 100), () {
            if (Get.isRegistered<DashboardController>()) {
              Get.find<DashboardController>().changeTab(tabIndex);
            }
          });
        }
      }

      if (item.payload != null) {
        if (item.payload!['course_id'] != null) {
          Get.toNamed(AppRoutes.courseDetails, arguments: item.payload!['course_id']);
          return;
        }
        if (item.payload!['quiz_id'] != null) {
          Get.toNamed(AppRoutes.quiz, arguments: item.payload!['quiz_id']);
          return;
        }
      }

      final payloadRoute = item.payload?['route']?.toString();
      if (payloadRoute != null && payloadRoute.isNotEmpty) {
        switch (payloadRoute) {
          case '/catalog':
          case '/courses':
          case '/home':
            navigateToTab(0);
            return;
          case '/search':
            navigateToTab(1);
            return;
          case '/quizzes':
          case '/quiz':
            navigateToTab(0); // No dedicated quiz tab — go to Home
            return;
          case '/ai-tutor':
          case '/ai_tutor':
            navigateToTab(0); // No dedicated AI tab — go to Home
            return;
          case '/flashcards':
          case '/flashcard':
            navigateToTab(0); // No dedicated flashcard tab — go to Home
            return;
          case '/feed':
          case '/announcements':
            navigateToTab(2);
            return;
          case '/profile':
            navigateToTab(3);
            return;
          default:
            try {
              Get.toNamed(payloadRoute);
            } catch (_) {
              navigateToTab(0);
            }
            return;
        }
      }

      // Fallback: Type-based navigation
      switch (item.type) {
        case 'quiz':
          navigateToTab(0); // No dedicated quiz tab
          break;
        case 'flashcard':
        case 'flashcards':
          navigateToTab(0); // No dedicated flashcard tab
          break;
        case 'ai_tutor':
          navigateToTab(0); // No dedicated AI tab
          break;
        case 'announcement':
          navigateToTab(2);
          break;
        case 'profile':
          navigateToTab(3);
          break;
        case 'course':
        case 'catalog':
        case 'general':
        default:
          navigateToTab(0);
          break;
      }
    });
  }
}
