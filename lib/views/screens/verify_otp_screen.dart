import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 👈
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pv_deme/api/controllers/api_controller.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/routes/app_routes.dart';
import 'package:pv_deme/views/widget/custom_app_bar.dart';
import 'package:pv_deme/views/widget/custom_otp_field.dart';
import 'package:pv_deme/views/widget/elevated_button.dart';

class VerifyOtpScreen extends StatelessWidget {
  VerifyOtpScreen({super.key});

  final GlobalKey<CustomOtpFieldState> otpFieldKey =
      GlobalKey<CustomOtpFieldState>();

  final RxBool isCompleted = false.obs;

  @override
  Widget build(BuildContext context) {
    // Initialise ScreenUtil ici pour prendre la taille écran actuelle
    ScreenUtil.init(
      context,
      designSize: const Size(360, 690),
      minTextAdapt: true,
    );

    final ApiController apiController = Get.find<ApiController>();
    String? otp;
    final args = Get.arguments;
    final otpTime = args['time'];
    final retraitId = args['retraitId'] as String;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.h), // adapte la hauteur
        child: CustomAppBar(
          title: 'Vérification OTP',
          onBack: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
          ), // padding responsive horizontal
          child: Column(
            children: [
              SizedBox(height: 24.h), // hauteur responsive
              CustomOtpField(
                operationType: 'withdraw',
                retraitId: retraitId,
                key: otpFieldKey,
                text: 'Veuillez entrer le code OTP envoyé au client :',
                otpTime: otpTime,
                numberOfFields: 6,
                onCodeChanged: (code) {
                  isCompleted.value =
                      code.length == 6; // ✅ Active dès 6 chiffres
                  otp = code;
                },
                onSubmit: (code) {
                  otp = code;
                  isCompleted.value = code.length == 6;
                },
              ),
              SizedBox(height: 24.h), // marge responsive
              Obx(
                () =>
                    isCompleted.value
                        ? CustomElevatedButton(
                          isLoading: apiController.isLoading.value,
                          label: 'Valider',
                          labelColor: Colors.yellow,
                          onPressed: () async {
                            Logger().d(
                              'Je suis appelé aussi : ${{"retrait_id": retraitId, "otp": otp}}',
                            );

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
                        )
                        : SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
