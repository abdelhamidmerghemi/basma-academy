import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/theme/premium_interactions.dart';
import '../../../core/widgets/custom_profile_avatar.dart';
import '../../../core/widgets/smart_image.dart';
import '../controllers/forum_controller.dart';
import '../models/forum_post_model.dart';
import '../models/forum_reply_model.dart';

class PostDetailsView extends GetView<ForumController> {
  final int postId;
  const PostDetailsView({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    controller.fetchPostDetails(postId);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('post_details_title'.tr),
        centerTitle: false,
      ),
      body: Obx(() {
        if (controller.isLoadingDetails.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final post = controller.currentPost.value;
        if (post == null) {
          return Center(child: Text('no_posts_found'.tr));
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomProfileAvatar(
                          avatarUrl: post.userAvatar,
                          name: post.userName,
                          radius: 22,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(post.userName, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                            Text(controller.timeAgo(post.createdAt), style: theme.textTheme.bodySmall?.copyWith(color: theme.disabledColor)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Text(post.title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 10),
                    Text(
                      post.content,
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.55),
                    ),

                    if (post.imagePath != null && post.imagePath!.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      SmartImage(
                        imagePath: post.imagePath,
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ],

                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Text(
                          'answers_and_discussions'.trParams({'count': '${post.replies.length}'}),
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (post.replies.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text('no_replies_yet'.tr, style: TextStyle(color: theme.disabledColor)),
                        ),
                      )
                    else
                      ...post.replies.map((reply) => _ReplyCard(post: post, reply: reply, controller: controller)),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: theme.cardColor,
                border: Border(top: BorderSide(color: theme.dividerColor.withOpacity(0.4))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.replyContentController,
                      decoration: InputDecoration(
                        hintText: 'write_reply_hint'.tr,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                        filled: true,
                        fillColor: theme.scaffoldBackgroundColor,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Obx(() {
                    return IconButton(
                      onPressed: controller.isSubmitting.value
                          ? null
                          : () {
                              HapticHelper.mediumTap();
                              controller.addReply(post.id);
                            },
                      icon: controller.isSubmitting.value
                          ? const CupertinoActivityIndicator()
                          : Icon(Icons.send_rounded, color: theme.primaryColor),
                    );
                  }),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _ReplyCard extends StatelessWidget {
  final ForumPostModel post;
  final ForumReplyModel reply;
  final ForumController controller;

  const _ReplyCard({required this.post, required this.reply, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: reply.isBestAnswer ? Colors.green.withOpacity(0.08) : theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: reply.isBestAnswer ? Colors.green.withOpacity(0.4) : theme.dividerColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (reply.isBestAnswer) ...[
            Row(
              children: [
                const Icon(Icons.workspace_premium_rounded, color: Colors.green, size: 18),
                const SizedBox(width: 6),
                Text(
                  'approved_best_answer'.tr,
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],

          Row(
            children: [
              CustomProfileAvatar(avatarUrl: reply.userAvatar, name: reply.userName, radius: 16),
              const SizedBox(width: 8),
              Text(reply.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),

              InkWell(
                onTap: () {
                  HapticHelper.lightTap();
                  controller.toggleReplyLike(reply.id);
                },
                child: Row(
                  children: [
                    Icon(
                      reply.isLiked ? CupertinoIcons.hand_thumbsup_fill : CupertinoIcons.hand_thumbsup,
                      size: 16,
                      color: reply.isLiked ? theme.primaryColor : theme.disabledColor,
                    ),
                    const SizedBox(width: 4),
                    Text('${reply.likesCount}', style: TextStyle(fontSize: 12, color: reply.isLiked ? theme.primaryColor : null)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(reply.content, style: theme.textTheme.bodyMedium?.copyWith(height: 1.45)),

          if (!reply.isBestAnswer && post.type == 'question') ...[
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {
                HapticHelper.mediumTap();
                controller.markBestAnswer(reply.id);
              },
              icon: const Icon(Icons.star_outline_rounded, size: 16, color: Colors.amber),
              label: Text('mark_as_best_answer'.tr, style: const TextStyle(fontSize: 12, color: Colors.amber)),
            ),
          ],
        ],
      ),
    );
  }
}
