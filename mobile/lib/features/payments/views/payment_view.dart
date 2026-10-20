import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../catalog/models/course_model.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';

class PaymentView extends GetView<ProfileController> {
  const PaymentView({super.key});

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(
        source: source,
        maxWidth: 2000,
        maxHeight: 2000,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        controller.receiptImageFile.value = File(pickedFile.path);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showImageSourcePicker(BuildContext context) {
    final theme = Theme.of(context);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          border: Border.all(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'choose_image'.tr,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      _pickImage(ImageSource.camera);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: theme.primaryColor.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(CupertinoIcons.camera_fill, color: theme.primaryColor, size: 28),
                          const SizedBox(height: 8),
                          Text(
                            'camera'.tr,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      _pickImage(ImageSource.gallery);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: theme.primaryColor.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(CupertinoIcons.photo_fill, color: theme.primaryColor, size: 28),
                          const SizedBox(height: 8),
                          Text(
                            'gallery'.tr,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'success'.tr,
      'copy_success'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> _handleSubmit(BuildContext context, CourseModel course) async {
    if (controller.receiptImageFile.value == null) {
      Get.snackbar(
        'error'.tr,
        'upload_talon_proof'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    final success = await controller.submitOrder(
      courseId: course.id,
      paymentMethod: controller.paymentMethod.value,
      referenceNumber: controller.referenceController.text,
      imageFile: controller.receiptImageFile.value!,
    );

    if (success) {
      _showSuccessDialog(Get.context ?? context);
    }
  }

  void _showSuccessDialog(BuildContext context) {
    final theme = Theme.of(context);

    Get.dialog(
      BarrierDismissibleDialog(
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    size: 48,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'success'.tr,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'receipt_uploaded_success'.tr,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  text: 'payments_tracker'.tr,
                  onPressed: () {
                    Get.back(); // Dismiss dialog
                    Get.offNamed(AppRoutes.paymentsTracker);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final CourseModel course = Get.arguments as CourseModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'payment_upload'.tr,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: theme.dividerColor,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              width: 72,
                              height: 72,
                              child: course.thumbnailPath != null && course.thumbnailPath!.isNotEmpty
                                  ? Image.network(course.thumbnailPath!, fit: BoxFit.cover)
                                  : Container(color: theme.primaryColor.withOpacity(0.1)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${course.priceDzd.toInt()} ${'dzd'.tr}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'select_payment_method'.tr,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Obx(() => Row(
                          children: [
                            Expanded(
                              child: _buildMethodSelectorCard(
                                context: context,
                                label: 'BaridiMob',
                                icon: CupertinoIcons.creditcard_fill,
                                isActive: controller.paymentMethod.value == 'BaridiMob',
                                onTap: () => controller.setPaymentMethod('BaridiMob'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildMethodSelectorCard(
                                context: context,
                                label: 'CCP',
                                icon: Icons.account_balance_rounded,
                                isActive: controller.paymentMethod.value == 'CCP',
                                onTap: () => controller.setPaymentMethod('CCP'),
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(height: 24),

                    Obx(() => Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: theme.dividerColor,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    controller.paymentMethod.value == 'BaridiMob'
                                        ? CupertinoIcons.creditcard_fill
                                        : Icons.account_balance_rounded,
                                    color: theme.primaryColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    controller.paymentMethod.value == 'BaridiMob'
                                        ? 'BaridiMob Transfer'
                                        : 'CCP Account Transfer',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Divider(height: 1),
                              const SizedBox(height: 16),
                              _buildCredentialRow(
                                context: context,
                                label: 'ccp_holder'.tr,
                                value: 'BASMA ACADEMY ED',
                              ),
                              const SizedBox(height: 12),
                              _buildCredentialRow(
                                context: context,
                                label: controller.paymentMethod.value == 'BaridiMob' ? 'RIP' : 'ccp_number'.tr,
                                value: controller.paymentMethod.value == 'BaridiMob'
                                    ? '00799999002222223344'
                                    : '12345678',
                                isCopyable: true,
                              ),
                              if (controller.paymentMethod.value == 'CCP') ...[
                                const SizedBox(height: 12),
                                _buildCredentialRow(
                                  context: context,
                                  label: 'rip_key'.tr,
                                  value: '99',
                                  isCopyable: true,
                                ),
                              ],
                            ],
                          ),
                        )),
                    const SizedBox(height: 24),

                    CustomTextField(
                      controller: controller.referenceController,
                      labelText: 'reference'.tr,
                      hintText: 'reference_number_hint'.tr,
                      prefixIcon: CupertinoIcons.number,
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'upload_talon'.tr,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(() => GestureDetector(
                          onTap: () => _showImageSourcePicker(context),
                          child: controller.receiptImageFile.value == null
                              ? Container(
                                  width: double.infinity,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    color: theme.inputDecorationTheme.fillColor,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: theme.primaryColor.withOpacity(0.3),
                                      style: BorderStyle.solid,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(CupertinoIcons.cloud_upload_fill, color: theme.primaryColor, size: 40),
                                      const SizedBox(height: 12),
                                      Text(
                                        'choose_image'.tr,
                                        style: theme.textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                        child: Text(
                                          'upload_talon_proof'.tr,
                                          textAlign: TextAlign.center,
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 220,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: theme.dividerColor,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(19),
                                        child: Image.file(controller.receiptImageFile.value!, fit: BoxFit.cover),
                                      ),
                                    ),
                                    Positioned(
                                      top: 12,
                                      right: 12,
                                      child: GestureDetector(
                                        onTap: () => controller.receiptImageFile.value = null,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: const BoxDecoration(
                                            color: Colors.redAccent,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(CupertinoIcons.trash_fill, color: Colors.white, size: 18),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        )),
                  ],
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Obx(
                () => PrimaryButton(
                  text: 'submit_verification'.tr,
                  isLoading: controller.isSubmitting.value,
                  onPressed: () => _handleSubmit(context, course),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodSelectorCard({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isActive
              ? theme.primaryColor.withOpacity(0.08)
              : theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? theme.primaryColor : theme.dividerColor,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? theme.primaryColor : theme.textTheme.bodySmall?.color,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isActive ? theme.primaryColor : theme.textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCredentialRow({
    required BuildContext context,
    required String label,
    required String value,
    bool isCopyable = false,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: isCopyable ? 0.5 : null,
                ),
              ),
            ],
          ),
        ),
        if (isCopyable)
          IconButton(
            icon: Icon(CupertinoIcons.doc_on_doc_fill, color: theme.primaryColor, size: 18),
            onPressed: () => _copyToClipboard(value),
          ),
      ],
    );
  }
}

class BarrierDismissibleDialog extends StatelessWidget {
  final Widget child;
  const BarrierDismissibleDialog({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: child,
    );
  }
}
