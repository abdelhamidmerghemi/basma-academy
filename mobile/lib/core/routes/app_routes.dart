import 'package:get/get.dart';
import '../../features/auth/views/onboarding_view.dart';
import '../../features/auth/views/login_view.dart';
import '../../features/auth/views/register_view.dart';
import '../../features/auth/views/otp_view.dart';
import '../../features/dashboard/views/dashboard_view.dart';
import '../../features/dashboard/bindings/dashboard_binding.dart';
import '../../features/catalog/views/course_details_view.dart';
import '../../features/lessons/views/video_player_view.dart';
import '../../features/payments/views/payment_view.dart';
import '../../features/profile/views/profile_tab.dart';
import '../../features/auth/views/splash_view.dart';
import '../../features/catalog/controllers/course_details_controller.dart';
import '../../features/profile/views/payments_tracker_screen.dart';
import '../../features/profile/controllers/profile_controller.dart';
import '../../features/profile/views/edit_profile_view.dart';
import '../../features/ai_tutor/views/ai_tutor_view.dart';
import '../../features/ai_tutor/controllers/ai_tutor_controller.dart';
import '../../features/flashcards/views/flashcards_view.dart';
import '../../features/flashcards/controllers/flashcard_controller.dart';

import '../../features/quizzes/views/quiz_view.dart';
import '../../features/quizzes/controllers/quiz_controller.dart';
import '../../features/profile/views/teacher_profile_view.dart';
import '../../features/profile/controllers/teacher_profile_controller.dart';
import '../../features/forum/views/forum_feed_view.dart';
import '../../features/forum/controllers/forum_controller.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String dashboard = '/dashboard';
  static const String courseDetails = '/course-details';
  static const String COURSE_DETAILS = '/course-details';
  static const String videoPlayer = '/video-player';
  static const String payment = '/payment';
  static const String paymentsTracker = '/payments-tracker';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String aiTutor = '/ai-tutor';
  static const String flashcards = '/flashcards';
  static const String quiz = '/quiz';
  static const String TEACHER_PROFILE = '/teacher-profile';
  static const String forum = '/forum';

  static final routes = [
    GetPage(
      name: splash,
      page: () => const SplashView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: onboarding,
      page: () => const OnboardingView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: login,
      page: () => const LoginView(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: register,
      page: () => const RegisterView(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: otp,
      page: () => const OtpView(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: courseDetails,
      page: () => const CourseDetailsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<CourseDetailsController>(() => CourseDetailsController());
      }),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: videoPlayer,
      page: () => const VideoPlayerView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: payment,
      page: () => const PaymentView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<ProfileController>()) {
          Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
        }
      }),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: paymentsTracker,
      page: () => const PaymentsTrackerScreen(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<ProfileController>()) {
          Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
        }
      }),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: profile,
      page: () => const ProfileTab(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: editProfile,
      page: () => const EditProfileView(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: aiTutor,
      page: () => const AiTutorView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<AiTutorController>()) {
          Get.lazyPut<AiTutorController>(() => AiTutorController(), fenix: true);
        }
      }),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: flashcards,
      page: () => const FlashcardsView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<FlashcardController>()) {
          Get.lazyPut<FlashcardController>(() => FlashcardController(), fenix: true);
        }
      }),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: quiz,
      page: () => const QuizView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<QuizController>()) {
          Get.lazyPut<QuizController>(() => QuizController(), fenix: true);
        }
      }),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: TEACHER_PROFILE,
      page: () => const TeacherProfileView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<TeacherProfileController>()) {
          Get.lazyPut<TeacherProfileController>(() => TeacherProfileController(), fenix: true);
        }
      }),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: forum,
      page: () => const ForumFeedView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<ForumController>()) {
          Get.lazyPut<ForumController>(() => ForumController(), fenix: true);
        }
      }),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}
