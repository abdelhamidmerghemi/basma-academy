import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../../core/network/api_exception.dart';
import '../models/course_model.dart';
import '../models/lesson_model.dart';
import '../services/catalog_api.dart';
import '../views/widgets/custom_video_player.dart';
import '../../lessons/controllers/lesson_progress_controller.dart';

import '../../../core/utils/param_parser.dart';

class CourseDetailsController extends GetxController {
  final CatalogApi _catalogApi = Get.find<CatalogApi>();

  @override
  void onInit() {
    super.onInit();
    if (!Get.isRegistered<LessonProgressController>()) {
      Get.put(LessonProgressController(), permanent: true);
    }
    _loadFromParams();
  }

  final course = Rx<CourseModel?>(null);
  final isLoading = true.obs;

  final activeLesson = Rx<LessonModel?>(null);

  VideoPlayerController? videoPlayerController;
  final isPlayerReady = false.obs;
  final isPlaying = false.obs;
  final position = Duration.zero.obs;
  final duration = Duration.zero.obs;
  final playbackSpeed = 1.0.obs;
  final showControls = true.obs;
  final isFullScreen = false.obs;
  final showForwardFeedback = false.obs;
  final showBackwardFeedback = false.obs;
  final isDragging = false.obs;
  final seekAccumulator = 0.obs;

  Timer? _hideTimer;
  Timer? _seekTimer;

  void _loadFromParams() {
    final id = ParamParser.extractId(Get.arguments) ?? int.tryParse(Get.parameters['id'] ?? '');

    if (id != null) {
      fetchCourseDetails(id);
    } else {
      isLoading.value = false;
      debugPrint('CourseDetailsController: Invalid course id parameter');
    }
  }

  Future<void> fetchCourseDetails(int id) async {
    isLoading.value = true;
    try {
      final response = await _catalogApi.getCourseDetails(id);
      if (response.data['success'] == true) {
        course.value = CourseModel.fromJson(response.data['data']);
        
        // Auto-select first preview lesson if the course is locked
        final list = course.value?.lessons ?? [];
        if (list.isNotEmpty) {
          final previewLesson = list.firstWhere(
            (e) => e.isPreview,
            orElse: () => list.first,
          );
          activeLesson.value = previewLesson;
        }
      }
    } on ApiException catch (e) {
      debugPrint('fetchCourseDetails API exception: ${e.message}');
    } catch (e) {
      debugPrint('fetchCourseDetails error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> playLesson(LessonModel lesson) async {
    // Prevent reloading the same lesson if it's already playing
    if (activeLesson.value?.id == lesson.id && videoPlayerController != null) {
      togglePlay();
      return;
    }

    activeLesson.value = lesson;
    isPlayerReady.value = false;
    isPlaying.value = false;

    try {
      if (videoPlayerController != null) {
        videoPlayerController!.pause();
        await videoPlayerController!.dispose();
        videoPlayerController = null;
      }

      String videoUrl = lesson.videoPath;
      if (videoUrl.startsWith('http://') &&
          !videoUrl.contains('192.168.') &&
          !videoUrl.contains('localhost') &&
          !videoUrl.contains('127.0.0.1')) {
        videoUrl = videoUrl.replaceFirst('http://', 'https://');
      }

      videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
      );
      await videoPlayerController!.initialize();

      duration.value = videoPlayerController!.value.duration;

      // Resume from last watched position if available
      if (lesson.lastPositionSeconds > 0 &&
          lesson.lastPositionSeconds < duration.value.inSeconds - 5) {
        await videoPlayerController!.seekTo(Duration(seconds: lesson.lastPositionSeconds));
      }

      videoPlayerController!.addListener(() {
        if (!isDragging.value) {
          position.value = videoPlayerController!.value.position;
        }
        isPlaying.value = videoPlayerController!.value.isPlaying;

        final currentSec = position.value.inSeconds;
        final totalSec = duration.value.inSeconds;

        // Periodic sync every 5 seconds or upon completion
        if (currentSec > 0 && currentSec != _lastSyncedSecond && (currentSec % 5 == 0 || currentSec >= totalSec - 1)) {
          _lastSyncedSecond = currentSec;
          final isDone = totalSec > 0 && (currentSec / totalSec) >= 0.90;

          if (Get.isRegistered<LessonProgressController>()) {
            Get.find<LessonProgressController>().syncProgress(
              lesson.id,
              secondsWatched: currentSec,
              lastPositionSeconds: currentSec,
              isCompleted: isDone,
            );
          }
        }
      });

      videoPlayerController!.play();
      isPlayerReady.value = true;
      resetAutoHideTimer();
    } catch (e) {
      isPlayerReady.value = false;
      debugPrint('Error initializing video player: $e');
    }
  }

  int _lastSyncedSecond = -1;

  void markLessonProgress(
    int lessonId, {
    required bool isCompleted,
    required int lastPositionSeconds,
  }) {
    final currentCourse = course.value;
    if (currentCourse == null) return;

    final lessons = currentCourse.lessons ?? [];
    final updatedLessons = lessons.map((l) {
      if (l.id == lessonId) {
        return l.copyWith(
          isCompleted: isCompleted || l.isCompleted,
          lastPositionSeconds: lastPositionSeconds,
        );
      }
      return l;
    }).toList();

    course.value = currentCourse.copyWith(lessons: updatedLessons);
  }

  void togglePlay() {
    if (videoPlayerController == null) return;
    if (isPlaying.value) {
      videoPlayerController!.pause();
    } else {
      videoPlayerController!.play();
    }
  }

  void seekTo(Duration pos) {
    videoPlayerController?.seekTo(pos);
  }

  void seekRelative(int seconds) {
    resetAutoHideTimer();
    _seekTimer?.cancel();

    if ((seconds > 0 && showBackwardFeedback.value) ||
        (seconds < 0 && showForwardFeedback.value)) {
      seekAccumulator.value = 0;
      showForwardFeedback.value = false;
      showBackwardFeedback.value = false;
    }

    seekAccumulator.value += seconds.abs();

    if (seconds > 0) {
      showForwardFeedback.value = true;
      showBackwardFeedback.value = false;
    } else {
      showBackwardFeedback.value = true;
      showForwardFeedback.value = false;
    }

    _seekTimer = Timer(const Duration(milliseconds: 800), () {
      showForwardFeedback.value = false;
      showBackwardFeedback.value = false;
      seekAccumulator.value = 0;
    });

    final newPos = position.value + Duration(seconds: seconds);
    if (newPos < Duration.zero) {
      seekTo(Duration.zero);
    } else if (newPos > duration.value) {
      seekTo(duration.value);
    } else {
      seekTo(newPos);
    }
  }

  void toggleFullScreen() {
    if (isFullScreen.value) {
      Get.back();
      isFullScreen.value = false;
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } else {
      isFullScreen.value = true;
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);

      Get.to(
        () => Scaffold(
          backgroundColor: Colors.black,
          body: Center(child: CustomVideoPlayer()),
        ),
        transition: Transition.fadeIn,
        fullscreenDialog: true,
      )?.then((_) {
        if (isFullScreen.value) {
          isFullScreen.value = false;
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        }
      });
    }
  }

