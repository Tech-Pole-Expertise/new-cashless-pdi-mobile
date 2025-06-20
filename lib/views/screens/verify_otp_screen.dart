import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdi_deme/constant/app_color.dart';
import 'package:pdi_deme/routes/app_routes.dart';
import 'package:pdi_deme/views/widget/custom_otp_field.dart';
import 'package:pdi_deme/views/widget/elevated_button.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  late int remainingSeconds;
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    remainingSeconds = args['time'] ?? 60;
    startCountdown();
  }

  void startCountdown() {
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  void onResendPressed() {
    // 👉 logiquement ici tu dois relancer une requête de renvoi OTP
    setState(() {
      remainingSeconds = 60; // ou args['time']
    });
    startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vérification OTP'), centerTitle: true),
      body: Column(
        children: [
          const SizedBox(height: 24),

          CustomOtpField(
            numberOfFields: 6,
            onCodeChanged: (String code) {},
            onSubmit:
                (code) => Get.toNamed(
                  AppRoutes.pin,
                  arguments: {'code': code, 'phone': '+226 07297755'},
                ),
          ),

          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(14),
            child: SizedBox(
              width: Get.width,
              child: CustomElevatedButton(
                label: 'Valider',
                onPressed: () {},
                backgroundColor: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                remainingSeconds > 0
                    ? Text(
                      'OTP expire dans $remainingSeconds secondes',
                      style: TextStyle(color: AppColors.textSecondary),
                    )
                    : InkWell(
                      onTap: onResendPressed,
                      child: Text(
                        'Renvoyer maintenant',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
