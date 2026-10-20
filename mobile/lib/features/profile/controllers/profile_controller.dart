import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, MultipartFile, FormData;
import 'package:dio/dio.dart' as dio;
import '../../../core/network/api_exception.dart';
import '../models/order_model.dart';
import '../services/profile_api.dart';

class ProfileController extends GetxController {
  final ProfileApi _profileApi = Get.put(ProfileApi());

  final userOrders = <OrderModel>[].obs;
  final isLoading = false.obs;
  final isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    isLoading.value = true;
    try {
      final response = await _profileApi.getOrders();
      if (response.data['success'] == true) {
        final List list = response.data['data'] ?? [];
        userOrders.value = list.map((json) => OrderModel.fromJson(json)).toList();
      }
    } on ApiException catch (e) {
      debugPrint('fetchOrders API exception: ${e.message}');
    } catch (e) {
      debugPrint('fetchOrders error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  final paymentMethod = 'BaridiMob'.obs;
  final receiptImageFile = Rxn<File>();
  final referenceController = TextEditingController();

  void setPaymentMethod(String method) {
    paymentMethod.value = method;
  }

  void clearPaymentForm() {
    paymentMethod.value = 'BaridiMob';
    receiptImageFile.value = null;
    referenceController.clear();
  }

  @override
  void onClose() {
    referenceController.dispose();
    super.onClose();
  }

  Future<bool> submitOrder({
    required int courseId,
    required String paymentMethod,
    required String? referenceNumber,
    required File imageFile,
  }) async {
    isSubmitting.value = true;
    try {
      final formData = dio.FormData.fromMap({
        'course_id': courseId,
        'payment_method': paymentMethod,
        if (referenceNumber != null && referenceNumber.trim().isNotEmpty)
          'reference_number': referenceNumber.trim(),
        'receipt_image': await dio.MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final response = await _profileApi.submitOrder(formData);
      if (response.data['success'] == true) {
        final newOrder = OrderModel.fromJson(response.data['data']);
        userOrders.insert(0, newOrder); // Prepend to orders queue
        
        Get.snackbar(
          'success'.tr,
          'receipt_uploaded_success'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      }
    } on ApiException catch (e) {
      Get.snackbar(
        'error'.tr,
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('submitOrder error: $e');
      Get.snackbar(
        'error'.tr,
        'unexpected_error'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
    return false;
  }
}
