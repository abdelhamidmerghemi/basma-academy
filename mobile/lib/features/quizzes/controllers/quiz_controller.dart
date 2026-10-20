import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/network/api_exception.dart';
import '../../catalog/models/subject_model.dart';
import '../../catalog/services/catalog_api.dart';
import '../models/quiz_model.dart';
import '../models/quiz_question_model.dart';
import '../models/quiz_answer_model.dart';
import '../models/quiz_result_model.dart';
import '../services/quiz_api.dart';

class QuizController extends GetxController {
  final QuizApi _api = Get.put(QuizApi());
  final CatalogApi _catalogApi = Get.put(CatalogApi());

  final isLoading = false.obs;
  final isLoadingSubjects = false.obs;
  final isSubmitting = false.obs;

  final subjectsList = <SubjectModel>[].obs;
  final selectedSubjectId = RxnInt(); // null = All Subjects

  final quizzesList = <QuizModel>[].obs;
  final currentQuiz = Rxn<QuizModel>();
  final currentQuestionIndex = 0.obs;
  final selectedAnswers = <int, int>{}.obs; // questionId -> answerId

  final quizResult = Rxn<QuizResultModel>();

  Timer? _timer;
  final remainingSeconds = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSubjects();
    fetchQuizzes();
    currentQuiz.value = null;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> fetchSubjects() async {
    isLoadingSubjects.value = true;
    try {
      final response = await _catalogApi.getSubjects({});
      if (response.data != null && response.data['data'] != null) {
        final List list = response.data['data'] as List;
        final loaded = list.map((s) => SubjectModel.fromJson(s)).toList();
        subjectsList.assignAll(loaded);
      }
    } catch (e) {
      debugPrint('QuizController fetchSubjects error: $e');
    } finally {
      isLoadingSubjects.value = false;
    }
  }

  void selectSubjectId(int? subjectId) {
    selectedSubjectId.value = subjectId;
    fetchQuizzes(subjectId: subjectId);
  }

  Future<void> fetchQuizzes({int? subjectId}) async {
    isLoading.value = true;
    try {
      final response = await _api.getQuizzes(subjectId: subjectId);
      if (response.data != null && response.data['data'] != null) {
        final List list = response.data['data'] as List;
        final loaded = list.map((q) => QuizModel.fromJson(q)).toList();
        if (loaded.isNotEmpty) {
          quizzesList.assignAll(loaded);
        } else {
          _populateMockQuizzes(subjectId: subjectId);
        }
      } else {
        _populateMockQuizzes(subjectId: subjectId);
      }
    } catch (_) {
      _populateMockQuizzes(subjectId: subjectId);
    } finally {
      isLoading.value = false;
    }
  }

