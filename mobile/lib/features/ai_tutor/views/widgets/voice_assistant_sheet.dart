import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../controllers/ai_tutor_controller.dart';
import 'voice_waveform_painter.dart';

class VoiceAssistantSheet extends StatefulWidget {
  const VoiceAssistantSheet({super.key});

  @override
  State<VoiceAssistantSheet> createState() => _VoiceAssistantSheetState();
}

class _VoiceAssistantSheetState extends State<VoiceAssistantSheet> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  final AiTutorController controller = Get.find<AiTutorController>();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.voiceState.value == VoiceState.idle) {
        controller.startVoiceListening();
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'voice_assistant_title'.tr,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              IconButton(
                icon: const Icon(CupertinoIcons.xmark_circle_fill),
                color: theme.textTheme.bodySmall?.color,
                onPressed: () {
                  controller.stopVoiceListening();
                  controller.stopSpeaking();
                  Get.back();
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          Obx(() {
            final state = controller.voiceState.value;
            final isListening = state == VoiceState.listening;
            final isSpeaking = state == VoiceState.speaking;
            final isThinking = state == VoiceState.thinking;

            return Column(
              children: [
                SizedBox(
                  width: 220,
                  height: 220,
                  child: AnimatedBuilder(
                    animation: _animController,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: VoiceWaveformPainter(
                          animationValue: _animController.value,
                          soundLevel: controller.soundLevel.value,
                          primaryColor: primaryColor,
                          isSpeaking: isSpeaking,
                          isListening: isListening,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isListening
                        ? const Color(0xFFF59E0B).withOpacity(0.15)
                        : (isSpeaking
                            ? const Color(0xFF10B981).withOpacity(0.15)
                            : (isThinking
                                ? primaryColor.withOpacity(0.15)
                                : theme.dividerColor.withOpacity(0.2))),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isListening
                          ? const Color(0xFFF59E0B)
                          : (isSpeaking ? const Color(0xFF10B981) : primaryColor),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isThinking)
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else
                        Icon(
                          isListening
                              ? CupertinoIcons.mic_fill
                              : (isSpeaking ? CupertinoIcons.speaker_2_fill : CupertinoIcons.mic),
                          size: 16,
                          color: isListening
                              ? const Color(0xFFF59E0B)
                              : (isSpeaking ? const Color(0xFF10B981) : primaryColor),
                        ),
                      const SizedBox(width: 8),
                      Text(
                        isListening
                            ? 'voice_listening'.tr
                            : (isSpeaking
                                ? 'voice_speaking'.tr
                                : (isThinking ? 'voice_thinking'.tr : 'voice_tap_to_speak'.tr)),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isListening
                              ? const Color(0xFFF59E0B)
                              : (isSpeaking ? const Color(0xFF10B981) : primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 60, maxHeight: 100),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      controller.voiceTranscript.value.isNotEmpty
                          ? controller.voiceTranscript.value
                          : (isListening ? '...' : ''),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                GestureDetector(
                  onTap: () {
                    if (isListening) {
                      controller.stopVoiceListening();
                    } else if (isSpeaking) {
                      controller.stopSpeaking();
                    } else {
                      controller.startVoiceListening();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    decoration: BoxDecoration(
                      color: isListening ? Colors.redAccent : primaryColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: (isListening ? Colors.redAccent : primaryColor).withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isListening
                              ? CupertinoIcons.stop_fill
                              : (isSpeaking ? CupertinoIcons.stop_fill : CupertinoIcons.mic_fill),
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isListening
                              ? 'voice_tap_to_stop'.tr
                              : (isSpeaking ? 'voice_tap_to_stop'.tr : 'voice_tap_to_speak'.tr),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
