import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../catalog/controllers/course_details_controller.dart';
import '../services/lesson_progress_api.dart';

class LessonProgressData {
  final int secondsWatched;
  final int lastPositionSeconds;
  final bool isCompleted;

  LessonProgressData({
    required this.secondsWatched,
    required this.lastPositionSeconds,
    required this.isCompleted,
  });
}

class LessonProgressController extends GetxController {
  final LessonProgressApi _api = Get.put(LessonProgressApi());

  final lessonProgressMap = <int, LessonProgressData>{}.obs;

  Future<void> syncProgress(
    int lessonId, {
    required int secondsWatched,
    required int lastPositionSeconds,
    required bool isCompleted,
  }) async {
    lessonProgressMap[lessonId] = LessonProgressData(
      secondsWatched: secondsWatched,
      lastPositionSeconds: lastPositionSeconds,
      isCompleted: isCompleted,
    );

    if (Get.isRegistered<CourseDetailsController>()) {
      Get.find<CourseDetailsController>().markLessonProgress(
        lessonId,
        isCompleted: isCompleted,
        lastPositionSeconds: lastPositionSeconds,
      );
    }

    try {
      await _api.updateProgress(
        lessonId,
        secondsWatched: secondsWatched,
        lastPositionSeconds: lastPositionSeconds,
        isCompleted: isCompleted,
      );
    } catch (e) {
      debugPrint('Lesson progress sync error: $e');
    }
  }

  bool isLessonCompleted(int lessonId, bool defaultVal) {
    if (lessonProgressMap.containsKey(lessonId)) {
      return lessonProgressMap[lessonId]!.isCompleted;
    }
    return defaultVal;
  }
}
