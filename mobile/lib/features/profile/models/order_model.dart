import '../../catalog/models/course_model.dart';

class OrderModel {
  final int id;
  final String paymentMethod;
  final String status;
  final String? referenceNumber;
  final String? rejectReason;
  final String receiptImageUrl;
  final DateTime createdAt;
  final CourseModel? course;

  OrderModel({
    required this.id,
    required this.paymentMethod,
    required this.status,
    this.referenceNumber,
    this.rejectReason,
    required this.receiptImageUrl,
    required this.createdAt,
    this.course,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      paymentMethod: json['payment_method'] ?? '',
      status: json['status'] ?? 'pending',
      referenceNumber: json['reference_number'],
      rejectReason: json['reject_reason'],
      receiptImageUrl: json['receipt_image_url'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      course: json['course'] != null ? CourseModel.fromJson(json['course']) : null,
    );
  }
}
