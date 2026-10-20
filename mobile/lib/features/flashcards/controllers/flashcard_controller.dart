import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../catalog/models/subject_model.dart';
import '../../catalog/services/catalog_api.dart';
import '../models/flashcard_deck_model.dart';
import '../models/flashcard_model.dart';
import '../services/flashcard_api.dart';

class FlashcardController extends GetxController {
  final FlashcardApi _api = Get.find<FlashcardApi>();
  final CatalogApi _catalogApi = Get.put(CatalogApi());

  final decks = <FlashcardDeckModel>[].obs;
  final activeDeck = Rxn<FlashcardDeckModel>();

  final cards = <FlashcardModel>[].obs;
  final subjectsList = <SubjectModel>[].obs;
  final selectedSubjectId = RxnInt(); // null = All Subjects

  final currentIndex = 0.obs;
  final isFlipped = false.obs;
  final isLoading = false.obs;
  final isLoadingSubjects = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSubjects();
    loadFlashcardDecks();
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
      debugPrint('FlashcardController fetchSubjects error: $e');
    } finally {
      isLoadingSubjects.value = false;
    }
  }

  void selectSubjectId(int? subjectId) {
    selectedSubjectId.value = subjectId;
    activeDeck.value = null; // Reset session when switching subject filter
    loadFlashcardDecks(subjectId: subjectId);
  }

  Future<void> loadFlashcardDecks({int? subjectId}) async {
    isLoading.value = true;
    try {
      final response = await _api.getDecks(subjectId: subjectId);
      if (response.data != null && response.data['data'] != null) {
        final List rawList = response.data['data'] as List;
        final loaded = rawList.map((d) => FlashcardDeckModel.fromJson(d)).toList();
        if (loaded.isNotEmpty) {
          decks.assignAll(loaded);
        } else {
          _populateFallbackDecks(subjectId: subjectId);
        }
      } else {
        _populateFallbackDecks(subjectId: subjectId);
      }
    } catch (_) {
      _populateFallbackDecks(subjectId: subjectId);
    } finally {
      isLoading.value = false;
    }
  }

  void startDeckSession(FlashcardDeckModel deck) {
    activeDeck.value = deck;
    cards.assignAll(deck.cards);
    currentIndex.value = 0;
    isFlipped.value = false;
  }

  void exitDeckSession() {
    activeDeck.value = null;
    cards.clear();
    currentIndex.value = 0;
    isFlipped.value = false;
  }

  void toggleFlip() {
    isFlipped.value = !isFlipped.value;
  }

  Future<void> submitGrade(int grade) async {
    if (currentIndex.value >= cards.length) return;

    final currentCard = cards[currentIndex.value];
    try {
      await _api.reviewCard(currentCard.id, grade);
    } catch (_) {}

    isFlipped.value = false;

    if (currentIndex.value < cards.length - 1) {
      currentIndex.value++;
    } else {
      Get.snackbar(
        'flashcard_success_title'.tr,
        'flashcard_success_desc'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white,
      );
    }
  }

  void resetDeck() {
    currentIndex.value = 0;
    isFlipped.value = false;
  }

  void _populateFallbackDecks({int? subjectId}) {
    final allDecks = [
      FlashcardDeckModel(
        id: 1,
        subjectId: 1,
        title: 'الظواهر الكهربائية (الدارة RC و RL) ⚡',
        description: 'بطاقات مفاهيم وقوانين وشحن وتفريغ المكثفة والوشيعة وحساب τ.',
        cards: [
          FlashcardModel(
            id: 1,
            deckId: 1,
            questionText: 'ما هو ثابت الزمن τ في الدارة RC وما هي وحدته؟',
            answerText: 'هو الزمن اللازم لشحن المكثفة بنسبة 63% من قيمتها الأعظمية E، وقانونه τ = R × C ووحدته الثانية (s).',
          ),
          FlashcardModel(
            id: 2,
            deckId: 1,
            questionText: 'أكتب المعادلة التفاضلية لشحنة المكثفة q(t) أثناء الشحن؟',
            answerText: 'R × (dq/dt) + (1/C) × q = E ، وتكتب بالشكل: dq/dt + (1/τ) × q = E / R.',
          ),
        ],
      ),
      FlashcardDeckModel(
        id: 2,
        subjectId: 2,
        title: 'الدوال الأسية واللوغاريتمية وتزايد النهايات 📐',
        description: 'قوانين واشتقاق ونهايات التزايد المقارن للدوال الأسية واللوغاريتمية.',
        cards: [
          FlashcardModel(
            id: 3,
            deckId: 2,
            questionText: 'ما هي النهاية الشهيرة lim (x->+∞) (e^x / x) ؟',
            answerText: 'تساوي +∞ (التزايد المقارن يتغلب فيه الدالة الأسية على الدالة القوة).',
          ),
          FlashcardModel(
            id: 4,
            deckId: 2,
            questionText: 'ما هو مشتق الدالة f(x) = ln(u(x)) ؟',
            answerText: 'مشتقة الدالة اللوغاريتمية هي f\'(x) = u\'(x) / u(x).',
          ),
        ],
      ),
      FlashcardDeckModel(
        id: 3,
        subjectId: 3,
        title: 'التخصص الوظيفي للبروتينات والإنزيمات 🧬',
        description: 'بطاقات مراجعة للموقع الفعال العوامل المؤثرة على النشاط الإنزيمي.',
        cards: [
          FlashcardModel(
            id: 5,
            deckId: 3,
            questionText: 'ما هو الموقع الفعال للإنزيم ومما يتكون؟',
            answerText: 'هو جزء صغير من الإنزيم يتكون من عدد ونوع محدد من الأحماض الأمينية المحددة وراثياً، ويتكون من موقع التثبيت وموقع التحفيز.',
          ),
          FlashcardModel(
            id: 6,
            deckId: 3,
            questionText: 'عرف ظاهرة التركيب الضوئي ومقر حدوث المرحلة الكيموضوئية؟',
            answerText: 'ظاهرة حيوية لتحويل الطاقة الضوئية إلى طاقة كيميائية كامنة، ومقر المرحلة الكيموضوئية هو التلاكويد.',
          ),
        ],
      ),
      FlashcardDeckModel(
        id: 4,
        subjectId: 4,
        title: 'المقالات والأطروحات الفلسفية (الإدراك والذاكرة) 📝',
        description: 'مواقف ومفاهيم وأقوال الفلاسفة في مقالة العقل والمادة والإدراك.',
        cards: [
          FlashcardModel(
            id: 7,
            deckId: 4,
            questionText: 'ما هي أطروحة المذهب العقلاني في تفسير الإدراك؟',
            answerText: 'يرى العقلانيون أن الإدراك عملية عقلية ذهنية بحتة تعتمد على الحكم والعقل وليس على الحواس.',
          ),
        ],
      ),
    ];

    if (subjectId != null) {
      decks.assignAll(allDecks.where((d) => d.subjectId == subjectId).toList());
    } else {
      decks.assignAll(allDecks);
    }
  }
}
