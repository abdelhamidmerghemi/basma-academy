import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import '../../../core/network/api_exception.dart';
import '../../auth/controllers/auth_controller.dart';
import '../models/chat_message_model.dart';
import '../services/ai_tutor_api.dart';

enum VoiceState { idle, listening, thinking, speaking }

class AiTutorController extends GetxController {
  final AiTutorApi _api = Get.find<AiTutorApi>();
  final AuthController _authController = Get.find<AuthController>();

  final textController = TextEditingController();
  final scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  final messages = <ChatMessageModel>[].obs;
  final isGenerating = false.obs;
  final isLoadingHistory = false.obs;
  final selectedImagePath = ''.obs;

  // Voice Assistant reactive state
  final Rx<VoiceState> voiceState = VoiceState.idle.obs;
  final RxDouble soundLevel = 0.0.obs;
  final RxString voiceTranscript = ''.obs;

  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _speechInitialized = false;
  bool _isStoppingVoice = false;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
    _initVoiceEngine();
  }

  Future<void> _initVoiceEngine() async {
    try {
      await _flutterTts.setLanguage(
        Get.locale?.languageCode == 'fr' ? 'fr-FR' : 'ar-SA',
      );
      await _flutterTts.setSpeechRate(0.48);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      _flutterTts.setCompletionHandler(() {
        voiceState.value = VoiceState.idle;
      });
      _flutterTts.setErrorHandler((msg) {
        voiceState.value = VoiceState.idle;
      });
    } catch (e) {
      debugPrint('_initVoiceEngine error: $e');
    }
  }

    Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1600,
      );
      if (photo != null) {
        selectedImagePath.value = photo.path;
      }
    } catch (e) {
      debugPrint('pickImage error: $e');
      Get.snackbar('error'.tr, 'photo_pick_failed'.tr);
    }
  }

    void clearSelectedImage() {
    selectedImagePath.value = '';
  }

    Future<void> fetchHistory() async {
    try {
      isLoadingHistory.value = true;
      final response = await _api.getHistory();
      if (response.data != null && response.data['success'] == true) {
        final List rawMessages = response.data['data']?['messages'] ?? [];
        if (rawMessages.isNotEmpty) {
          final loaded = rawMessages.map((m) {
            final isUser = m['sender_type'] == 'user';
            return ChatMessageModel(
              id: m['id'].toString(),
              text: m['content_text'] ?? '',
              sender: isUser ? MessageSender.user : MessageSender.ai,
              attachmentPath: m['attachment_url'] ?? m['attachment_path'],
              timestamp: m['created_at'] != null
                  ? DateTime.tryParse(m['created_at'].toString()) ??
                        DateTime.now()
                  : DateTime.now(),
            );
          }).toList();
          messages.value = loaded;
          _scrollToBottom();
          return;
        }
      }
    } catch (e) {
      debugPrint('fetchHistory error: $e');
    } finally {
      isLoadingHistory.value = false;
    }

    // Fallback if no history exists yet
    if (messages.isEmpty) {
      _addInitialWelcomeMessage();
    }
  }

    Future<void> clearHistory() async {
    try {
      await _api.clearHistory();
      messages.clear();
      _addInitialWelcomeMessage();
    } catch (e) {
      debugPrint('clearHistory error: $e');
    }
  }

  void _addInitialWelcomeMessage() {
    messages.add(
      ChatMessageModel(
        id: 'msg_welcome',
        text: 'ai_tutor_welcome'.tr,
        sender: MessageSender.ai,
        timestamp: DateTime.now(),
      ),
    );
  }

  List<String> get suggestedPromptChips {
    final stream =
        _authController.currentUser.value?.academicStream ??
        _authController.selectedStream.value;
    if (stream == 'BAC_Maths' || stream == 'BAC_Technique') {
      return ['prompt_math_1'.tr, 'prompt_math_2'.tr, 'prompt_math_3'.tr];
    } else if (stream == 'BAC_Lettres' || stream == 'BAC_Languages') {
      return [
        'prompt_lettres_1'.tr,
        'prompt_lettres_2'.tr,
        'prompt_lettres_3'.tr,
      ];
    }
    return [
      'prompt_default_1'.tr,
      'prompt_default_2'.tr,
      'prompt_default_3'.tr,
    ];
  }

  Future<void> sendUserPrompt(String promptText) async {
    final text = promptText.trim();
    final imagePath = selectedImagePath.value;

    if (text.isEmpty && imagePath.isEmpty) return;
    if (isGenerating.value) return;

    textController.clear();
    selectedImagePath.value = '';

    final displayText = text.isNotEmpty
        ? (imagePath.isNotEmpty
              ? '📷 [${'attached_exercise'.tr}]\n$text'
              : text)
        : 'attached_exercise_msg'.tr;

    final userMsg = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: displayText,
      sender: MessageSender.user,
      attachmentPath: imagePath.isNotEmpty ? imagePath : null,
      timestamp: DateTime.now(),
    );
    messages.add(userMsg);
    _scrollToBottom();

    final aiMsgId = 'ai_${DateTime.now().millisecondsSinceEpoch}';
    final aiPlaceholder = ChatMessageModel(
      id: aiMsgId,
      text: 'ai_thinking'.tr,
      sender: MessageSender.ai,
      timestamp: DateTime.now(),
    );
    messages.add(aiPlaceholder);
    isGenerating.value = true;
    _scrollToBottom();

    try {
      final streamCode =
          _authController.currentUser.value?.academicStream ??
          _authController.selectedStream.value;
      final response = await _api.sendPrompt(
        text,
        streamCode,
        imagePath: imagePath.isNotEmpty ? imagePath : null,
      );

      final resultText = _parseAiResponse(response.data);

      final index = messages.indexWhere((m) => m.id == aiMsgId);
      if (index != -1) {
        messages[index] = ChatMessageModel(
          id: aiMsgId,
          text: resultText,
          sender: MessageSender.ai,
          timestamp: DateTime.now(),
        );
      }

      voiceState.value = VoiceState.idle;
    } on ApiException catch (e) {
      Get.snackbar(
        'notice'.tr,
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
      );
      messages.removeWhere((m) => m.id == aiMsgId);
      voiceState.value = VoiceState.idle;
    } catch (_) {
      Get.snackbar(
        'error'.tr,
        'ai_tutor_error'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      messages.removeWhere((m) => m.id == aiMsgId);
      voiceState.value = VoiceState.idle;
    } finally {
      isGenerating.value = false;
      _scrollToBottom();
    }
  }

    Future<void> startVoiceListening() async {
    await stopSpeaking();
    voiceTranscript.value = '';
    soundLevel.value = 0.0;
    _isStoppingVoice = false;

    if (!_speechInitialized) {
      _speechInitialized = await _speechToText.initialize(
        onError: (err) => debugPrint('STT Error: $err'),
        onStatus: (status) {
          debugPrint('STT Status: $status');
          if (status == 'done' || status == 'notListening') {
            if (voiceState.value == VoiceState.listening && !_isStoppingVoice) {
              stopVoiceListening();
            }
          }
        },
      );
    }

    if (_speechInitialized) {
      voiceState.value = VoiceState.listening;

      // Determine STT locale strictly based on current app language setting
      final appLang = Get.locale?.languageCode ?? 'ar';
      String targetLocale = 'ar_SA';
      if (appLang == 'fr') {
        targetLocale = 'fr_FR';
      } else if (appLang == 'en') {
        targetLocale = 'en_US';
      } else {
        // Try ar_DZ or default to ar_SA for Arabic
        try {
          final systemLocales = await _speechToText.locales();
          final dzLocale = systemLocales.firstWhere(
            (l) => l.localeId.startsWith('ar_DZ'),
            orElse: () => systemLocales.firstWhere(
              (l) => l.localeId.startsWith('ar'),
              orElse: () => stt.LocaleName('ar_SA', 'Arabic'),
            ),
          );
          targetLocale = dzLocale.localeId;
        } catch (_) {
          targetLocale = 'ar_SA';
        }
      }

      await _speechToText.listen(
        localeId: targetLocale,
        onResult: (result) {
          voiceTranscript.value = result.recognizedWords;
        },
        onSoundLevelChange: (level) {
          soundLevel.value = (level / 10.0).clamp(0.0, 1.0);
        },
      );
    }
  }

    Future<void> stopVoiceListening() async {
    if (_isStoppingVoice) return;
    _isStoppingVoice = true;

    try {
      await _speechToText.stop();
    } catch (_) {}

    soundLevel.value = 0.0;
    final query = voiceTranscript.value.trim();
    _isStoppingVoice = false;
    voiceState.value = VoiceState.idle;

    if (query.isNotEmpty) {
      textController.text = query;
      textController.selection = TextSelection.fromPosition(
        TextPosition(offset: query.length),
      );
    }
  }

    Future<void> speakResponse(String text) async {
    try {
      voiceState.value = VoiceState.speaking;
      // Strip markdown code fences / LaTeX brackets for clean speech reading
      final cleanText = text
          .replaceAll(RegExp(r'\$\$.*?\$\$', dotAll: true), '')
          .replaceAll(RegExp(r'\$.*?\$'), '')
          .replaceAll(RegExp(r'[#\*_`\-\+]'), '')
          .trim();

      if (cleanText.isNotEmpty) {
        await _flutterTts.speak(cleanText);
      } else {
        voiceState.value = VoiceState.idle;
      }
    } catch (e) {
      debugPrint('speakResponse error: $e');
      voiceState.value = VoiceState.idle;
    }
  }

    Future<void> stopSpeaking() async {
    try {
      await _flutterTts.stop();
    } catch (_) {}
    if (voiceState.value == VoiceState.speaking) {
      voiceState.value = VoiceState.idle;
    }
  }

    String _parseAiResponse(dynamic data) {
    if (data == null) return 'ai_response_received'.tr;

    if (data is Map) {
      if (data['chunk'] != null) return data['chunk'].toString();
      if (data['error'] != null) return data['error'].toString();
      return 'ai_response_received'.tr;
    }

    if (data is String) {
      final raw = data.trim();

      final buffer = StringBuffer();
      for (final line in raw.split('\n')) {
        final trimmed = line.trim();
        if (trimmed.startsWith('data:')) {
          final jsonStr = trimmed.substring(5).trim();
          try {
            final decoded = jsonDecode(jsonStr);
            if (decoded is Map && decoded['chunk'] != null) {
              buffer.write(decoded['chunk'].toString());
            } else if (decoded is Map && decoded['error'] != null) {
              return decoded['error'].toString();
            }
          } catch (_) {
            // not valid JSON
          }
        }
      }

      final result = buffer.toString().trim();
      return result.isNotEmpty ? result : raw;
    }

    return 'ai_response_received'.tr;
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    _speechToText.stop();
    _flutterTts.stop();
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
