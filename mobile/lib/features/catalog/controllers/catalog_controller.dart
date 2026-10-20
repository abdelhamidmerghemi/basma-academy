import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/api_exception.dart';
import '../../auth/controllers/auth_controller.dart';
import '../models/subject_model.dart';
import '../models/course_model.dart';
import '../services/catalog_api.dart';

class CatalogController extends GetxController {
  final CatalogApi _catalogApi = Get.put(CatalogApi());

  final subjects = <SubjectModel>[].obs;
  final courses = <CourseModel>[].obs;

  final isLoadingSubjects = false.obs;
  final isLoadingCourses = false.obs;

  final selectedSubjectId = Rxn<int>();
  final selectedContentType =
      'all'.obs; // 'all', 'full_course', 'exercises', 'summaries'
  final sortBy = 'newest'.obs; // 'newest', 'popular', 'rating'

  bool get hasActiveFilters =>
      selectedSubjectId.value != null ||
      sortBy.value != 'newest';

  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  Timer? _searchDebounce;

  final aiMotivationQuote = ''.obs;
  final List<String> _motivationQuotes = [
    "quote_1",
    "quote_2",
    "quote_3",
    "quote_4",
    "quote_5",
  ];

  final aiStreamStudyTip = ''.obs;
  final Map<String, List<String>> _streamTips = {
    'BAC_Sciences': [
      "tip_BAC_Sciences_1",
      "tip_BAC_Sciences_2",
      "tip_BAC_Sciences_3",
    ],
    'BAC_Maths': ["tip_BAC_Maths_1", "tip_BAC_Maths_2", "tip_BAC_Maths_3"],
    'BAC_Technique': ["tip_BAC_Technique_1", "tip_BAC_Technique_2"],
    'BAC_Lettres': ["tip_BAC_Lettres_1", "tip_BAC_Lettres_2"],
    'BAC_Languages': ["tip_BAC_Languages_1", "tip_BAC_Languages_2"],
    'BAC_Gestion': ["tip_BAC_Gestion_1", "tip_BAC_Gestion_2"],
  };

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(_onSearchChanged);
    refreshMotivationQuote();
    refreshStreamStudyTip();
    fetchSubjects();
    fetchCourses();
  }

  String get currentGreetingKey {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'good_morning';
    } else if (hour >= 12 && hour < 18) {
      return 'good_afternoon';
    } else {
      return 'good_evening';
    }
  }

  void refreshMotivationQuote() {
    final random = Random();
    final nextIndex = random.nextInt(_motivationQuotes.length);
    aiMotivationQuote.value = _motivationQuotes[nextIndex].tr;
  }

  void refreshStreamStudyTip() {
    final authCtrl = Get.find<AuthController>();
    final stream = authCtrl.selectedStream.value.isNotEmpty
        ? authCtrl.selectedStream.value
        : 'BAC_Sciences';

    final tipsList = _streamTips[stream] ?? _streamTips['BAC_Sciences']!;
    final random = Random();
    final key = tipsList[random.nextInt(tipsList.length)];
    aiStreamStudyTip.value = key.tr;
  }

  void _onSearchChanged() {
    searchQuery.value = searchController.text;
    if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      fetchCourses();
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    _searchDebounce?.cancel();
    super.onClose();
  }

  Future<void> fetchSubjects() async {
    isLoadingSubjects.value = true;
    try {
      final authCtrl = Get.find<AuthController>();
      final stream = authCtrl.selectedStream.value.isNotEmpty
          ? authCtrl.selectedStream.value
          : authCtrl.currentUser.value?.academicStream ?? '';

      final Map<String, dynamic> query = {};
      if (stream.isNotEmpty) {
        query['stream_code'] = stream;
      }

      final response = await _catalogApi.getSubjects(query);
      if (response.data['success'] == true) {
        final List list = response.data['data'] ?? [];
        subjects.value = list
            .map((json) => SubjectModel.fromJson(json))
            .toList();
      }
    } on ApiException catch (e) {
      debugPrint('fetchSubjects API exception: ${e.message}');
    } catch (e) {
      debugPrint('fetchSubjects error: $e');
    } finally {
      isLoadingSubjects.value = false;
    }
  }

  Future<void> fetchCourses() async {
    isLoadingCourses.value = true;
    try {
      final authCtrl = Get.find<AuthController>();
      final stream = authCtrl.selectedStream.value.isNotEmpty
          ? authCtrl.selectedStream.value
          : authCtrl.currentUser.value?.academicStream ?? '';

      final Map<String, dynamic> query = {};
      if (stream.isNotEmpty) {
        query['stream_code'] = stream;
      }
      if (selectedSubjectId.value != null) {
        query['subject_id'] = selectedSubjectId.value;
      }
      // Content type filter removed — 'type' column does not exist on courses table
      query['sort_by'] = sortBy.value;

      final search = searchController.text.trim();
      if (search.isNotEmpty) {
        query['search'] = search;
      }

      final response = await _catalogApi.getCourses(query);
      if (response.data['success'] == true) {
        final List list = response.data['data'] ?? [];
        courses.value = list.map((json) => CourseModel.fromJson(json)).toList();
      }
    } on ApiException catch (e) {
      debugPrint('fetchCourses API exception: ${e.message}');
    } catch (e) {
      debugPrint('fetchCourses error: $e');
    } finally {
      isLoadingCourses.value = false;
    }
  }

  void filterBySubject(int? subjectId) {
    if (selectedSubjectId.value == subjectId) {
      selectedSubjectId.value = null;
    } else {
      selectedSubjectId.value = subjectId;
    }
    fetchCourses();
  }

  void resetFilters() {
    selectedSubjectId.value = null;
    selectedContentType.value = 'all';
    sortBy.value = 'newest';
    fetchCourses();
  }
}
