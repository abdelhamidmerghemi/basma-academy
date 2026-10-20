import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/announcement_controller.dart';
import '../models/announcement_model.dart';
import 'widgets/announcement_card.dart';
import 'widgets/comments_bottom_sheet.dart';

class AnnouncementsTab extends GetView<AnnouncementController> {
  const AnnouncementsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 8.0),
              child: Text(
                'feed'.tr,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.announcements.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () => controller.fetchAnnouncements(),
                    child: ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.campaign_rounded,
                                  size: 72,
                                  color: theme.primaryColor.withOpacity(0.4),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'no_announcements'.tr,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controller.fetchAnnouncements(),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                    itemCount: controller.announcements.length,
                    itemBuilder: (context, index) {
                      final item = controller.announcements[index];
                      return AnnouncementCard(
                        item: item,
                        controller: controller,
                        onCommentTap: () => _showCommentsBottomSheet(context, item),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showCommentsBottomSheet(BuildContext context, AnnouncementModel item) {
    controller.fetchComments(item.id);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (context) => CommentsBottomSheet(item: item, controller: controller),
    );
  }
}
