import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pv_deme/api/controllers/api_controller.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/routes/app_routes.dart';
import 'package:pv_deme/views/widget/custom_text_field.dart';
import 'package:pv_deme/views/widget/elevated_button.dart';

class PhoneEntryBottomSheet extends StatefulWidget {
  final bool showLoadingIndicator;
  const PhoneEntryBottomSheet({super.key, required this.showLoadingIndicator});

  @override
  State<PhoneEntryBottomSheet> createState() => _PhoneEntryBottomSheetState();
}

class _PhoneEntryBottomSheetState extends State<PhoneEntryBottomSheet> {
  final TextEditingController pdiPhoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ApiController apiController = Get.find<ApiController>();

  @override
  void dispose() {
    pdiPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),

      child: Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
          top: 24.h,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "Veuillez saisir le numéro de téléphone",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  controller: pdiPhoneController,
                  label: 'Numéro de téléphone',
                  isPassword: false,
                  hint: '74 47 56 74',
                  keyboardType: TextInputType.number,
                  formatAsPhoneNumber: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir un numéro de téléphone valide';
                    }
                    if (value.replaceAll(' ', '').length != 8) {
                      return 'Le numéro doit contenir 8 chiffres';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    onPressed: () => Get.toNamed(AppRoutes.scan),
                    icon: Icon(Icons.phone_android, size: 24.sp),
                  ),
                  prefix: Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: Text(
                      '+226',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Obx(
                  () => CustomElevatedButton(
                    label: 'Rechercher',
                    labelColor: Colors.yellow,
                    isLoading: apiController.isLoading.value,
                    showLoadingIndicator: widget.showLoadingIndicator,
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;

                      final success = await apiController.getPdiProfile(
                        '+226${pdiPhoneController.text.replaceAll(' ', '').trim()}',
                      );
                      if (success) {
                        // Get.back();

                        Get.toNamed(
                          AppRoutes.panier,
                          arguments: {'pdi': apiController.pdiProfile.value},
                        );
                      }
                    },
                    backgroundColor: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
