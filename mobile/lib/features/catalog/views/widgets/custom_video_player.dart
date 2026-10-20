import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../controllers/course_details_controller.dart';

class CustomVideoPlayer extends StatelessWidget {
  final CourseDetailsController controller = Get.find<CourseDetailsController>();

  CustomVideoPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isPlayerReady.value ||
          controller.videoPlayerController == null) {
        return const AspectRatio(
          aspectRatio: 16 / 9,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      final aspectRatio = controller.videoPlayerController!.value.aspectRatio;

      return AspectRatio(
        aspectRatio: aspectRatio > 0 ? aspectRatio : (16 / 9),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: aspectRatio > 0 ? aspectRatio : (16 / 9),
                child: VideoPlayer(controller.videoPlayerController!),
              ),
            ),

            _buildDoubleTapOverlay(context),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: controller.showControls.value
                  ? _buildControls(context)
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDoubleTapOverlay(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    // Seek deltas:
    // LTR: Left = -10s (Rewind), Right = +10s (Forward)
    // RTL: Left = +10s (Forward <+), Right = -10s (Rewind ->)
    final leftDelta = isRtl ? 10 : -10;
    final rightDelta = isRtl ? -10 : 10;

    final leftFeedback = leftDelta < 0 ? controller.showBackwardFeedback : controller.showForwardFeedback;
    final rightFeedback = rightDelta < 0 ? controller.showBackwardFeedback : controller.showForwardFeedback;

    // Physical Right side always uses CupertinoIcons.forward_fill (>>)
    const leftIcon = CupertinoIcons.backward_fill;
    const rightIcon = CupertinoIcons.forward_fill;

    return Directionality(
      textDirection: TextDirection.ltr, // Enforce physical screen layout
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: controller.toggleControls,
              onDoubleTap: () => controller.seekRelative(leftDelta),
              child: Obx(
                () => AnimatedOpacity(
                  opacity: leftFeedback.value ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    color: Colors.black12,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            leftIcon,
                            color: Colors.white,
                            size: 40,
                          ),
                          Obx(
                            () => Text(
                              "${controller.seekAccumulator.value}s",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: controller.toggleControls,
              child: Container(color: Colors.transparent),
            ),
          ),

          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: controller.toggleControls,
              onDoubleTap: () => controller.seekRelative(rightDelta),
              child: Obx(
                () => AnimatedOpacity(
                  opacity: rightFeedback.value ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    color: Colors.black12,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            rightIcon,
                            color: Colors.white,
                            size: 40,
                          ),
                          Obx(
                            () => Text(
                              "${controller.seekAccumulator.value}s",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.4), Colors.transparent],
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    CupertinoIcons.chevron_down,
                    color: Colors.white,
                  ),
                  onPressed: controller.goBackFullscreen,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    CupertinoIcons.settings,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: controller.resetAutoHideTimer,
                ),
              ],
            ),
          ),
        ),

        Center(
          child: Obx(
            () => IconButton(
              iconSize: 64,
              icon: Icon(
                controller.isPlaying.value
                    ? CupertinoIcons.pause_fill
                    : CupertinoIcons.play_fill,
                color: Colors.white,
              ),
              onPressed: () {
                controller.togglePlay();
                controller.resetAutoHideTimer();
              },
            ),
          ),
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.only(top: 20), // Padding for gradient
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
              ),
            ),
            child: _buildBottomBar(context),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4, top: 0),
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 24,
            child: _buildProgressBar(context),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Obx(
                () => Text(
                  _formatDuration(controller.position.value),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const Text(
                ' / ',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Obx(
                () => Text(
                  _formatDuration(controller.duration.value),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),

              const Spacer(),

              Obx(() => _buildSpeedButton(context)),

              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  CupertinoIcons.fullscreen,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  controller.toggleFullScreen();
                  controller.resetAutoHideTimer();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      final total = controller.duration.value.inMilliseconds.toDouble();
      final current = controller.position.value.inMilliseconds.toDouble();

      return SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 4,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          activeTrackColor: theme.primaryColor,
          inactiveTrackColor: Colors.white24,
          thumbColor: theme.primaryColor,
        ),
        child: Slider(
          value: current.clamp(0, total),
          max: total > 0 ? total : 1.0,
          onChangeStart: (_) => controller.onDragStart(),
          onChangeEnd: (_) => controller.onDragEnd(),
          onChanged: (value) {
            controller.onDragUpdate(Duration(milliseconds: value.toInt()));
          },
        ),
      );
    });
  }

  Widget _buildSpeedButton(BuildContext context) {
    return PopupMenuButton<double>(
      initialValue: controller.playbackSpeed.value,
      tooltip: 'Playback Speed',
      onSelected: controller.setSpeed,
      itemBuilder: (context) => [0.5, 0.75, 1.0, 1.25, 1.5, 2.0].map((speed) {
        return PopupMenuItem<double>(value: speed, child: Text('${speed}x'));
      }).toList(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            const Icon(
              CupertinoIcons.speedometer,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 4),
            Text(
              '${controller.playbackSpeed.value}x',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      return '${twoDigits(duration.inHours)}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }
}
