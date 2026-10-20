import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubjectModel {
  final int id;
  final String nameAr;
  final String nameFr;
  final String nameEn;
  final String? iconName;
  final String? colorHex;
  final String? thumbnailPath;

  SubjectModel({
    required this.id,
    required this.nameAr,
    required this.nameFr,
    required this.nameEn,
    this.iconName,
    this.colorHex,
    this.thumbnailPath,
  });

    String get name {
    final lang = Get.locale?.languageCode ?? 'ar';
    if (lang == 'fr' && nameFr.isNotEmpty) return nameFr;
    if (lang == 'en' && nameEn.isNotEmpty) return nameEn;
    if (nameAr.isNotEmpty) return nameAr;
    return nameFr.isNotEmpty ? nameFr : nameEn;
  }

      static const Map<String, IconData> _iconMap = {
    'calculate_rounded': Icons.calculate_rounded,
    'bolt_rounded': Icons.bolt_rounded,
    'eco_rounded': Icons.eco_rounded,
    'science_rounded': Icons.science_rounded,
    'translate_rounded': Icons.translate_rounded,
    'psychology_rounded': Icons.psychology_rounded,
    'auto_stories_rounded': Icons.auto_stories_rounded,
    'public_rounded': Icons.public_rounded,
    'analytics_rounded': Icons.analytics_rounded,
    'settings_suggest_rounded': Icons.settings_suggest_rounded,
    'computer_rounded': Icons.computer_rounded,
    'history_edu_rounded': Icons.history_edu_rounded,
    'menu_book_rounded': Icons.menu_book_rounded,
  };

    IconData get iconData => _iconMap[iconName] ?? Icons.menu_book_rounded;

    Color get iconColor {
    if (colorHex == null || colorHex!.isEmpty) return Colors.blue;
    final hex = colorHex!.replaceAll('#', '');
    return Color(int.tryParse('FF$hex', radix: 16) ?? 0xFF2563EB);
  }

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    final rawName = json['name'] as String? ?? '';
    return SubjectModel(
      id: json['id'] is int ? json['id'] : (int.tryParse(json['id']?.toString() ?? '0') ?? 0),
      nameAr: json['name_ar'] as String? ?? rawName,
      nameFr: json['name_fr'] as String? ?? rawName,
      nameEn: json['name_en'] as String? ?? rawName,
      iconName: json['icon_name'] as String?,
      colorHex: json['color_hex'] as String?,
      thumbnailPath: json['thumbnail_path'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'name_fr': nameFr,
      'name_en': nameEn,
      'icon_name': iconName,
      'color_hex': colorHex,
      'thumbnail_path': thumbnailPath,
    };
  }
}
