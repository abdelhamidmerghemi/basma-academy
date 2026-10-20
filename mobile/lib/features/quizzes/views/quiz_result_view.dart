import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme_config.dart';
import '../../../../core/theme/premium_interactions.dart';
import '../../../../core/widgets/primary_button.dart';
import '../controllers/quiz_controller.dart';
import '../models/quiz_result_model.dart';

class QuizResultView extends StatelessWidget {
  final QuizResultModel result;

  const QuizResultView({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<QuizController>();

    final isPassed = result.passed;
    final primaryColor = isPassed ? Colors.green.shade600 : Colors.redAccent;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isPassed
                    ? [Colors.green.shade700, Colors.teal.shade600]
                    : [Colors.red.shade700, Colors.redAccent.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPassed ? Icons.workspace_premium_rounded : Icons.cancel_outlined,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isPassed ? 'quiz_passed'.tr : 'quiz_failed'.tr,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ).withArabicCheck('quiz_passed'.tr),
                ),
                const SizedBox(height: 8),
                Text(
                  '${'score_label'.tr}: ${result.score}%',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ).withArabicCheck('score_label'.tr),
                ),
                const SizedBox(height: 8),
                Text(
                  '${result.correctCount} / ${result.totalQuestions} ${'correct_questions'.tr}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ).withArabicCheck('correct_questions'.tr),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'answer_breakdown'.tr,
              style: (theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ) ?? const TextStyle()).withArabicCheck('answer_breakdown'.tr),
            ),
          ),
          const SizedBox(height: 12),

          ...result.breakdown.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: item.isCorrect ? Colors.green.withOpacity(0.3) : Colors.redAccent.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        item.isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                        color: item.isCorrect ? Colors.green : Colors.redAccent,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item.questionText,
                          style: (theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.5,
                          ) ?? const TextStyle()).withArabicCheck(item.questionText),
                        ),
                      ),
                    ],
                  ),
                  if (item.explanation != null && item.explanation!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.primaryColor.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.lightbulb_outline_rounded,
                            size: 18,
                            color: theme.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.explanation!,
                              style: (theme.textTheme.bodySmall?.copyWith(
                                color: theme.textTheme.bodyLarge?.color,
                                height: 1.4,
                              ) ?? const TextStyle()).withArabicCheck(item.explanation!),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    HapticHelper.lightTap();
                    Get.back();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'close'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold).withArabicCheck('close'.tr),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  text: 'retake_quiz'.tr,
                  onPressed: () {
                    HapticHelper.lightTap();
                    controller.resetQuiz();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
