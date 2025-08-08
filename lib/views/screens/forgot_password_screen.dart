import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 👈 Ajouté
import 'package:get/get.dart';
import 'package:pv_deme/api/controllers/api_controller.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/views/widget/custom_text_field.dart';
import 'package:pv_deme/views/widget/elevated_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final TextEditingController phoneController = TextEditingController();
  final ApiController apiController = Get.find<ApiController>();
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Future<void> onSubmit() async {
      await apiController.initPasswordReset({
        "phone": "+226${phoneController.text.replaceAll(' ', '')}",
      });
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 40.w,
            height: 40.h,
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              border: Border.all(color: AppColors.primaryLight),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.primary,
                size: 16.sp,
              ),
              onPressed: () => Get.back(),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image pleine largeur et hauteur partielle
            SizedBox(
              height: 250.h,
              width: double.infinity,
              child: Image.asset('assets/img/users.png', fit: BoxFit.cover),
            ),
            Padding(
              padding: EdgeInsets.all(18.w),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mot de passe oublié',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 22.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Entrez votre numéro pour continuer.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    CustomTextField(
                      controller: phoneController,
                      label: 'Numéro de téléphone',
                      regexPattern: r'^\d{8}$',
                      validationMessage:
                          'Veuillez entrer un numéro de téléphone valide.',
                      hint: '7X XX XX XX',
                      keyboardType: TextInputType.phone,
                      prefixIcon: Icon(
                        Icons.phone,
                        color: AppColors.textPrimary,
                        size: 20.sp,
                      ),
                      suffixIcon: null,
                      formatAsPhoneNumber: true,
                      prefix: Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: Text(
                          '+226',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Obx(
                      () => CustomElevatedButton(
                        isLoading: apiController.isLoading.value,
                        label: 'Vérifier le numéro',
                        labelColor: Colors.yellow,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            onSubmit();
                          }
                        },
                        backgroundColor: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          'Retourner sur la page de connexion',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