  void _populateMockQuizzes({int? subjectId}) {
    final all = [
      (
        subjectId: 1,
        quiz: QuizModel(
          id: 1,
          lessonId: 1,
          title: 'اختبار العلوم الفيزيائية — المتابعة الزمنية لتحول كيميائي',
          timeLimitMinutes: 15,
          questionsCount: 3,
          questions: [
            QuizQuestionModel(
              id: 101,
              quizId: 1,
              questionText: 'ما هي وحدة الناقلية النوعية σ في الجملة الدولية للوحدات؟',
              points: 2,
              sortOrder: 1,
              answers: [
                QuizAnswerModel(id: 1, questionId: 101, answerText: 'S.m⁻¹ (سيمانس على المتر)'),
                QuizAnswerModel(id: 2, questionId: 101, answerText: 'S/cm'),
                QuizAnswerModel(id: 3, questionId: 101, answerText: 'Ohm.m'),
              ],
            ),
            QuizQuestionModel(
              id: 102,
              quizId: 1,
              questionText: 'عند زيادة درجة الحرارة الابتدائية للجملة الكيميائية، فإن زمن نصف التفاعل t1/2:',
              points: 2,
              sortOrder: 2,
              answers: [
                QuizAnswerModel(id: 4, questionId: 102, answerText: 'ينقص وتزداد سرعة التفاعل'),
                QuizAnswerModel(id: 5, questionId: 102, answerText: 'يزداد وتتباطأ السرعة'),
                QuizAnswerModel(id: 6, questionId: 102, answerText: 'يبقى ثابتاً ولا يتأثر'),
              ],
            ),
            QuizQuestionModel(
              id: 103,
              quizId: 1,
              questionText: 'دور الوسيط في التفاعل الكيميائي هو:',
              points: 2,
              sortOrder: 3,
              answers: [
                QuizAnswerModel(id: 7, questionId: 103, answerText: 'تسريع التفاعل دون التأثير على الحالة النهائية للجملة'),
                QuizAnswerModel(id: 8, questionId: 103, answerText: 'زيادة كمية المادة النهائية المتشكلة'),
                QuizAnswerModel(id: 9, questionId: 103, answerText: 'تأخير حدوث التوازن الكيميائي'),
              ],
            ),
          ],
        ),
      ),
      (
        subjectId: 2,
        quiz: QuizModel(
          id: 2,
          lessonId: 2,
          title: 'اختبار الرياضيات — دراسة المتتاليات وحساب النهايات',
          timeLimitMinutes: 20,
          questionsCount: 2,
          questions: [
            QuizQuestionModel(
              id: 201,
              quizId: 2,
              questionText: 'إذا كانت المتتالية Un متزايدة ومحدودة من الأعلى بـ L، فإنها:',
              points: 2,
              sortOrder: 1,
              answers: [
                QuizAnswerModel(id: 10, questionId: 201, answerText: 'متقاربة ونهايتها تساوي L أو أقل'),
                QuizAnswerModel(id: 11, questionId: 201, answerText: 'متباعدة وتؤول إلى +∞'),
                QuizAnswerModel(id: 12, questionId: 201, answerText: 'متناقصة تماماً'),
              ],
            ),
            QuizQuestionModel(
              id: 202,
              quizId: 2,
              questionText: 'عبارة الحد العام لمتتالية هندسية أساسها q وحدها الأول U0 هي:',
              points: 2,
              sortOrder: 2,
              answers: [
                QuizAnswerModel(id: 13, questionId: 202, answerText: 'Un = U0 × qⁿ'),
                QuizAnswerModel(id: 14, questionId: 202, answerText: 'Un = U0 + n × q'),
                QuizAnswerModel(id: 15, questionId: 202, answerText: 'Un = qⁿ / U0'),
              ],
            ),
          ],
        ),
      ),
      (
        subjectId: 3,
        quiz: QuizModel(
          id: 3,
          lessonId: 3,
          title: 'اختبار علوم الطبيعة والحياة — النشاط الإنزيمي والتركيب الضوئي',
          timeLimitMinutes: 15,
          questionsCount: 1,
          questions: [
            QuizQuestionModel(
              id: 301,
              quizId: 3,
              questionText: 'مقر المرحلة الكيموضوئية للتركيب الضوئي هو:',
              points: 2,
              sortOrder: 1,
              answers: [
                QuizAnswerModel(id: 16, questionId: 301, answerText: 'غشاء التيلاكويد (Thylakoid Membrane)'),
                QuizAnswerModel(id: 17, questionId: 301, answerText: 'حشوة الصانعة الخضراء (Stroma)'),
                QuizAnswerModel(id: 18, questionId: 301, answerText: 'الغشاء الداخلي للميتوكندريا'),
              ],
            ),
          ],
        ),
      ),
      (
        subjectId: 4,
        quiz: QuizModel(
          id: 4,
          lessonId: 4,
          title: 'اختبار الفلسفة — إشكالية الإدراك والمذاهب الفلسفية',
          timeLimitMinutes: 10,
          questionsCount: 1,
          questions: [
            QuizQuestionModel(
              id: 401,
              quizId: 4,
              questionText: 'المذهب الفلسفي الذي يرجع الإدراك إلى نشاط العقل والعمليات الذهنية هو:',
              points: 2,
              sortOrder: 1,
              answers: [
                QuizAnswerModel(id: 19, questionId: 401, answerText: 'المذهب العقلاني (Rationalism)'),
                QuizAnswerModel(id: 20, questionId: 401, answerText: 'المذهب الحسي (Empiricism)'),
                QuizAnswerModel(id: 21, questionId: 401, answerText: 'المذهب الجشطالتي'),
              ],
            ),
          ],
        ),
      ),
    ];

    if (subjectId != null) {
      quizzesList.assignAll(all.where((e) => e.subjectId == subjectId).map((e) => e.quiz).toList());
    } else {
      quizzesList.assignAll(all.map((e) => e.quiz).toList());
    }
  }

  Future<void> loadQuiz(int quizId) async {
    isLoading.value = true;
    currentQuestionIndex.value = 0;
    selectedAnswers.clear();
    quizResult.value = null;
    _timer?.cancel();

    try {
      final response = await _api.getQuiz(quizId);
      if (response.data['success'] == true && response.data['data'] != null) {
        currentQuiz.value = QuizModel.fromJson(response.data['data']);
        
        final minutes = currentQuiz.value?.timeLimitMinutes ?? 0;
        if (minutes > 0) {
          remainingSeconds.value = minutes * 60;
          _startTimer();
        }
      }
    } on ApiException catch (e) {
      Get.snackbar(
        'error'.tr,
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('loadQuiz error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        timer.cancel();
        submitQuiz(); // Auto submit on timeout
      }
    });
  }

  String get formattedRemainingTime {
    final minutes = remainingSeconds.value ~/ 60;
    final seconds = remainingSeconds.value % 60;
    final mStr = minutes.toString().padLeft(2, '0');
    final sStr = seconds.toString().padLeft(2, '0');
    return '$mStr:$sStr';
  }

  void selectAnswer(int questionId, int answerId) {
    selectedAnswers[questionId] = answerId;
  }

  void nextQuestion() {
    final max = (currentQuiz.value?.questions.length ?? 1) - 1;
    if (currentQuestionIndex.value < max) {
      currentQuestionIndex.value++;
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
    }
  }

  Future<void> submitQuiz() async {
    final quiz = currentQuiz.value;
    if (quiz == null || isSubmitting.value) return;

    _timer?.cancel();
    isSubmitting.value = true;

    try {
      final response = await _api.submitQuiz(quiz.id, selectedAnswers);
      if (response.data['success'] == true && response.data['data'] != null) {
        quizResult.value = QuizResultModel.fromJson(response.data['data']);
      }
    } on ApiException catch (e) {
      Get.snackbar(
        'error'.tr,
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('submitQuiz error: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  void resetQuiz() {
    currentQuestionIndex.value = 0;
    selectedAnswers.clear();
    quizResult.value = null;
    final quizId = currentQuiz.value?.id;
    if (quizId != null) {
      loadQuiz(quizId);
    }
  }
}
