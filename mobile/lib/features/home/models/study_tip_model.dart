class StudyTipModel {
  final int id;
  final String title;
  final String content;
  final String? icon;

  StudyTipModel({
    required this.id,
    required this.title,
    required this.content,
    this.icon,
  });

  factory StudyTipModel.fromJson(Map<String, dynamic> json) {
    return StudyTipModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      icon: json['icon'],
    );
  }
}
