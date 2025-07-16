import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pdi_deme/api/controllers/api_controller.dart';
import 'package:pdi_deme/constant/app_color.dart';
import 'package:pdi_deme/routes/app_routes.dart';
import 'package:pdi_deme/views/widget/custom_app_bar.dart';
import 'package:pdi_deme/views/widget/custom_otp_field.dart';
import 'package:pdi_deme/views/widget/elevated_button.dart';

class VerifyOtpForPasswordScreen extends StatelessWidget {
  VerifyOtpForPasswordScreen({super.key});

  final GlobalKey<CustomOtpFieldState> otpFieldKey =
      GlobalKey<CustomOtpFieldState>();

  final RxBool isCompleted = false.obs;

  @override
  Widget build(BuildContext context) {
    final ApiController apiController = Get.find<ApiController>();
    String? otp;
    String? phone;
    final args = Get.arguments;
    final String operationType = args['operationType'];
    final otpTime = args['time'];
    operationType.toString() == 'reset' ? phone = args['phone'] : phone = '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: CustomAppBar(
          title: 'Vérification OTP',
          onBack: () {
            operationType.toString() == 'reset'
                ? Get.offAllNamed(AppRoutes.login)
                : Get.offAllNamed(AppRoutes.bottom);
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          CustomOtpField(
            operationType: operationType,
            key: otpFieldKey,
            text:
                operationType.toString() == 'reset'
                    ? 'Un OTP est envoyé pour rénitialiser votre mot de passe :'
                    : 'Un OTP est envoyé pour modifier votre mot de passe',
            otpTime: otpTime,
            numberOfFields: 6,
            onCodeChanged: (code) {
              isCompleted.value = code.length == 6; // ✅ Active dès 6 chiffres
              otp = code;
            },
            onSubmit: (code) {
              otp = code;
              isCompleted.value = code.length == 6;
            },
          ),
          const SizedBox(height: 24),
          Obx(
            () =>
                isCompleted.value
                    ? Padding(
                      padding: const EdgeInsets.all(14),
                      child: SizedBox(
                        width: Get.width,
                        child: CustomElevatedButton(
                          isLoading: apiController.isLoading.value,
                          label: 'Valider',
                          labelColor: Colors.yellow,
                          onPressed: () async {
                            if (operationType.toString() == 'change') {
                              Logger().d('Jes suis appélé et otp est $otp');
                              final success = await apiController
                                  .confirmPasswordChange({"otp": otp});

                              if (!success) {
                                otpFieldKey.currentState?.clearFields();
                                isCompleted.value = false;
                              }
                            } else {
                              Logger().d('Jes suis appélé aussi');
                              final success = await apiController
                                  .resumePasswordReset({
                                    "phone": phone,
                                    "otp": otp,
                                  });

                              if (!success) {
                                otpFieldKey.currentState?.clearFields();
                                isCompleted.value = false;
                              }
                            }
                          },
                          backgroundColor: AppColors.primary,
                        ),
                      ),
                    )
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
