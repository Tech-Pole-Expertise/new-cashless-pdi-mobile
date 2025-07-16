import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pdi_deme/api/controllers/api_controller.dart';
import 'package:pdi_deme/constant/app_color.dart';
import 'package:pdi_deme/routes/app_routes.dart';
import 'package:pdi_deme/views/widget/custom_app_bar.dart';
import 'package:pdi_deme/views/widget/custom_otp_field.dart';
import 'package:pdi_deme/views/widget/elevated_button.dart';

class VerifyOtpScreen extends StatelessWidget {
  VerifyOtpScreen({super.key});

  final GlobalKey<CustomOtpFieldState> otpFieldKey =
      GlobalKey<CustomOtpFieldState>();

  final RxBool isCompleted = false.obs;

  @override
  Widget build(BuildContext context) {
    final ApiController apiController = Get.find<ApiController>();
    String? otp;
    final args = Get.arguments;
    final otpTime = args['time'];
    final retraitId = args['retraitId'] as String;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: CustomAppBar(
          title: 'Vérification OTP',
          onBack: () {
            Get.offAllNamed(AppRoutes.bottom);
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          CustomOtpField(
            operationType: 'withdraw',
            retraitId: retraitId,
            key: otpFieldKey,
            text: 'Veuillez entrer le code OTP envoyé au client :',
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
                            Logger().d('Jes suis appélé aussi');
                            final success = await apiController
                                .withdrawValidation({
                                  "retrait_id": retraitId,
                                  "otp": otp,
                                });

                            if (!success) {
                              otpFieldKey.currentState?.clearFields();
                              isCompleted.value = false;
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
