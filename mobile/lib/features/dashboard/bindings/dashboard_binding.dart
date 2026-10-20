import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../catalog/controllers/catalog_controller.dart';
import '../../announcements/controllers/announcement_controller.dart';
import '../../home/controllers/study_tip_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<CatalogController>(() => CatalogController());
    Get.lazyPut<AnnouncementController>(() => AnnouncementController());
    Get.lazyPut<StudyTipController>(() => StudyTipController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
