import 'dart:convert';
import 'package:get/get.dart';

class NotificationModel {
  final int id;
  final String? titleAr;
  final String? titleFr;
  final String? titleEn;
  final String? bodyAr;
  final String? bodyFr;
  final String? bodyEn;
  final String title;
  final String body;
  final String type;
  final Map<String, dynamic>? payload;
  final String? imageUrl;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    this.titleAr,
    this.titleFr,
    this.titleEn,
    this.bodyAr,
    this.bodyFr,
    this.bodyEn,
    required this.title,
    required this.body,
    required this.type,
    this.payload,
    this.imageUrl,
    required this.isRead,
    required this.createdAt,
  });

    String get localizedTitle {
    final lang = Get.locale?.languageCode ?? 'ar';
    if (lang == 'fr' && titleFr != null && titleFr!.isNotEmpty) return titleFr!;
    if (lang == 'en' && titleEn != null && titleEn!.isNotEmpty) return titleEn!;
    if (titleAr != null && titleAr!.isNotEmpty) return titleAr!;
    return title.isNotEmpty ? title : 'notifications'.tr;
  }

    String get localizedBody {
    final lang = Get.locale?.languageCode ?? 'ar';
    if (lang == 'fr' && bodyFr != null && bodyFr!.isNotEmpty) return bodyFr!;
    if (lang == 'en' && bodyEn != null && bodyEn!.isNotEmpty) return bodyEn!;
    if (bodyAr != null && bodyAr!.isNotEmpty) return bodyAr!;
    return body;
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? parsedPayload;
    if (json['payload'] != null) {
      if (json['payload'] is Map) {
        parsedPayload = Map<String, dynamic>.from(json['payload']);
      } else if (json['payload'] is String) {
        try {
          parsedPayload = Map<String, dynamic>.from(jsonDecode(json['payload']));
        } catch (_) {}
      }
    }

    return NotificationModel(
      id: json['id'] ?? 0,
      titleAr: json['title_ar'],
      titleFr: json['title_fr'],
      titleEn: json['title_en'],
      bodyAr: json['body_ar'],
      bodyFr: json['body_fr'],
      bodyEn: json['body_en'],
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? 'general',
      payload: parsedPayload,
      imageUrl: json['image_url'],
      isRead: json['is_read'] == true || json['pivot']?['is_read'] == true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
