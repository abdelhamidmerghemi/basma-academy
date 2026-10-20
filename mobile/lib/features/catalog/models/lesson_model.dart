class LessonModel {
  final int id;
  final String title;
  final int durationSeconds;
  final String videoPath;
  final bool isPreview;
  final bool isCompleted;
  final int lastPositionSeconds;
  final String? summaryText;

  LessonModel({
    required this.id,
    required this.title,
    required this.durationSeconds,
    required this.videoPath,
    required this.isPreview,
    this.isCompleted = false,
    this.lastPositionSeconds = 0,
    this.summaryText,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      durationSeconds: json['duration_seconds'] ?? 0,
      videoPath: json['video_path'] ?? '',
      isPreview: json['is_preview'] ?? false,
      isCompleted: json['is_completed'] ?? false,
      lastPositionSeconds: json['last_position_seconds'] ?? 0,
      summaryText: json['summary_text'],
    );
  }

  LessonModel copyWith({
    bool? isCompleted,
    int? lastPositionSeconds,
    String? summaryText,
  }) {
    return LessonModel(
      id: id,
      title: title,
      durationSeconds: durationSeconds,
      videoPath: videoPath,
      isPreview: isPreview,
      isCompleted: isCompleted ?? this.isCompleted,
      lastPositionSeconds: lastPositionSeconds ?? this.lastPositionSeconds,
      summaryText: summaryText ?? this.summaryText,
    );
  }
}