  void setSpeed(double speed) {
    resetAutoHideTimer();
    playbackSpeed.value = speed;
    videoPlayerController?.setPlaybackSpeed(speed);
  }

  void resetAutoHideTimer() {
    _hideTimer?.cancel();
    showControls.value = true;
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (isPlaying.value && !isDragging.value) {
        showControls.value = false;
      }
    });
  }

  void toggleControls() {
    showControls.value = !showControls.value;
    if (showControls.value) {
      resetAutoHideTimer();
    } else {
      _hideTimer?.cancel();
    }
  }

  void onDragStart() {
    isDragging.value = true;
    _hideTimer?.cancel();
  }

  void onDragUpdate(Duration pos) {
    position.value = pos;
  }

  void onDragEnd() {
    isDragging.value = false;
    seekTo(position.value);
    resetAutoHideTimer();
  }

  void goBackFullscreen() {
    if (isFullScreen.value) {
      toggleFullScreen();
    } else {
      Get.back();
    }
  }

  final isSubmittingReview = false.obs;

  Future<void> silentRefreshCourse(int id) async {
    try {
      final response = await _catalogApi.getCourseDetails(id);
      if (response.data['success'] == true) {
        final newCourseData = CourseModel.fromJson(response.data['data']);
        course.value = newCourseData;
      }
    } catch (_) {}
  }

  Future<bool> submitReview({required double rating, required String comment}) async {
    final c = course.value;
    if (c == null) return false;

    isSubmittingReview.value = true;
    try {
      final response = await _catalogApi.addReview(c.id, rating: rating, comment: comment);
      if (response.data['success'] == true) {
        await silentRefreshCourse(c.id);
        return true;
      }
    } on ApiException catch (e) {
      Get.snackbar(
        'error'.tr,
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      debugPrint('submitReview error: $e');
    } finally {
      isSubmittingReview.value = false;
    }
    return false;
  }

  @override
  void onClose() {
    _hideTimer?.cancel();
    _seekTimer?.cancel();
    videoPlayerController?.dispose();
    super.onClose();
  }
}
