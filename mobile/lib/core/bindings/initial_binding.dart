import 'package:get/get.dart';
import '../network/api_client.dart';
import '../../features/auth/controllers/auth_controller.dart';
import '../../features/catalog/services/catalog_api.dart';
import '../../features/catalog/controllers/catalog_controller.dart';
import '../../features/ai_tutor/services/ai_tutor_api.dart';
import '../../features/ai_tutor/controllers/ai_tutor_controller.dart';
import '../../features/flashcards/services/flashcard_api.dart';
import '../../features/flashcards/controllers/flashcard_controller.dart';
import '../../features/notifications/services/notification_api.dart';
import '../../features/notifications/controllers/notification_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ApiClient>(ApiClient(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
    
    Get.lazyPut<CatalogApi>(() => CatalogApi(), fenix: true);
    Get.lazyPut<CatalogController>(() => CatalogController(), fenix: true);

    Get.lazyPut<AiTutorApi>(() => AiTutorApi(), fenix: true);
    Get.lazyPut<AiTutorController>(() => AiTutorController(), fenix: true);

    Get.lazyPut<FlashcardApi>(() => FlashcardApi(), fenix: true);
    Get.lazyPut<FlashcardController>(() => FlashcardController(), fenix: true);

    Get.lazyPut<NotificationApi>(() => NotificationApi(), fenix: true);
    Get.lazyPut<NotificationController>(() => NotificationController(), fenix: true);
  }
}
