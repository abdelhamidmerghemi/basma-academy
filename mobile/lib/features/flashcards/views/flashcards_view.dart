import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme_config.dart';
import '../../../../core/widgets/primary_button.dart';
import '../controllers/flashcard_controller.dart';
import '../models/flashcard_deck_model.dart';
import 'widgets/flashcard_3d_card_widget.dart';

class FlashcardsView extends GetView<FlashcardController> {
  const FlashcardsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final isDeckActive = controller.activeDeck.value != null;

      return PopScope(
        canPop: !isDeckActive,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && isDeckActive) {
            controller.exitDeckSession();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Builder(
              builder: (context) {
                final activeDeck = controller.activeDeck.value;
                final title = activeDeck != null
                    ? activeDeck.title
                    : 'flashcards_title'.tr;
                return Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ).withArabicCheck(title),
                );
              },
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: theme.scaffoldBackgroundColor,
            leading: isDeckActive
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () {
                      controller.exitDeckSession();
                    },
                  )
                : null,
          ),
          body: Obx(() {
            if (controller.activeDeck.value != null) {
              return _buildFlashcardsReviewSession(context, theme);
            }
            return _buildDecksListDashboard(context, theme);
          }),
        ),
      );
    });
  }

  Widget _buildDecksListDashboard(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Obx(() {
            final activeId = controller.selectedSubjectId.value;

            return Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    selected: activeId == null,
                    showCheckmark: false,
                    avatar: activeId == null
                        ? const Icon(
                            Icons.check_rounded,
                            size: 15,
                            color: Colors.white,
                          )
                        : null,
                    label: Text(
                      'all_subjects_filter'.tr.isNotEmpty
                          ? 'all_subjects_filter'.tr
                          : 'الكل',
                      style: TextStyle(
                        color: activeId == null
                            ? Colors.white
                            : theme.textTheme.bodyMedium?.color,
                        fontWeight: activeId == null
                            ? FontWeight.bold
                            : FontWeight.w600,
                        fontSize: 12.5,
                      ).withArabicCheck('all_subjects_filter'.tr),
                    ),
                    selectedColor: theme.primaryColor,
                    backgroundColor: theme.cardColor,
                    side: BorderSide(
                      color: activeId == null
                          ? theme.primaryColor
                          : theme.dividerColor,
                    ),
                    onSelected: (_) {
                      HapticFeedback.lightImpact();
                      controller.selectSubjectId(null);
                    },
                  ),
                ),

                ...controller.subjectsList.map((subj) {
                  final isSelected = activeId == subj.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      selected: isSelected,
                      showCheckmark: false,
                      avatar: isSelected
                          ? const Icon(
                              Icons.check_rounded,
                              size: 15,
                              color: Colors.white,
                            )
                          : null,
                      label: Text(
                        subj.name,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : theme.textTheme.bodyMedium?.color,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w600,
                          fontSize: 12.5,
                        ).withArabicCheck(subj.name),
                      ),
                      selectedColor: theme.primaryColor,
                      backgroundColor: theme.cardColor,
                      side: BorderSide(
                        color: isSelected
                            ? theme.primaryColor
                            : theme.dividerColor,
                      ),
                      onSelected: (_) {
                        HapticFeedback.lightImpact();
                        controller.selectSubjectId(subj.id);
                      },
                    ),
                  );
                }),
              ],
            );
          }),
        ),

        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.decks.isEmpty) {
              return Center(
                child: Text(
                  'no_flashcards'.tr,
                  style:
                      (theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey,
                              ) ??
                              const TextStyle())
                          .withArabicCheck('no_flashcards'.tr),
                ),
              );
            }

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 20),
              itemCount: controller.decks.length,
              itemBuilder: (context, index) {
                final deck = controller.decks[index];
                return _buildDeckCardItem(context, theme, deck);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDeckCardItem(
    BuildContext context,
    ThemeData theme,
    FlashcardDeckModel deck,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            HapticFeedback.lightImpact();
            controller.startDeckSession(deck);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.dividerColor.withOpacity(0.8),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'flashcard_deck_label'.tr,
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11.5,
                        ).withArabicCheck('flashcard_deck_label'.tr),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Text(
                  deck.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      (theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                height: 1.35,
                              ) ??
                              const TextStyle())
                          .withArabicCheck(deck.title),
                ),

                if (deck.description != null &&
                    deck.description!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    deck.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        (theme.textTheme.bodySmall?.copyWith(
                                  color: theme.hintColor,
                                  fontSize: 12.5,
                                ) ??
                                const TextStyle())
                            .withArabicCheck(deck.description!),
                  ),
                ],

                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.layers,
                          size: 14,
                          color: theme.hintColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${deck.cards.length} ${'flashcard_count'.tr}',
                          style: TextStyle(
                            color: theme.hintColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ).withArabicCheck('flashcard_count'.tr),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: theme.primaryColor.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'start_review'.tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ).withArabicCheck('start_review'.tr),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlashcardsReviewSession(BuildContext context, ThemeData theme) {
    if (controller.cards.isEmpty) {
      return Center(
        child: Text(
          'no_flashcards'.tr,
          style: (theme.textTheme.bodyMedium ?? const TextStyle())
              .withArabicCheck('no_flashcards'.tr),
        ),
      );
    }

    final isCompletedAll =
        controller.currentIndex.value >= controller.cards.length;

    if (isCompletedAll) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.stars_rounded,
              size: 80,
              color: ThemeConfig.primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              'flashcards_completed_title'.tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ).withArabicCheck('flashcards_completed_title'.tr),
            ),
            const SizedBox(height: 8),
            Text(
              'flashcards_completed_desc'.tr,
              style: const TextStyle(
                color: Colors.grey,
              ).withArabicCheck('flashcards_completed_desc'.tr),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () => controller.exitDeckSession(),
                  icon: const Icon(CupertinoIcons.arrow_left),
                  label: Text(
                    'back_to_decks'.tr,
                    style: const TextStyle().withArabicCheck(
                      'back_to_decks'.tr,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    text: 'restart_review'.tr,
                    onPressed: () => controller.resetDeck(),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    final currentCard = controller.cards[controller.currentIndex.value];
    final progressRatio =
        (controller.currentIndex.value + 1) / controller.cards.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progressRatio,
                    minHeight: 8,
                    backgroundColor: ThemeConfig.primaryColor.withOpacity(0.12),
                    color: ThemeConfig.primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${controller.currentIndex.value + 1} / ${controller.cards.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Expanded(
            child: Flashcard3dCardWidget(
              card: currentCard,
              isFlipped: controller.isFlipped.value,
              onTap: () => controller.toggleFlip(),
            ),
          ),

          const SizedBox(height: 24),

          if (controller.isFlipped.value)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildGradeButton(
                  context,
                  label: 'grade_hard'.tr,
                  grade: 1,
                  color: Colors.red,
                ),
                _buildGradeButton(
                  context,
                  label: 'grade_medium'.tr,
                  grade: 3,
                  color: Colors.amber.shade800,
                ),
                _buildGradeButton(
                  context,
                  label: 'grade_easy'.tr,
                  grade: 5,
                  color: Colors.green,
                ),
              ],
            )
          else
            OutlinedButton.icon(
              onPressed: () => controller.toggleFlip(),
              icon: const Icon(Icons.flip_rounded),
              label: Text(
                'show_answer'.tr,
                style: const TextStyle().withArabicCheck('show_answer'.tr),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildGradeButton(
    BuildContext context, {
    required String label,
    required int grade,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: () => controller.submitGrade(grade),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.12),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: color.withOpacity(0.3)),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12.5,
        ).withArabicCheck(label),
      ),
    );
  }
}
