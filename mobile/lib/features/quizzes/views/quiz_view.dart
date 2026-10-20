import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_config.dart';
import '../../../core/theme/premium_interactions.dart';
import '../../../core/widgets/primary_button.dart';
import '../controllers/quiz_controller.dart';
import 'quiz_result_view.dart';

class QuizView extends GetView<QuizController> {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final isQuizActive = controller.currentQuiz.value != null;

      return PopScope(
        canPop: !isQuizActive,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && isQuizActive) {
            controller.currentQuiz.value = null;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Builder(
              builder: (context) {
                final quiz = controller.currentQuiz.value;
                final title = quiz != null
                    ? quiz.title
                    : 'quizzes_list_title'.tr;
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
            leading: isQuizActive
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () {
                      controller.currentQuiz.value = null;
                    },
                  )
                : null,
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final result = controller.quizResult.value;
            if (result != null) {
              return QuizResultView(result: result);
            }

            final quiz = controller.currentQuiz.value;
            if (quiz == null) {
              return _buildQuizSelectionList(context, theme);
            }

            if (quiz.questions.isEmpty) {
              return Center(
                child: Text(
                  'no_quiz_questions'.tr,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
              );
            }

            final currentIdx = controller.currentQuestionIndex.value;
            final question = quiz.questions[currentIdx];
            final totalQuestions = quiz.questions.length;
            final progress = (currentIdx + 1) / totalQuestions;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${currentIdx + 1} / $totalQuestions',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                          if (quiz.timeLimitMinutes > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: ThemeConfig.accentAmber.withOpacity(
                                  0.12,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: ThemeConfig.accentAmber.withOpacity(
                                    0.4,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.timer_outlined,
                                    size: 16,
                                    color: ThemeConfig.accentAmber,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    controller.formattedRemainingTime,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: ThemeConfig.accentAmber,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: theme.dividerColor.withOpacity(0.2),
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: theme.dividerColor,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  '${question.points} ${'points'.tr}',
                                  style:
                                      (theme.textTheme.bodySmall?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: theme.primaryColor,
                                                fontSize: 11,
                                              ) ??
                                              const TextStyle())
                                          .withArabicCheck('points'.tr),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                question.questionText,
                                style:
                                    (theme.textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                              height: 1.5,
                                            ) ??
                                            const TextStyle())
                                        .withArabicCheck(question.questionText),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        ...question.answers.map((answer) {
                          final isSelected =
                              controller.selectedAnswers[question.id] ==
                              answer.id;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: InkWell(
                              onTap: () {
                                HapticHelper.lightTap();
                                controller.selectAnswer(question.id, answer.id);
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? theme.primaryColor.withOpacity(0.12)
                                      : theme.cardColor,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? theme.primaryColor
                                        : theme.dividerColor,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected
                                            ? theme.primaryColor
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: isSelected
                                              ? theme.primaryColor
                                              : theme
                                                        .textTheme
                                                        .bodySmall
                                                        ?.color ??
                                                    Colors.grey,
                                          width: 2,
                                        ),
                                      ),
                                      child: isSelected
                                          ? const Icon(
                                              Icons.check_rounded,
                                              size: 16,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Text(
                                        answer.answerText,
                                        style:
                                            (theme.textTheme.bodyMedium
                                                        ?.copyWith(
                                                          fontWeight: isSelected
                                                              ? FontWeight.bold
                                                              : FontWeight
                                                                    .normal,
                                                          color: isSelected
                                                              ? theme
                                                                    .primaryColor
                                                              : theme
                                                                    .textTheme
                                                                    .bodyLarge
                                                                    ?.color,
                                                          fontSize: 14.5,
                                                        ) ??
                                                    const TextStyle())
                                                .withArabicCheck(
                                                  answer.answerText,
                                                ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        if (currentIdx > 0)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                HapticHelper.lightTap();
                                controller.previousQuestion();
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                'previous'.tr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ).withArabicCheck('previous'.tr),
                              ),
                            ),
                          ),
                        if (currentIdx > 0) const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: PrimaryButton(
                            text: currentIdx == totalQuestions - 1
                                ? 'submit_quiz'.tr
                                : 'next_question'.tr,
                            isLoading: controller.isSubmitting.value,
                            onPressed: () {
                              HapticHelper.lightTap();
                              if (currentIdx < totalQuestions - 1) {
                                controller.nextQuestion();
                              } else {
                                controller.submitQuiz();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      );
    });
  }

  Widget _buildQuizSelectionList(BuildContext context, ThemeData theme) {
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
                      ).withArabicCheck('الكل'),
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
                }).toList(),
              ],
            );
          }),
        ),

        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.quizzesList.isEmpty) {
              return Center(
                child: Text(
                  'no_quizzes_available'.tr,
                  style:
                      (theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey,
                              ) ??
                              const TextStyle())
                          .withArabicCheck('no_quizzes_available'.tr),
                ),
              );
            }

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 20),
              itemCount: controller.quizzesList.length,
              itemBuilder: (context, index) {
                final quiz = controller.quizzesList[index];
                final qCount = quiz.questionsCount > 0
                    ? quiz.questionsCount
                    : quiz.questions.length;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        controller.loadQuiz(quiz.id);
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
                                    'quiz_label'.tr,
                                    style: TextStyle(
                                      color: theme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.5,
                                    ).withArabicCheck('quiz_label'.tr),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 9,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: theme.dividerColor,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        CupertinoIcons.timer,
                                        size: 12,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${quiz.timeLimitMinutes} ${'minutes_label'.tr}',
                                        style: TextStyle(
                                          color:
                                              theme.textTheme.bodySmall?.color,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ).withArabicCheck('minutes_label'.tr),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              quiz.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  (theme.textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            height: 1.35,
                                          ) ??
                                          const TextStyle())
                                      .withArabicCheck(quiz.title),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.doc_text,
                                      size: 14,
                                      color: theme.hintColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '$qCount ${'questions_count_label'.tr}',
                                      style:
                                          TextStyle(
                                            color: theme.hintColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ).withArabicCheck(
                                            'questions_count_label'.tr,
                                          ),
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
                                        color: theme.primaryColor.withOpacity(
                                          0.25,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'start_quiz'.tr,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ).withArabicCheck('start_quiz'.tr),
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
              },
            );
          }),
        ),
      ],
    );
  }
}
