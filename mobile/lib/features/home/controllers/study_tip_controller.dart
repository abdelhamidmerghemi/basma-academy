import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/api_exception.dart';
import '../models/study_tip_model.dart';
import '../services/study_tip_api.dart';

class StudyTipController extends GetxController {
  final StudyTipApi _studyTipApi = Get.put(StudyTipApi());

  final studyTips = <StudyTipModel>[].obs;
  final isLoading = false.obs;
  final activeBannerIndex = 0.obs;

  final PageController bannerPageController = PageController();
  Timer? _carouselTimer;

  @override
  void onInit() {
    super.onInit();
    fetchStudyTips();
    _startCarouselTimer();
  }

  @override
  void onClose() {
    _carouselTimer?.cancel();
    bannerPageController.dispose();
    super.onClose();
  }

  void _startCarouselTimer() {
    _carouselTimer = Timer.periodic(const Duration(milliseconds: 4500), (_) {
      if (!bannerPageController.hasClients) return;
      final int count = studyTips.isNotEmpty ? studyTips.length : 3;
      final next = (activeBannerIndex.value + 1) % count;
      bannerPageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  Future<void> fetchStudyTips() async {
    isLoading.value = true;
    try {
      final response = await _studyTipApi.getStudyTips();
      if (response.data['success'] == true) {
        final List list = response.data['data'] ?? [];
        studyTips.value = list.map((json) => StudyTipModel.fromJson(json)).toList();
      }
    } on ApiException catch (e) {
      debugPrint('fetchStudyTips API exception: ${e.message}');
    } catch (e) {
      debugPrint('fetchStudyTips error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
