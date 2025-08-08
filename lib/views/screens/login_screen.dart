import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // ⬅️ important
import 'package:pv_deme/api/controllers/api_controller.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/routes/app_routes.dart';
import 'package:pv_deme/views/widget/custom_text_field.dart';
import 'package:pv_deme/views/widget/elevated_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final ApiController apiController = Get.put(ApiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 250.h,
                width: double.infinity,
                child: Image.asset(
                  'assets/img/users.png',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(18.w),
                child: Form(
                  key: formkey,
                  autovalidateMode: AutovalidateMode.onUnfocus,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Se connecter',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 22.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Entrez vos identifiants pour vous connecter.',
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
                        prefixIcon: Icon(Icons.phone, size: 20.sp),
                        suffixIcon: null,
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
                      SizedBox(height: 20.h),
                      CustomTextField(
                        controller: passwordController,
                        label: 'Mot de passe',
                        prefixIcon: Icon(Icons.lock, size: 20.sp),
                        regexPattern: r'^.{8,}$',
                        validationMessage:
                            'Le mot de passe doit contenir au moins 8 caractères.',
                        isPassword: true,
                        hint: '********',
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 10.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.forgotPassword);
                          },
                          child: Text(
                            'Mot de passe oublié ?',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14.sp,
                              decorationColor: AppColors.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Obx(
                        () => CustomElevatedButton(
                          label: 'Se connecter',
                          labelColor: Colors.yellow,
                          isLoading: apiController.isLoading.value,
                          onPressed: () {
                            if (formkey.currentState!.validate()) {
                              Logger().d(
                                'phone:' '+226${phoneController.text}',
                              );
                              apiController.login({
                                'username': '+226${phoneController.text.replaceAll(' ', '').trim()}',
                                'password': passwordController.text,
                              });
                            }
                          },
                          backgroundColor: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
