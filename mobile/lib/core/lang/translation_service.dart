import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TranslationService extends Translations {
  static const fallbackLocale = Locale('ar', 'DZ');

  static final locales = [
    const Locale('ar', 'DZ'),
    const Locale('fr', 'FR'),
    const Locale('en', 'US'),
  ];

  @override
  Map<String, Map<String, String>> get keys => {
    'ar': {
      'course_not_found': 'الدورة غير موجودة',

      'about_app_desc': 'أكاديمية بصمة التعليمية — المنصة الإلكترونية الشاملة لمراجعة وتفوق تلاميذ شهادة البكالوريا الجزائريين (BAC v1.0.0).\n\nتطوير وإنجاز المهندس: عبد الحميد مرغمي (Abdelhamid Merghemi)',

      'developer_label': 'المطور: عبد الحميد مرغمي',

      'flashcard_count': 'بطاقة',

      'flashcard_deck_label': 'بطاقات مراجعة',

      'start_review': 'ابدأ المراجعة',

      'back_to_decks': 'العودة لقائمة الدروس',

      'flashcards_decks_subtitle': 'اختر الدرس للبدء في مراجعة بطاقات الذاكرة',

      'flashcard_success_title': '🎉 أحسنت!',

      'flashcard_success_desc': 'أكملت مراجعة جميع بطاقات هذا المفهوم بنجاح.',

      'flashcard_question_badge': 'سؤال المراجعة 💡',

      'flashcard_tap_to_flip': 'اضغط لمشاهدة الإجابة 🔄',

      'flashcard_answer_badge': 'الإجابة النموذجية ✅',

      'flashcard_rate_memorization': 'تقييم مستوى التذكر بالأسفل 👇',

      'teacher_profile': 'الملف الشخصي للأستاذ',

      'teacher_not_found': 'لم يتم العثور على ملف الأستاذ',

      'announcements': 'إعلانات الأستاذ',

      'lesson': 'الدرس',

      'school_name': 'اسم المؤسسة التعليمية / ثانوية',

      'school_name_hint': 'أدخل اسم ثانوك (مثال: ثانوية العقيد لطفي)',

      'wilaya': 'الولاية',

      'select_wilaya': 'اختر ولايتك (1 - 58)',

      'wilaya_code': 'رمز الولاية',

      'forum_label': 'فضاء النقاشات',
      'min_ago': 'منذ @min دقيقة',
      'hours_ago': 'منذ @hours ساعة',
      'days_ago': 'منذ @days يوم',
      'forum_title': 'فضاء الأسئلة والنقاشات',
      'forum_search_hint': 'ابحث عن سؤال، دراسات، أو تمارين...',
      'forum_all': 'الكل',
      'forum_questions': 'أسئلة',
      'forum_discussions': 'نقاشات',
      'forum_resources': 'ملخصات',
      'all_subjects': 'جميع المواد',
      'ask_question': 'اطرح سؤالاً',
      'no_posts_found': 'لا توجد أسئلة أو مواضيع في هذا القسم حالياً',
      'be_first_to_ask': 'كن أول من يطرح سؤالاً',
      'question_solved': 'تمت الإجابة (إجابة نموذجية)',
      'comments_count': '@count تعليق',
      'create_post_title': 'إضافة سؤال أو موضوع جديد',
      'post_type_label': 'نوع الموضوع',
      'select_subject_optional': 'المادة الدراسية (اختياري)',
      'all_subjects_option': 'عام (جميع المواد)',
      'post_title_label': 'عنوان الموضوع / السؤال',
      'post_title_hint': 'مثال: كيف أفرق بين المناعة الخلطية والخلوية؟',
      'post_content_label': 'التفاصيل والشرح',
      'post_content_hint': 'اكتب تفاصيل سؤالك أو الموضوع هنا بالتفصيل...',
      'attach_image': 'إرفاق صورة',
      'change_image': 'تغيير الصورة',
      'publish_post': 'نشر الموضوع',
      'post_details_title': 'تفاصيل الموضوع',
      'answers_and_discussions': 'الإجابات والمناقشات (@count)',
      'no_replies_yet': 'لا توجد إجابات بعد. كن أول من يجيب!',
      'write_reply_hint': 'اكتب إجابتك أو توضيحك هنا...',
      'approved_best_answer': 'الإجابة النموذجية المعتمدة',
      'mark_as_best_answer': 'اعتماد كأفضل إجابة',
      'error_fill_fields': 'يرجى ملء عنوان الموضوع ومحتوى السؤال أو المناقشة',
      'post_published_success': 'تم نشر سؤالك/موضوعك في فضاء المناقشات بنجاح',
      'question_label': 'سؤال',
      'discussion_label': 'نقاش',
      'resource_label': 'ملخص',
      'filter_discussions': 'تصفية وحصر النقاشات',
      'sort_by': 'الترتيب حسب',
      'sort_latest': 'الأحدث',
      'sort_popular': 'الأكثر تفاعلاً',
      'sort_unanswered': 'أسئلة بدون إجابة',
      'apply': 'تطبيق الفلترة',
      'reset': 'إعادة ضبط',

      'ai_banner_desc': 'احصل على إجابات فورية ونقاط مراجعة مخصصة لشعبتك على مدار الساعة',

      'onboarding_desc_1': 'الوصول إلى أفضل الدروس وملخصات البكالوريا لأقوى الأساتذة في الجزائر.',

      'onboarding_desc_2': 'استعن بذكاء الذكاء الاصطناعي لتلخيص الدروس وحل التمارين المعقدة فوراً.',

      'onboarding_desc_3': 'طرق تعلم حديثة وتفاعلية تقودك خطوة بخطوة نحو شهادة البكالوريا بتفوق.',

      'clear_chat_confirm_msg': 'هل أنت أصل من رغبتك في مسح سجل المحادثة بالكامل؟',

      'receipt_uploaded_success': 'تم رفع الوصل بنجاح! جاري مراجعته من الإدارة.',

      'notifications_active': 'التنبيهات مفعلة بنجاح',

      'google_register_hint': 'أدخل معلوماتك لإكمال التسجيل عبر حساب Google',

      'privacy_desc': 'نحن نحترم خصوصيتك ونلتزم بحماية بياناتك الشخصية وحفظها بأمان.',

      'ai_tutor_welcome': 'مرحباً بك! أنا مساعدك الذكي لدروس البكالوريا، كيف يمكنني مساعدتك اليوم؟ 🤖',

      'scan_exercise_title': 'مسح وحل التمرين بالذكاء الاصطناعي 📸',

      'scan_exercise_subtitle': 'التقط صورة للتمرين المكتوب أو المطبوع للحصول على حل مفصل خطوة بخطوة',

      'take_photo': 'التقاط صورة',

      'from_gallery': 'من المعرض',

      'attached_exercise': 'تمرين مرفق للحل 📷',

      'ai_will_solve': 'سيقوم الذكاء الاصطناعي باستخراج المسألة وحلها',

      'photo_pick_failed': 'فشل التقاط الصورة',

      'attached_exercise_msg': '📷 [صورة تمرين مرفقة للحل والتحليل]',

      'upload_talon_proof': 'الرجاء تصوير وصل التحويل بوضوح وإرفاقه',

      'thank_you_rating': 'شكراً لك على تقييمك لمنصة بصمة أكاديمي! 🌟',

      'downloads_desc': 'إدارة الفيديو والدروس المحملة ومشاهدتها بدون إنترنت',

      'email_required': 'البريد الإلكتروني مطلوب',

      'ai_tutor_error': 'عذراً، حدث خطأ أثناء الاتصال بالمساعد الذكي. حاول مجدداً.',

      'unexpected_error': 'حدث خطأ غير متوقع. يرجى إعادة المحاولة.',

      'prompt_math_1': 'اشرح لي التزايد المقارن ودراسة النهايات 📐',

      'prompt_math_2': 'كيف أحسب السرعة الحجمية للتفاعل في الفيزياء ⚡',

      'prompt_math_3': 'طريقة حساب التكامل بالتجزئة مع تمرين 🧮',

      'prompt_lettres_1': 'منهجية تحليل مقالة فلسفية جدلية 📝',

      'prompt_lettres_2': 'أهم الإشكاليات الفلسفية في الإدراك والذاكرة 🧠',

      'prompt_lettres_3': 'إعراب الجمل التي لها محل من الإعراب 📚',

      'prompt_default_1': 'كيف أجيب عن سؤال الاستدلال العلمي في العلوم 🧬',

      'prompt_default_2': 'اشرح لي قانون الاستمرار والنهايات في الرياضيات 📐',

      'prompt_default_3': 'طريقة حساب الناقلية النوعية الكيميائية ⚡',

      'flashcards_completed_title': 'أحسنت! لقد أكملت مراجعة اليوم 🎓',

      'flashcards_completed_desc': 'تم تطبيق خوارزمية التكرار المتباعد لترسيخ المعلومات بنجاح.',

      'banner_downloads_title': 'حمل الدروس وشاهدها بدون أنترنت ⚡',

      'banner_downloads_desc': 'احفظ دروسك المفضلة ومحتوى الشعبة للمشاهدة في أي وقت ومن أي مكان',

      'banner_summaries_title': 'ملخصات البكالوريا لأقوى الأساتذة 📚',

      'banner_summaries_desc': 'ملخصات مركزة وقوانين جاهزة للحفظ وتطبيقات محلولة بدقة',

      'banner_tip_title': 'نصيحة اليوم لتحصيل أفضل العلامات 💡',

      'banner_tip_desc': 'المواظبة اليومية وحل أسئلة البكالوريا السابقة هي سر التفوق والمعدل العالي',

      'course_locked_warning_title': 'الدورة غير مفعلة 🔐',

      'course_locked_warning_desc': 'يرجى تفعيل الدورة أو رفع إيصال الدفع للوصول إلى كافة الدروس والمحتوى كامل.',

      'select_subject_quiz_title': 'اختر المادة لعرض الاختبارات التقييمية',

      'change_subject': 'تغيير المادة',

      'app_name': 'بصمة أكاديمي',

      'onboarding_title_1': 'تفوق في بكالوريا 2026',

      'onboarding_title_2': 'مساعدك الذكي للدراسة',

      'onboarding_title_3': 'حقق حلم النجاح',

      'next': 'التالي',

      'start': 'ابدأ الآن',

      'select_lang': 'اختر اللغة',

      'academic_year': 'الشعبة الدراسية',

      'select_stream': 'اختر شعبتك في البكالوريا للبدء',

      'phone_number': 'رقم الهاتف',

      'phone_hint': '5 / 6 / 7 XX XX XX XX',

      'login': 'تسجيل الدخول',

      'otp_title': 'رمز التحقق OTP',

      'otp_desc': 'أدخل الرمز المكون من 6 أرقام المرسل إلى ',

      'resend_wait': 'يرجى الانتظار لإعادة إرسال الرمز',

      'resend_otp': 'إعادة إرسال الرمز',

      'verify': 'تأكيد الرمز',

      'subjects': 'المواد',

      'courses': 'الدورات التعليمية',

      'good_morning': 'صباح الخير ☀️',

      'good_afternoon': 'مساء الخير 🌤️',

      'good_evening': 'مساء الخير 🌙',

      'ai_motivation_title': 'حكمة اليوم للدراسة 💡',

      'ai_tip_title': 'نصيحة الذكاء الاصطناعي للشعبة 🤖',

      'quick_actions': 'الوصول السريع',

      'ai_tutor': 'Basma AI',

      'continue_learning': 'مواصلة التعلم',

      'flashcards': 'بطاقات المراجعة',

      'popular_courses': 'الدورات الأكثر شعبية 🔥',

      'recommended_teachers': 'نخبة الأساتذة الموصى بهم 🌟',

      'view_all': 'عرض الكل >',

      'search_placeholder': 'ابحث عن مادة، دورة، أو أستاذ...',

      'ai_banner_title': 'Basma AI 🤖',

      'ask_ai_now': 'اسأل Basma AI الآن ✨',

      'change_stream': 'تغيير الشعبة الدراسية',

      'progress': 'نسبة الإنجاز',

      'price': 'السعر',

      'dzd': 'د.ج',

      'unlocked': 'مفعلة',

      'locked': 'مغلقة - اضغط للتفعيل',

      'rating_title': 'تقييم الدورة',

      'submit_rating': 'إرسال التقييم',

      'write_review': 'إضافة تقييم',

      'write_review_desc': 'شارك انطباعك ورأيك حول هذه الدورة لمساعدة زملائك',

      'submit_review': 'نشر التقييم',

      'review_submitted': 'تم نشر تقييمك بنجاح!',

      'comment_hint': 'اكتب رأيك هنا بكل صراحة...',

      'reviews': 'تقييمات الطلاب',

      'no_reviews': 'لا توجد مراجعات بعد. كن أول من يشاركنا رأيه!',

      'watermark_warning':
          'تنبيه: محتوى الفيديو محمي ومخصص للاستخدام الشخصي فقط. تصوير الشاشة يعرض حسابك للإيقاف.',
      'payment_info': 'معلومات الدفع والتفعيل',

      'ccp_holder': 'اسم صاحب الحساب: بصمة أكاديمي',

      'ccp_number': 'رقم الحساب البريدي (CCP): 0098765432 / 21',

      'rip_key': 'مفتاح الـ RIP:',

      'copy_success': 'تم النسخ بنجاح!',

      'upload_talon': 'تحميل وصل الدفع (Talon)',

      'choose_image': 'اختر صورة الوصل',

      'camera': 'الكاميرا',

      'gallery': 'المعرض',

      'submit_order': 'تأكيد وإرسال الطلب',

      'order_status': 'حالة الطلب',

      'pending': 'قيد المراجعة',

      'approved': 'تم القبول والتفعيل',

      'rejected': 'مرفوض - يرجى تصوير الوصل بوضوح',

      'profile': 'الملف الشخصي',

      'settings': 'الإعدادات',

      'dark_mode': 'المظهر الداكن',

      'light_mode': 'المظهر الفاتح',

      'offline_files': 'التحميلات المحفوظة',

      'delete_cache': 'إخلاء مساحة التخزين المؤقت',

      'payments_tracker': 'تتبع طلبات التفعيل',

      'payment_method': 'وسيلة الدفع',

      'reference': 'الرقم المرجعي',

      'logout': 'تسجيل الخروج',

      'language': 'لغة التطبيق',

      'welcome': 'مرحباً بك',

      'home': 'الرئيسية',

      'voice_assistant_title': 'المساعد الصوتي المباشر',

      'voice_listening': 'جاري الاستماع لأسئلتك...',

      'voice_thinking': 'جاري التفكير وصياغة الإجابة...',

      'voice_speaking': 'المساعد يتحدث الآن...',

      'voice_tap_to_speak': 'اضغط للتحدث',

      'voice_tap_to_stop': 'إيقاف الصوتي',

      'voice_diagram_match': 'المخطط التوضيحي المرفق',

      'search': 'البحث',

      'search_hint': 'ابحث عن الدروس، المواد...',

      'all': 'الكل',

      'stream_active': 'الشعبة الحالية',

      'cancel': 'إلغاء',

      'close': 'إغلاق',

      'submit': 'تأكيد',

      'comment': 'التعليق',

      'details': 'تفاصيل الدورة',

      'curriculum': 'الدروس والمنهج',

      'minutes': 'دقيقة',

      'unlock_course': 'اشترك الآن في الدورة',

      'add_review': 'أضف تقييمك',

      'downloads': 'التحميلات',

      'delete': 'حذف',

      'ok': 'موافق',

      'success': 'تم بنجاح',

      'payment_upload': 'تفعيل الدورة الدفع',

      'select_payment_method': 'اختر طريقة الدفع المفضلة',

      'submit_verification': 'إرسال للتفعيل',

      'required': 'مطلوب',

      'welcome_back': 'مرحباً بك مجدداً',

      'splash_loading': 'جاري تحضير رحلتك التعليمية...',

      'login_subtitle': 'قم بتسجيل الدخول لمواصلة الدراسة والتحضير',

      'no_account': 'ليس لديك حساب؟',

      'register_now': 'إنشاء حساب جديد',

      'have_account': 'لديك حساب بالفعل؟',

      'create_account': 'إنشاء حساب جديد',

      'register_subtitle': 'سجل بياناتك للانضمام إلى منصة بصمة أكاديمي',

      'or': 'أو',

      'sign_in_google': 'تسجيل الدخول بواسطة Google',

      'send_otp': 'إرسال الرمز برقم الهاتف',

      'register': 'تسجيل الحساب',

      'name': 'الاسم الكامل',

      'feed': 'أخبار وإعلانات',

      'no_announcements': 'لا توجد إعلانات من الأساتذة حالياً.',

      'no_subjects_available': 'لا توجد مواد متاحة حالياً.',

      'no_courses_available': 'لا توجد دورات تعليمية متاحة حالياً.',

      'likes': 'إعجاب',

      'comments': 'تعليق',

      'no_comments': 'لا توجد تعليقات بعد. كن أول من يعلق!',

      'no_comments_yet': 'لا توجد تعليقات بعد. كن أول من يعلق!',

      'add_comment_hint': 'اكتب تعليقاً...',

      'post': 'نشر',

      'day_ago': 'قبل يوم',

      'days_ago': 'قبل @days يوم',

      'hour_ago': 'قبل ساعة',

      'hours_ago': 'قبل @hours ساعة',

      'minute_ago': 'قبل دقيقة',

      'minutes_ago': 'قبل @minutes دقيقة',

      'just_now': 'الآن',

      'theme': 'المظهر',

      'verification_queue': 'طلبات التفعيل والتحقق',

      'no_verification_requests': 'لم تقم بتقديم أي طلبات تفعيل بعد.',

      'upload_receipt': 'رفع إيصال دفع جديد',

      'reference_number_hint': 'رقم الحوالة (اختياري)',

      'ccl_talon': 'صورة الإيصال (تنبيه: يجب أن تكون الصورة واضحة)',

      'reject_reason_label': 'سبب الرفض: ',

      'edit_profile': 'تعديل الملف الشخصي',

      'save_changes': 'حفظ التغييرات',

      'profile_updated_success': 'تم تحديث الملف الشخصي بنجاح',

      'notifications': 'الإشعارات',

      'privacy': 'سياسة الخصوصية',

      'privacy_title': 'سياسة الخصوصية وحماية البيانات',

      'notifications_settings': 'تنبيهات الدراسة والإعلانات',

      'rate_app': 'تقييم التطبيق',

      'version': 'الإصدار',

      'quiz': 'اختبار تقييمي',

      'quiz_label': 'اختبار تقييمي',

      'no_quiz_questions': 'لا توجد أسئلة متاحة لهذا الاختبار.',

      'points': 'نقاط',

      'previous': 'السابق',

      'next_question': 'السؤال التالي',

      'submit_quiz': 'إنهاء وتسليم الاختبار 🚀',

      'quiz_passed': 'مبروك! لقد اجتزت الاختبار بنجاح 🎉',

      'quiz_failed': 'لم تتجاوز الاختبار هذه المرة 🔴',

      'score_label': 'النتيجة النهائية',

      'correct_questions': 'إجابة صحيحة',

      'answer_breakdown': 'تفاصيل الإجابات والتفسير العلمي 💡',

      'retake_quiz': 'إعادة الاختبار 🔄',

      'info': 'معلومات التطبيق',

      'account': 'الحساب',

      'no_downloads': 'لا توجد دروس محملة حالياً.',

      'storage_used': 'المساحة المستخدمة للدروس:',

      'email': 'البريد الإلكتروني',

      'password': 'كلمة المرور',

      'forgot_password': 'نسيت كلمة المرور؟',

      'password_min': 'كلمة المرور يجب أن تكون 6 أحرف على الأقل.',

      'enter_otp_hint': 'أدخل رمز التحقق المكون من 6 أرقام.',

      'name_required': 'الاسم الكامل مطلوب للتسجيل.',

      'name_hint': 'أدخل الاسم الكامل',

      'email_hint': 'أدخل البريد الإلكتروني',

      'password_hint': 'أدخل كلمة المرور',

      'otp_hint': 'أدخل رمز التحقق',

      'BAC_Sciences': 'بكالوريا علوم تجريبية',

      'BAC_Maths': 'بكالوريا رياضيات',

      'BAC_Technique': 'بكالوريا تقني رياضي',

      'BAC_Lettres': 'بكالوريا آداب وفلسفة',

      'BAC_Languages': 'بكالوريا لغات أجنبية',

      'BAC_Gestion': 'بكالوريا تسيير واقتصاد',

      'study_tools': 'أدوات الدراسة',

      'ai_tutor_label': 'Basma AI',

      'flashcards_label': 'بطاقات المراجعة',

      'announcements_label': 'الإعلانات',

      'filter_courses': 'تصفية الدورات',

      'subject': 'المادة',

      'content_type': 'نوع المحتوى',

      'sort_by': 'الترتيب حسب',

      'apply_filters': 'تطبيق الفلترة',

      'reset': 'إعادة ضبط',

      'no_subjects': 'لا توجد مواد دراسية حالياً.',

      'notifications_empty': 'لا توجد إشعارات جديدة حالياً',

      'mark_all_read': 'تحديد الكل كمقروء',

      'ai_tutor_title': 'Basma AI',

      'ai_tutor_status': 'متصل ومستعد للمراجعة ⚡',

      'ai_tutor_hint': 'اكتب سؤالك هنا باللغة العربية أو الفرنسية...',

      'ai_thinking': 'جاري التفكير وصياغة الشرح...',

      'ai_response_received': 'تم استلام الإجابة بنجاح.',

      'clear_chat_title': 'مسح المحادثة',

      'clear_chat_action': 'مسح المحادثة',

      'confirm': 'تأكيد',

      'notice': 'تنبيه',

      'error': 'خطأ',

      'flashcards_title': 'بطاقات المراجعة الذكية',

      'no_flashcards': 'لا توجد بطاقات مراجعة متوفرة حالياً.',

      'restart_review': 'إعادة المراجعة من الجديد',

      'show_answer': 'إظهار الإجابة',

      'grade_hard': 'صعبة جداً 🔴',

      'grade_medium': 'متوسطة 🟡',

      'grade_easy': 'سهلة جداً 🟢',

      'quote_1': 'النجاح هو محصلة خطوات صغيرة تتكرر كل يوم بنظام وثبات 🌟',

      'quote_2': 'البكالوريا ليست مجرد امتحان، بل هي بوابتك نحو المستقبل والجامعة 🎓',

      'quote_3': 'التفوق لا يأتي بالمصادفة، بل هو ثمرة التخطيط والمراجعة المستمرة 🚀',

      'quote_4': 'ثق بقدراتك، فكل دقيقة تقضيها في المراجعة تقربك أكثر من هدفك ✨',

      'quote_5': 'الانضباط اليومي في الدراسة هو الفرق الحقيقي بين المتمني والمتفوق 🏆',

      'tip_BAC_Sciences_1':
          'اربط بين التجربة والنتيجة، واستخدم المصطلحات العلمية الدقيقة في الإجابة! 🧬',
      'tip_BAC_Sciences_2':
          'حل مواضيع البكالوريا السابقة مع الاطلاع على التصحيح النموذجي هو سر العلامة الكاملة! 💯',
      'tip_BAC_Sciences_3':
          'ركز على منهجية الإجابة: التحليل، التفسير، والاستنتاج في تمارين علوم الطبيعة! 📝',
      'tip_BAC_Maths_1':
          'التدريب اليومي على حل التمارين المتنوعة يطور سرعتك ودقتك في الحساب! 📐',
      'tip_BAC_Maths_2':
          'فهم خطوات البراهين وإتقان دراسة الدوال يضمن لك النقاط الكبرى في الرياضيات! 🎯',
      'tip_BAC_Maths_3':
          'لا تتجاوز الأسئلة الصعبة، بل حاول فيها واستفد من الأخطاء أثناء المراجعة! 💡',
      'tip_BAC_Technique_1':
          'إتقان القوانين الفيزيائية وتطبيقها المباشر في التمارين يحسن مستواك بسرعة! ⚡',
      'tip_BAC_Technique_2':
          'فهم المخططات الهندسية والكهربائية يسهل عليك حل أعقد الأسئلة! 🛠️',
      'tip_BAC_Lettres_1':
          'المطالعة وحفظ مقولات الفلاسفة يثري مقالك الفلسفي ويمنحك التميز! 📚',
      'tip_BAC_Lettres_2':
          'التدريب على الإعراب وتحليل النصوص الأدبية يضمن لك نقطة ممتازة في اللغة العربية! ✍️',
      'tip_BAC_Languages_1':
          'استمع يومياً للنصوص الصوتية وطبّق قواعد اللغات في كتابة الفقرات! 🎧',
      'tip_BAC_Languages_2':
          'إثراء الرصيد اللغوي بالمصطلحات الأكثر تكراراً في البكالوريا يضمن العلامة الممتازة! 🌍',
      'tip_BAC_Gestion_1':
          'تدرب على إعداد الميزانيات وجداول الحسابات بدقة عالية وسرعة في الحساب! 📈',
      'tip_BAC_Gestion_2':
          'احفظ التعاريف الاقتصادية والقوانين المحاسبية مع التطبيق المباشر! 💼',
      'all_subjects_filter': 'جميع المواد',

      'quizzes_list_title': 'قائمة الاختبارات التقييمية',

      'quiz_subtitle_heading': 'اختر الاختبار التقييمي للمادة والشعبة 🎯',

      'quiz_subtitle_desc': 'قيم مستوى فهمك واستيعابك للدروس مع أسئلة البكالوريا المحاكية',

      'questions_count_label': 'أسئلة',

      'minutes_label': 'دقيقة',

      'start_quiz': 'ابدأ الاختبار',

      'no_quizzes_available': 'لا توجد اختبارات متاحة لهذه المادة حالياً',

      'bac_countdown': 'عد تنازلي لبكالوريا 2026',

      'countdown_sub': 'هل أنت مستعد لبدء رحلة التميز والنجاح في البكالوريا؟',

      'days_left': 'أيام متبقية',

      'course_buy': 'الاشتراك في الدورة',

      'course_unlocked': 'مفعلة بالكامل',

      'course_rating_label': 'من 5 نجوم',

      'course_empty_lessons': 'لا توجد دروس متاحة حالياً.',

      'course_empty_reviews': 'لا توجد تقييمات حتى الآن. كن أول من يترك تقييمك!',

      'course_lessons': 'الدروس',

      'course_reviews': 'التقييمات',

      'course_preview': 'معاينة مجانية',

      'subj_arabic': 'اللغة العربية والآداب',

      'subj_maths': 'الرياضيات',

      'subj_natural_sciences': 'علوم الطبيعة والحياة',

      'subj_philosophy': 'الفلسفة',

      'subj_physics': 'العلوم الفيزيائية',

      'about_us': 'عن التطبيق',

      'skip': 'تخطي',

    },
    'fr': {
      'course_not_found': 'Cours non trouvé',

      'about_app_desc': 'Basma Academy — La plateforme éducative d\'excellence pour la préparation du Baccalauréat Algérien (BAC v1.0.0).\n\nDéveloppé par l\'ingénieur: Abdelhamid Merghemi',

      'developer_label': 'Développeur: Abdelhamid Merghemi',

      'flashcard_count': 'cartes',

      'flashcard_deck_label': 'Cartes de révision',

      'start_review': 'Démarrer la révision',

      'back_to_decks': 'Retour aux leçons',

      'flashcards_decks_subtitle': 'Choisissez une leçon pour démarrer la révision',

      'flashcard_success_title': '🎉 Bravo !',

      'flashcard_success_desc': 'Vous avez révisé toutes les cartes avec succès.',

      'flashcard_question_badge': 'Question de révision 💡',

      'flashcard_tap_to_flip': 'Appuyez pour voir la réponse 🔄',

      'flashcard_answer_badge': 'Réponse modèle ✅',

      'flashcard_rate_memorization': 'Évaluez votre mémorisation ci-dessous 👇',

      'teacher_profile': 'Profil de l\'enseignant',

      'teacher_not_found': 'Profil de l\'enseignant introuvable',

      'announcements': 'Annonces',

      'lesson': 'Leçon',

      'school_name': 'Nom du lycée / établissement',

      'school_name_hint': 'Entrez le nom de votre lycée',

      'wilaya': 'Wilaya',

      'select_wilaya': 'Sélectionnez votre wilaya (1 - 58)',

      'wilaya_code': 'Code de la wilaya',

      'quiz_label': 'Quiz d\'évaluation',

      'forum_label': 'Espace d\'entraide',
      'min_ago': 'Il y a @min min',
      'hours_ago': 'Il y a @hours h',
      'days_ago': 'Il y a @days j',
      'forum_title': 'Espace d\'entraide',
      'forum_search_hint': 'Rechercher une question ou sujet...',
      'forum_all': 'Tous',
      'forum_questions': 'Questions',
      'forum_discussions': 'Discussions',
      'forum_resources': 'Résumés',
      'all_subjects': 'Toutes les matières',
      'ask_question': 'Poser une question',
      'no_posts_found': 'Aucune question dans cette section',
      'be_first_to_ask': 'Soyez le premier à poser une question',
      'question_solved': 'Résolu (Réponse certifiée)',
      'comments_count': '@count commentaires',
      'create_post_title': 'Créer une nouvelle question ou sujet',
      'post_type_label': 'Type de sujet',
      'select_subject_optional': 'Matière (optionnelle)',
      'all_subjects_option': 'Général (Toutes les matières)',
      'post_title_label': 'Titre du sujet',
      'post_title_hint': 'Ex: Comment réviser les mathématiques?',
      'post_content_label': 'Détails et explication',
      'post_content_hint': 'Écrivez votre question en détail ici...',
      'attach_image': 'Joindre une image',
      'change_image': 'Changer l\'image',
      'publish_post': 'Publier la question',
      'post_details_title': 'Détails du sujet',
      'answers_and_discussions': 'Réponses et discussions (@count)',
      'no_replies_yet': 'Aucune réponse pour l\'instant.',
      'write_reply_hint': 'Écrivez votre réponse ici...',
      'approved_best_answer': 'Meilleure réponse certifiée',
      'mark_as_best_answer': 'Marquer comme meilleure réponse',
      'error_fill_fields': 'Veuillez remplir le titre et le contenu',
      'post_published_success': 'Votre sujet a été publié avec succès',
      'question_label': 'Question',
      'discussion_label': 'Discussion',
      'resource_label': 'Résumé',
      'filter_discussions': 'Filtrer les discussions',
      'sort_by': 'Trier par',
      'sort_latest': 'Plus récents',
      'sort_popular': 'Plus populaires',
      'sort_unanswered': 'Sans réponse',
      'apply': 'Appliquer les filtres',
      'reset': 'Réinitialiser',

      'ai_banner_desc': 'Obtenez des réponses instantanées et des révisions personnalisées H24',

      'onboarding_desc_1': 'Accédez aux meilleurs cours et résumés du BAC par les grands professeurs.',

      'onboarding_desc_2': 'Utilisez l\'IA pour résumer les cours et résoudre les exercices complexes.',

      'onboarding_desc_3': 'Des méthodes d\'apprentissage modernes vous guidant vers le BAC.',

      'clear_chat_confirm_msg': 'Voulez-vous vraiment effacer tout l\'historique de discussion ?',

      'receipt_uploaded_success': 'Reçu envoyé avec succès ! En cours de vérification.',

      'notifications_active': 'Notifications activées avec succès',

      'google_register_hint': 'Renseignez vos informations pour finaliser l\'inscription Google',

      'privacy_desc': 'Nous respectons votre vie privée et protégeons vos données personnelles.',

      'ai_tutor_welcome': 'Bienvenue ! Je suis votre tuteur IA pour le BAC, comment puis-je vous aider ? 🤖',

      'scan_exercise_title': 'Scanner et résoudre l\'exercice avec l\'IA 📸',

      'scan_exercise_subtitle': 'Prenez une photo de l\'exercice écrit ou imprimé pour obtenir une solution détaillée',

      'take_photo': 'Prendre une photo',

      'from_gallery': 'Depuis la galerie',

      'attached_exercise': 'Exercice joint pour résolution 📷',

      'ai_will_solve': 'L\'IA va extraire et résoudre le problème',

      'photo_pick_failed': 'Échec de la capture d\'image',

      'attached_exercise_msg': '📷 [Image d\'exercice jointe pour analyse]',

      'upload_talon_proof': 'Veuillez prendre une photo claire du reçu de virement',

      'thank_you_rating': 'Merci pour votre évaluation de Basma Academy ! 🌟',

      'downloads_desc': 'Gérer et regarder vos vidéos téléchargées hors-ligne',

      'email_required': 'L\'adresse e-mail est obligatoire',

      'ai_tutor_error': 'Désolé, une erreur s\'est produite avec le tuteur IA. Réessayez.',

      'unexpected_error': 'Une erreur inattendue est survenue. Veuillez réessayer.',

      'prompt_math_1': 'Expliquez-moi la croissance comparée et les limites 📐',

      'prompt_math_2': 'Comment calculer la vitesse volumique de réaction en physique ⚡',

      'prompt_math_3': 'Méthode d\'intégration par parties avec un exercice 🧮',

      'prompt_lettres_1': 'Méthodologie de la dissertation philosophique 📝',

      'prompt_lettres_2': 'Principaux problèmes philosophiques : perception et mémoire 🧠',

      'prompt_lettres_3': 'Analyse grammaticale des propositions en arabe 📚',

      'prompt_default_1': 'Comment répondre aux questions de raisonnement scientifique 🧬',

      'prompt_default_2': 'Expliquez la continuité et les limites en mathématiques 📐',

      'prompt_default_3': 'Méthode de calcul de la conductivité spécifique ⚡',

      'flashcards_completed_title': 'Bravo ! Vous avez terminé la révision du jour 🎓',

      'flashcards_completed_desc': 'L\'algorithme de répétition espacée a été appliqué.',

      'banner_downloads_title': 'Téléchargez et regardez sans internet ⚡',

      'banner_downloads_desc': 'Enregistrez vos cours préférés pour les regarder n\'importe où',

      'banner_summaries_title': 'Résumés du BAC par les meilleurs profs 📚',

      'banner_summaries_desc': 'Résumés synthétiques et formules prêtes à être révisées',

      'banner_tip_title': 'Conseil du jour pour réussir le BAC 💡',

      'banner_tip_desc': 'La régularité et la résolution des anciens BAC sont la clé du succès',

      'course_locked_warning_title': 'Cours non activé 🔐',

      'course_locked_warning_desc': 'Veuillez activer le cours pour accéder à toutes les leçons.',

      'select_subject_quiz_title': 'Sélectionnez la matière pour afficher les quiz',

      'change_subject': 'Changer de matière',

      'app_name': 'Basma Academy',

      'onboarding_title_1': 'Réussir votre BAC 2026',

      'onboarding_title_2': 'Assistant d\'Étude IA',

      'onboarding_title_3': 'Décrochez votre Succès',

      'next': 'Suivant',

      'start': 'Commencer',

      'select_lang': 'Langue',

      'academic_year': 'Filière d\'étude',

      'select_stream': 'Choisissez votre filière BAC pour commencer',

      'phone_number': 'Téléphone',

      'phone_hint': '5 / 6 / 7 XX XX XX XX',

      'login': 'Connexion',

      'otp_title': 'Validation OTP',

      'otp_desc': 'Saisissez le code de validation envoyé au ',

      'resend_wait': 'Veuillez patienter avant de renvoyer',

      'resend_otp': 'Renvoyer le code',

      'verify': 'Valider le code',

      'subjects': 'Matières',

      'courses': 'Cours',

      'good_morning': 'Bonjour ☀️',

      'good_afternoon': 'Bon après-midi 🌤️',

      'good_evening': 'Bonsoir 🌙',

      'ai_motivation_title': 'Motivation IA du jour 💡',

      'ai_tip_title': 'Conseil IA pour votre filière 🤖',

      'quick_actions': 'Accès Rapide',

      'ai_tutor': 'Basma AI',

      'continue_learning': 'Reprendre les cours',

      'flashcards': 'Cartes Mémoire',

      'popular_courses': 'Cours Populaires 🔥',

      'recommended_teachers': 'Professeurs recommandés 🌟',

      'view_all': 'Voir tout >',

      'search_placeholder': 'Rechercher un cours, professeur...',

      'ai_banner_title': 'Basma AI 🤖',

      'ask_ai_now': 'Demander à Basma AI ✨',

      'change_stream': 'Changer de filière',

      'progress': 'Progression',

      'price': 'Prix',

      'dzd': 'DA',

      'unlocked': 'Activé',

      'locked': 'Verrouillé - Cliquer pour activer',

      'rating_title': 'Évaluer le cours',

      'submit_rating': 'Soumettre l\'évaluation',

      'write_review': 'Ajouter un avis',

      'write_review_desc': 'Partagez votre avis sur ce cours pour aider vos camarades',

      'submit_review': 'Publier l\'avis',

      'review_submitted': 'Votre avis a été publié avec succès !',

      'comment_hint': 'Écrivez votre avis ici...',

      'reviews': 'Avis des étudiants',

      'no_reviews': 'Aucun avis pour le moment. Soyez le premier à évaluer!',

      'watermark_warning':
          'Avertissement : Ce contenu vidéo est protégé pour un usage personnel. La capture d\'écran bloquera votre compte.',
      'payment_info': 'Détails du Paiement',

      'ccp_holder': 'Bénéficiaire : Basma Academy',

      'ccp_number': 'Numéro CCP : 0098765432 / 21',

      'rip_key': 'Clé RIP :',

      'copy_success': 'Copié avec succès!',

      'upload_talon': 'Téléverser le reçu (Talon)',

      'choose_image': 'Sélectionner l\'image',

      'camera': 'Appareil photo',

      'gallery': 'Galerie',

      'submit_order': 'Confirmer le paiement',

      'order_status': 'Statut de la demande',

      'pending': 'En cours de vérification',

      'approved': 'Validé et Activé',

      'rejected': 'Rejeté - Reçu illisible ou incorrect',

      'profile': 'Profil',

      'settings': 'Paramètres',

      'dark_mode': 'Mode Sombre',

      'light_mode': 'Mode Clair',

      'offline_files': 'Téléchargements',

      'delete_cache': 'Vider le stockage temporaire',

      'payments_tracker': 'Suivi des paiements',

      'payment_method': 'Méthode',

      'reference': 'Référence',

      'logout': 'Déconnexion',

      'language': 'Langue de l\'application',

      'welcome': 'Bienvenue',

      'home': 'Accueil',

      'search': 'Recherche',

      'search_hint': 'Rechercher des cours, matières...',

      'all': 'Tout',

      'stream_active': 'Filière actuelle',

      'cancel': 'Annuler',

      'close': 'Fermer',

      'submit': 'Confirmer',

      'comment': 'Commentaire',

      'details': 'Détails du cours',

      'curriculum': 'Programme & Leçons',

      'minutes': 'min',

      'unlock_course': 'S\'abonner au cours',

      'add_review': 'Ajouter un avis',

      'downloads': 'Téléchargements',

      'delete': 'Supprimer',

      'ok': 'OK',

      'success': 'Succès',

      'payment_upload': 'Activer le cours',

      'select_payment_method': 'Choisissez le mode de paiement',

      'submit_verification': 'Envoyer pour activation',

      'required': 'requis',

      'welcome_back': 'Bon retour !',

      'splash_loading': 'Préparation de votre parcours d\'apprentissage...',

      'login_subtitle': 'Connectez-vous pour continuer votre préparation',

      'no_account': 'N\'avez-vous pas de compte ?',

      'register_now': 'Créer un compte',

      'have_account': 'Avez-vous déjà un compte ?',

      'create_account': 'Créer un compte',

      'register_subtitle': 'Inscrivez-vous pour rejoindre Basma Academy',

      'or': 'OU',

      'sign_in_google': 'Se connecter avec Google',

      'send_otp': 'Recevoir le code par SMS',

      'register': 'S\'inscrire',

      'name': 'Nom complet',

      'feed': 'Actualités',

      'no_announcements': 'Aucune annonce publiée pour le moment.',

      'no_subjects_available': 'Aucune matière disponible pour le moment.',

      'no_courses_available': 'Aucun cours disponible pour le moment.',

      'likes': 'J\'aime',

      'comments': 'Commentaires',

      'no_comments': 'Aucun commentaire. Soyez le premier à commenter !',

      'no_comments_yet': 'Aucun commentaire. Soyez le premier à commenter !',

      'add_comment_hint': 'Écrire un commentaire...',

      'post': 'Publier',

      'day_ago': 'Il y a 1 jour',

      'days_ago': 'Il y a @days jours',

      'hour_ago': 'Il y a 1 heure',

      'hours_ago': 'Il y a @hours heures',

      'minute_ago': 'Il y a 1 minute',

      'minutes_ago': 'Il y a @minutes minutes',

      'just_now': 'À l\'instant',

      'theme': 'Thème',

      'verification_queue': 'Virements & Validations',

      'no_verification_requests': 'Aucune demande de validation soumise.',

      'upload_receipt': 'Nouveau reçu de paiement',

      'reference_number_hint': 'N° de Référence (Optionnel)',

      'ccl_talon': 'Photo du Reçu (Doit être lisible)',

      'reject_reason_label': 'Raison du rejet : ',

      'edit_profile': 'Modifier le profil',

      'save_changes': 'Enregistrer',

      'profile_updated_success': 'Profil mis à jour avec succès',

      'notifications': 'Notifications',

      'privacy': 'Confidentialité',

      'privacy_title': 'Politique de confidentialité',

      'notifications_settings': 'Notifications & Rappels',

      'rate_app': 'Évaluer l\'application',

      'version': 'Version',

      'quiz': 'Quiz d\'évaluation',

      'no_quiz_questions': 'Aucune question disponible pour ce quiz.',

      'points': 'pts',

      'previous': 'Précédent',

      'next_question': 'Question suivante',

      'submit_quiz': 'Terminer et envoyer le quiz 🚀',

      'quiz_passed': 'Félicitations ! Vous avez réussi le quiz 🎉',

      'quiz_failed': 'Quiz non validé cette fois 🔴',

      'score_label': 'Score final',

      'correct_questions': 'réponses correctes',

      'answer_breakdown': 'Détail des réponses & explications 💡',

      'retake_quiz': 'Refaire le quiz 🔄',

      'info': 'Informations',

      'account': 'Compte',

      'no_downloads': 'Aucune leçon téléchargée.',

      'storage_used': 'Espace occupé :',

      'email': 'E-mail',

      'password': 'Mot de passe',

      'forgot_password': 'Mot de passe oublié ?',

      'password_min': 'Le mot de passe doit contenir au moins 6 caractères.',

      'enter_otp_hint': 'Saisissez le code de validation à 6 chiffres.',

      'name_required': 'Le nom complet est requis pour l\'inscription.',

      'name_hint': 'Entrez le nom complet',

      'email_hint': 'Entrez l\'adresse e-mail',

      'password_hint': 'Entrez le mot de passe',

      'otp_hint': 'Entrez le code de vérification',

      'BAC_Sciences': 'BAC Sciences Expérimentales',

      'BAC_Maths': 'BAC Mathématiques',

      'BAC_Technique': 'BAC Technique Math',

      'BAC_Lettres': 'BAC Lettres et Philosophie',

      'BAC_Languages': 'BAC Langues Étrangères',

      'BAC_Gestion': 'BAC Gestion et Économie',

      'bac_countdown': 'Compte à rebours BAC 2026',

      'days_left': 'jours restants',

      'countdown_sub': 'Prêt à commencer votre parcours de préparation ?',

      'subj_natural_sciences': 'Sciences Naturelles',

      'subj_physics': 'Physique',

      'subj_maths': 'Mathématiques',

      'subj_arabic': 'Arabe',

      'subj_philosophy': 'Philosophie',

      'course_lessons': 'Leçons',

      'course_reviews': 'Avis',

      'course_preview': 'Aperçu gratuit',

      'course_buy': 'S\'abonner au cours',

      'course_unlocked': 'Accès activé',

      'course_rating_label': 'Sur 5 étoiles',

      'course_empty_lessons': 'Aucune leçon disponible.',

      'course_empty_reviews': 'Aucun avis pour le moment.',

      'study_tools': 'Outils d\'étude',

      'ai_tutor_label': 'Basma AI',

      'flashcards_label': 'Cartes Mémoires',

      'announcements_label': 'Annonces',

      'filter_courses': 'Filtrer les cours',

      'subject': 'Matière',

      'content_type': 'Type de contenu',

      'sort_by': 'Trier par',

      'apply_filters': 'Appliquer les filtres',

      'reset': 'Réinitialiser',

      'no_subjects': 'Aucune matière disponible actuellement.',

      'notifications_empty': 'Aucune nouvelle notification actuellement',

      'mark_all_read': 'Tout marquer comme lu',

      'ai_tutor_title': 'Basma AI',

      'ai_tutor_status': 'En ligne et prêt ⚡',

      'ai_tutor_hint': 'Posez votre question en arabe ou en français...',

      'ai_thinking': 'Réflexion en cours...',

      'ai_response_received': 'Réponse reçue avec succès.',

      'clear_chat_title': 'Effacer la discussion',

      'clear_chat_action': 'Effacer la discussion',

      'confirm': 'Confirmer',

      'notice': 'Avis',

      'error': 'Erreur',

      'flashcards_title': 'Cartes de révision intelligentes',

      'no_flashcards': 'Aucune carte mémoire disponible actuellement.',

      'restart_review': 'Recommencer la révision',

      'show_answer': 'Afficher la réponse',

      'grade_hard': 'Très difficile 🔴',

      'grade_medium': 'Moyen 🟡',

      'grade_easy': 'Très facile 🟢',

      'quote_1': 'Le succès est la somme de petits efforts répétés jour après jour 🌟',

      'quote_2': 'Le BAC n\'est pas seulement un examen, c\'est votre porte vers l\'avenir 🎓',

      'quote_3': 'L\'excellence est le fruit d\'une préparation méthodique et régulière 🚀',

      'quote_4': 'Croyez en vous, chaque heure de révision vous rapproche de votre objectif ✨',

      'quote_5': 'La discipline quotidienne fait toute la différence entre rêver et réussir 🏆',

      'tip_BAC_Sciences_1':
          'Reliez l\'expérience aux résultats et utilisez une terminologie scientifique précise ! 🧬',
      'tip_BAC_Sciences_2':
          'Résoudre les anciens sujets du BAC avec la correction type est le secret de la note maximale ! 💯',
      'tip_BAC_Sciences_3':
          'Concentrez-vous sur la méthodologie : Analyse, Interprétation et Déduction en SVT ! 📝',
      'tip_BAC_Maths_1':
          'L\'entraînement quotidien sur des exercices variés développe la rapidité et la précision ! 📐',
      'tip_BAC_Maths_2':
          'Comprendre les démonstrations et maîtriser l\'étude des fonctions garantit les meilleures notes ! 🎯',
      'tip_BAC_Maths_3':
          'Ne sautez pas les questions difficiles, essayez et apprenez de vos erreurs ! 💡',
      'tip_BAC_Technique_1':
          'Maîtriser les lois physiques et les appliquer directement améliore rapidement votre niveau ! ⚡',
      'tip_BAC_Technique_2':
          'Comprendre les schémas techniques et électriques facilite la résolution des problèmes ! 🛠️',
      'tip_BAC_Lettres_1':
          'La lecture et la mémorisation des citations philosophiques enrichissent votre dissertation ! 📚',
      'tip_BAC_Lettres_2':
          'L\'analyse grammaticale et littéraire garantit une excellente note en langue arabe ! ✍️',
      'tip_BAC_Languages_1':
          'Écoutez quotidiennement des supports audio et appliquez la grammaire en rédaction ! 🎧',
      'tip_BAC_Languages_2':
          'Enrichir votre vocabulaire avec les mots les plus fréquents au BAC garantit le succès ! 🌍',
      'tip_BAC_Gestion_1':
          'Entraînez-vous à l\'établissement des bilans et des comptes de résultat avec précision ! 📈',
      'tip_BAC_Gestion_2':
          'Apprenez les définitions économiques et les règles comptables avec application directe ! 💼',
      'all_subjects_filter': 'Toutes les matières',

      'quizzes_list_title': 'Liste des Quiz Évaluation',

      'quiz_subtitle_heading': 'Choisissez votre quiz d\'évaluation 🎯',

      'quiz_subtitle_desc': 'Évaluez votre niveau de compréhension avec des sujets du BAC',

      'questions_count_label': 'questions',

      'minutes_label': 'min',

      'start_quiz': 'Commencer le Quiz',

      'no_quizzes_available': 'Aucun quiz disponible pour cette matière pour le moment',

      'about_us': 'À propos de Basma Academy',

      'skip': 'Passer',

    },
    'en': {
      'course_not_found': 'Course not found',

      'about_app_desc': 'Basma Academy — The comprehensive e-learning platform for Algerian Baccalaureate students (BAC v1.0.0).\n\nDeveloped by engineer: Abdelhamid Merghemi',

      'developer_label': 'Developer: Abdelhamid Merghemi',

      'flashcard_count': 'cards',

      'flashcard_deck_label': 'Flashcards Deck',

      'start_review': 'Start Review',

      'back_to_decks': 'Back to Lessons',

      'flashcards_decks_subtitle': 'Select a lesson deck to start flashcards review',

      'flashcard_success_title': '🎉 Well done!',

      'flashcard_success_desc': 'You completed reviewing all cards successfully.',

      'flashcard_question_badge': 'Review Question 💡',

      'flashcard_tap_to_flip': 'Tap to flip for answer 🔄',

      'flashcard_answer_badge': 'Model Answer ✅',

      'flashcard_rate_memorization': 'Rate your recall below 👇',

      'teacher_profile': 'Teacher Profile',

      'teacher_not_found': 'Teacher profile not found',

      'announcements': 'Announcements',

      'lesson': 'Lesson',

      'school_name': 'High school / School name',

      'school_name_hint': 'Enter your high school name',

      'wilaya': 'Wilaya (Province)',

      'select_wilaya': 'Select your wilaya (1 - 58)',

      'quiz_label': 'Assessment Quiz',

      'forum_label': 'Student Forum',
      'min_ago': '@min min ago',
      'hours_ago': '@hours h ago',
      'days_ago': '@days d ago',
      'forum_title': 'Student Q&A Forum',
      'forum_search_hint': 'Search for questions or topics...',
      'forum_all': 'All',
      'forum_questions': 'Questions',
      'forum_discussions': 'Discussions',
      'forum_resources': 'Summaries',
      'all_subjects': 'All Subjects',
      'ask_question': 'Ask a Question',
      'no_posts_found': 'No questions found in this section',
      'be_first_to_ask': 'Be the first to ask a question',
      'question_solved': 'Solved (Best Answer)',
      'comments_count': '@count comments',
      'create_post_title': 'Create a New Question or Topic',
      'post_type_label': 'Topic Type',
      'select_subject_optional': 'Subject (Optional)',
      'all_subjects_option': 'General (All Subjects)',
      'post_title_label': 'Topic Title',
      'post_title_hint': 'Ex: How to solve immunoflorescence exercises?',
      'post_content_label': 'Details and Explanation',
      'post_content_hint': 'Write your question details here...',
      'attach_image': 'Attach Image',
      'change_image': 'Change Image',
      'publish_post': 'Publish Topic',
      'post_details_title': 'Topic Details',
      'answers_and_discussions': 'Answers & Discussions (@count)',
      'no_replies_yet': 'No answers yet. Be the first to answer!',
      'write_reply_hint': 'Write your answer here...',
      'approved_best_answer': 'Approved Best Answer',
      'mark_as_best_answer': 'Mark as Best Answer',
      'error_fill_fields': 'Please fill both title and content fields',
      'post_published_success': 'Your topic was published successfully',
      'question_label': 'Question',
      'discussion_label': 'Discussion',
      'resource_label': 'Summary',
      'filter_discussions': 'Filter Discussions',
      'sort_by': 'Sort By',
      'sort_latest': 'Latest',
      'sort_popular': 'Most Popular',
      'sort_unanswered': 'Unanswered',
      'apply': 'Apply Filters',
      'reset': 'Reset',

      'mastery_score_label': 'Mastery Score',

      'ai_banner_desc': 'Get instant answers and customized revision points 24/7',

      'onboarding_desc_1': 'Access top BAC lessons and summaries by Algeria\'s elite teachers.',

      'onboarding_desc_2': 'Use AI to summarize lessons and solve complex exercises instantly.',

      'onboarding_desc_3': 'Modern interactive learning methods guiding you to BAC success.',

      'clear_chat_confirm_msg': 'Are you sure you want to clear the entire chat history?',

      'receipt_uploaded_success': 'Receipt uploaded successfully! Under review.',

      'notifications_active': 'Notifications activated successfully',

      'google_register_hint': 'Fill in your details to complete Google sign-up',

      'privacy_desc': 'We respect your privacy and protect your personal data securely.',

      'ai_tutor_welcome': 'Welcome! I am your smart BAC tutor, how can I assist you today? 🤖',

      'scan_exercise_title': 'Scan & Solve Exercise with AI 📸',

      'scan_exercise_subtitle': 'Take a photo of a written or printed exercise for a detailed step-by-step solution',

      'take_photo': 'Take Photo',

      'from_gallery': 'From Gallery',

      'attached_exercise': 'Attached exercise for solving 📷',

      'ai_will_solve': 'AI will extract and solve the problem step-by-step',

      'photo_pick_failed': 'Failed to capture image',

      'attached_exercise_msg': '📷 [Attached exercise photo for solving]',

      'upload_talon_proof': 'Please take a clear photo of the payment receipt',

      'thank_you_rating': 'Thank you for rating Basma Academy! 🌟',

      'downloads_desc': 'Manage and watch your downloaded offline lessons',

      'email_required': 'Email address is required',

      'ai_tutor_error': 'Sorry, an error occurred while connecting to AI tutor. Retry.',

      'unexpected_error': 'An unexpected error occurred. Please try again.',

      'prompt_math_1': 'Explain comparative growth and limits analysis 📐',

      'prompt_math_2': 'How to calculate reaction volumetric rate in physics ⚡',

      'prompt_math_3': 'Integration by parts method with an exercise 🧮',

      'prompt_lettres_1': 'Methodology for writing a dialectical philosophy essay 📝',

      'prompt_lettres_2': 'Key philosophical issues in perception and memory 🧠',

      'prompt_lettres_3': 'Arabic sentence clause grammatical parsing 📚',

      'prompt_default_1': 'How to answer scientific reasoning questions 🧬',

      'prompt_default_2': 'Explain continuity and limits theorem in mathematics 📐',

      'prompt_default_3': 'Method for calculating chemical electrical conductivity ⚡',

      'flashcards_completed_title': 'Well done! You completed today\'s review 🎓',

      'flashcards_completed_desc': 'Spaced repetition algorithm applied successfully.',

      'banner_downloads_title': 'Download and watch offline without internet ⚡',

      'banner_downloads_desc': 'Save your favorite lessons to watch anytime, anywhere',

      'banner_summaries_title': 'BAC summaries by elite teachers 📚',

      'banner_summaries_desc': 'Focused summaries and essential formulas ready for revision',

      'banner_tip_title': 'Tip of the day for top BAC scores 💡',

      'banner_tip_desc': 'Daily consistency and solving past BAC exams are the key to high scores',

      'course_locked_warning_title': 'Course Locked 🔐',

      'course_locked_warning_desc': 'Please activate the course to unlock all video lessons.',

      'select_subject_quiz_title': 'Select a subject to view assessment quizzes',

      'change_subject': 'Change Subject',

      'app_name': 'Basma Academy',

      'onboarding_title_1': 'Excel in your BAC 2026',

      'onboarding_title_2': 'Smart AI Study Assistant',

      'onboarding_title_3': 'Achieve Academic Success',

      'next': 'Next',

      'start': 'Get Started',

      'select_lang': 'Language',

      'academic_year': 'Academic Stream',

      'select_stream': 'Select your BAC stream to get started',

      'phone_number': 'Phone Number',

      'phone_hint': '5 / 6 / 7 XX XX XX XX',

      'login': 'Login',

      'otp_title': 'OTP Validation',

      'otp_desc': 'Enter the 6-digit verification code sent to ',

      'resend_wait': 'Please wait to resend',

      'resend_otp': 'Resend Code',

      'verify': 'Verify Code',

      'subjects': 'Subjects',

      'courses': 'Courses',

      'good_morning': 'Good Morning ☀️',

      'good_afternoon': 'Good Afternoon 🌤️',

      'good_evening': 'Good Evening 🌙',

      'ai_motivation_title': 'Today\'s AI Motivation 💡',

      'ai_tip_title': 'AI Stream Study Tip 🤖',

      'quick_actions': 'Quick Actions',

      'ai_tutor': 'Basma AI',

      'continue_learning': 'Continue Learning',

      'flashcards': 'Flashcards',

      'popular_courses': 'Popular Courses 🔥',

      'recommended_teachers': 'Recommended Top Teachers 🌟',

      'view_all': 'View All >',

      'search_placeholder': 'Search courses, teachers...',

      'ai_banner_title': 'Basma AI 🤖',

      'ask_ai_now': 'Ask Basma AI Now ✨',

      'change_stream': 'Change Academic Stream',

      'progress': 'Progress',

      'price': 'Price',

      'dzd': 'DZD',

      'unlocked': 'Activated',

      'locked': 'Locked - Tap to unlock',

      'rating_title': 'Rate Course',

      'submit_rating': 'Submit Review',

      'write_review': 'Write a Review',

      'write_review_desc': 'Share your feedback about this course to help fellow students',

      'submit_review': 'Post Review',

      'review_submitted': 'Your review has been submitted successfully!',

      'comment_hint': 'Write your honest review here...',

      'reviews': 'Student Reviews',

      'no_reviews': 'No reviews yet. Be the first to rate!',

      'watermark_warning':
          'Notice: This video is licensed for personal use only. Screen recording triggers account suspension.',
      'payment_info': 'Payment Information',

      'ccp_holder': 'Account Holder: Basma Academy',

      'ccp_number': 'CCP Account: 0098765432 / 21',

      'rip_key': 'RIP Key:',

      'copy_success': 'Copied to clipboard!',

      'upload_talon': 'Upload Receipt (Talon)',

      'choose_image': 'Select Image',

      'camera': 'Camera',

      'gallery': 'Gallery',

      'submit_order': 'Confirm Order Payment',

      'order_status': 'Order Status',

      'pending': 'Pending Review',

      'approved': 'Approved & Activated',

      'rejected': 'Rejected - Please capture a clear receipt photo',

      'profile': 'Profile',

      'settings': 'Settings',

      'dark_mode': 'Dark Theme',

      'light_mode': 'Light Theme',

      'offline_files': 'Downloaded Lessons',

      'delete_cache': 'Clear local cache to free space',

      'payments_tracker': 'Payment Tracking Queue',

      'payment_method': 'Payment Method',

      'reference': 'Reference',

      'logout': 'Logout',

      'language': 'App Language',

      'welcome': 'Welcome',

      'home': 'Home',

      'search': 'Search',

      'search_hint': 'Search courses, subjects...',

      'all': 'All',

      'stream_active': 'Current Stream',

      'cancel': 'Cancel',

      'close': 'Close',

      'submit': 'Confirm',

      'comment': 'Comment',

      'details': 'Course Details',

      'curriculum': 'Syllabus & Lessons',

      'minutes': 'min',

      'unlock_course': 'Subscribe to Course',

      'add_review': 'Write a Review',

      'downloads': 'Downloads',

      'delete': 'Delete',

      'ok': 'OK',

      'success': 'Success',

      'payment_upload': 'Unlock Course',

      'select_payment_method': 'Select Payment Method',

      'submit_verification': 'Submit for Activation',

      'required': 'required',

      'welcome_back': 'Welcome Back!',

      'splash_loading': 'Preparing your learning journey...',

      'login_subtitle': 'Sign in to continue your preparation',

      'no_account': 'Don\'t have an account?',

      'register_now': 'Register Now',

      'have_account': 'Already have an account?',

      'create_account': 'Create Account',

      'register_subtitle': 'Register to join Basma Academy platform',

      'or': 'OR',

      'sign_in_google': 'Sign in with Google',

      'send_otp': 'Send OTP to Phone',

      'register': 'Register',

      'name': 'Full Name',

      'feed': 'Announcements',

      'no_announcements': 'No teacher announcements posted yet.',

      'no_subjects_available': 'No subjects available yet.',

      'no_courses_available': 'No courses available yet.',

      'likes': 'Likes',

      'comments': 'Comments',

      'no_comments': 'No comments yet. Be the first to comment!',

      'no_comments_yet': 'No comments yet. Be the first to comment!',

      'add_comment_hint': 'Write a comment...',

      'post': 'Post',

      'day_ago': '1 day ago',

      'days_ago': '@days days ago',

      'hour_ago': '1 hour ago',

      'hours_ago': '@hours hours ago',

      'minute_ago': '1 minute ago',

      'minutes_ago': '@minutes minutes ago',

      'just_now': 'Just now',

      'theme': 'Theme',

      'verification_queue': 'Verification & Payments',

      'no_verification_requests': 'No activation requests submitted yet.',

      'upload_receipt': 'Upload Payment Receipt',

      'reference_number_hint': 'Reference Number (Optional)',

      'ccl_talon': 'Receipt Photo (Must be readable)',

      'reject_reason_label': 'Reason: ',

      'edit_profile': 'Edit Profile',

      'save_changes': 'Save Changes',

      'profile_updated_success': 'Profile updated successfully',

      'notifications': 'Notifications',

      'privacy': 'Privacy Policy',

      'privacy_title': 'Privacy & Data Protection',

      'notifications_settings': 'Study Notifications & Reminders',

      'rate_app': 'Rate App',

      'version': 'Version',

      'quiz': 'Assessment Quiz',

      'no_quiz_questions': 'No questions available for this quiz.',

      'points': 'pts',

      'previous': 'Previous',

      'next_question': 'Next Question',

      'submit_quiz': 'Finish & Submit Quiz 🚀',

      'quiz_passed': 'Congratulations! You passed the quiz 🎉',

      'quiz_failed': 'Quiz not passed this time 🔴',

      'score_label': 'Final Score',

      'correct_questions': 'correct answers',

      'answer_breakdown': 'Answer Breakdown & Explanations 💡',

      'retake_quiz': 'Retake Quiz 🔄',

      'info': 'Information',

      'account': 'Account',

      'no_downloads': 'No downloaded lessons found.',

      'storage_used': 'Storage space occupied:',

      'email': 'Email Address',

      'password': 'Password',

      'forgot_password': 'Forgot Password?',

      'password_min': 'Password must be at least 6 characters.',

      'enter_otp_hint': 'Enter the 6-digit verification code.',

      'name_required': 'Full name is required for registration.',

      'name_hint': 'Enter full name',

      'email_hint': 'Enter email address',

      'password_hint': 'Enter password',

      'otp_hint': 'Enter verification code',

      'BAC_Sciences': 'BAC Experimental Sciences',

      'BAC_Maths': 'BAC Mathematics',

      'BAC_Technique': 'BAC Technical Mathematics',

      'BAC_Lettres': 'BAC Letters & Philosophy',

      'BAC_Languages': 'BAC Foreign Languages',

      'BAC_Gestion': 'BAC Management & Economics',

      'bac_countdown': 'BAC 2026 Countdown',

      'days_left': 'days left',

      'countdown_sub': 'Ready to start your preparation journey?',

      'subj_natural_sciences': 'Natural Sciences',

      'subj_physics': 'Physics',

      'subj_maths': 'Mathematics',

      'subj_arabic': 'Arabic',

      'subj_philosophy': 'Philosophy',

      'course_lessons': 'Lessons',

      'course_reviews': 'Reviews',

      'course_preview': 'Free Preview',

      'course_buy': 'Subscribe to Course',

      'course_unlocked': 'Access Granted',

      'course_rating_label': 'Out of 5 stars',

      'course_empty_lessons': 'No lessons uploaded yet.',

      'course_empty_reviews': 'No reviews yet. Be the first to leave feedback!',

      'study_tools': 'Study Tools',

      'ai_tutor_label': 'Basma AI',

      'flashcards_label': 'Flashcards',

      'announcements_label': 'Announcements',

      'filter_courses': 'Filter Courses',

      'subject': 'Subject',

      'content_type': 'Content Type',

      'sort_by': 'Sort By',

      'apply_filters': 'Apply Filters',

      'reset': 'Reset',

      'no_subjects': 'No subjects available currently.',

      'notifications_empty': 'No new notifications currently',

      'mark_all_read': 'Mark all as read',

      'ai_tutor_title': 'Basma AI',

      'ai_tutor_status': 'Online and ready ⚡',

      'ai_tutor_hint': 'Ask your question here in Arabic or French...',

      'ai_thinking': 'Thinking and generating response...',

      'ai_response_received': 'Response received successfully.',

      'clear_chat_title': 'Clear Chat History',

      'clear_chat_action': 'Clear Chat',

      'confirm': 'Confirm',

      'notice': 'Notice',

      'error': 'Error',

      'flashcards_title': 'Smart Flashcards',

      'no_flashcards': 'No review cards available currently.',

      'restart_review': 'Restart Review',

      'show_answer': 'Show Answer',

      'grade_hard': 'Very Hard 🔴',

      'grade_medium': 'Medium 🟡',

      'grade_easy': 'Very Easy 🟢',

      'quote_1': 'Success is the sum of small efforts repeated day in and day out 🌟',

      'quote_2': 'The BAC is your stepping stone towards a bright future 🎓',

      'quote_3': 'Excellence is the result of consistent effort and smart preparation 🚀',

      'quote_4': 'Believe in yourself; every study session brings you closer to your goal ✨',

      'quote_5': 'Daily discipline is what separates dreamers from achievers 🏆',

      'tip_BAC_Sciences_1':
          'Connect experimental data with results using precise scientific terminology! 🧬',
      'tip_BAC_Sciences_2':
          'Solving previous BAC papers with model answers is the key to a full score! 💯',
      'tip_BAC_Sciences_3':
          'Focus on methodology: Analysis, Interpretation, and Deduction in Natural Sciences! 📝',
      'tip_BAC_Maths_1':
          'Daily practice on diverse math problems improves your speed and accuracy! 📐',
      'tip_BAC_Maths_2':
          'Understanding proof steps and mastering function analysis guarantees top scores! 🎯',
      'tip_BAC_Maths_3':
          'Never skip hard questions; attempt them and learn from your mistakes! 💡',
      'tip_BAC_Technique_1':
          'Mastering physics laws and applying them directly boosts your level fast! ⚡',
      'tip_BAC_Technique_2':
          'Understanding engineering and electrical diagrams makes solving problems easy! 🛠️',
      'tip_BAC_Lettres_1':
          'Reading and memorizing philosophical quotes enriches your essay! 📚',
      'tip_BAC_Lettres_2':
          'Practicing grammar parsing and text analysis ensures an excellent score in Arabic! ✍️',
      'tip_BAC_Languages_1':
          'Listen daily to audio materials and apply grammar in essay writing! 🎧',
      'tip_BAC_Languages_2':
          'Enriching your vocabulary with high-frequency BAC terms guarantees success! 🌍',
      'tip_BAC_Gestion_1':
          'Practice preparing balance sheets and income statements with high accuracy! 📈',
      'tip_BAC_Gestion_2':
          'Memorize economic definitions and accounting rules with direct application! 💼',
      'all_subjects_filter': 'All Subjects',

      'quizzes_list_title': 'Quiz Assessment List',

      'quiz_subtitle_heading': 'Choose your subject assessment quiz 🎯',

      'quiz_subtitle_desc': 'Test your comprehension level with realistic BAC exam questions',

      'questions_count_label': 'questions',

      'minutes_label': 'min',

      'start_quiz': 'Start Quiz',

      'no_quizzes_available': 'No quizzes available for this subject at the moment',

      'about_us': 'About Basma Academy',

      'skip': 'Skip',

    },
  };
}