import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:pdi_deme/constant/app_color.dart';

class CustomOtpField extends StatefulWidget {
  final int numberOfFields;
  final String text;
  final int? otpTime;
  final void Function(String)? onCodeChanged;
  final void Function(String)? onSubmit;

  const CustomOtpField({
    super.key,
    required this.numberOfFields,
    required this.text,
    this.otpTime,
    this.onCodeChanged,
    this.onSubmit,
  });

  @override
  State<CustomOtpField> createState() => _CustomOtpFieldState();
}

class _CustomOtpFieldState extends State<CustomOtpField> {
  late int remainingSeconds;
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.otpTime ?? 60;
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
    // 👉 Ajouter ici un appel API ou logique métier pour renvoyer l’OTP
    setState(() {
      remainingSeconds = widget.otpTime ?? 60;
    });
    startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Icon(Icons.lock_open_rounded, size: 48, color: AppColors.primary),
        const SizedBox(height: 16),
        Text(
          widget.text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: OtpTextField(
            numberOfFields: widget.numberOfFields,
            borderColor: AppColors.primary,
            focusedBorderColor: AppColors.primary,
            cursorColor: AppColors.primary,
            showFieldAsBox: true,
            borderRadius: BorderRadius.circular(8),
            fieldWidth: 35,
            onCodeChanged: widget.onCodeChanged,
            onSubmit: widget.onSubmit,
          ),
        ),
        const SizedBox(height: 32),
        remainingSeconds > 0
            ? Text(
              'OTP expire dans $remainingSeconds secondes',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            )
            : InkWell(
              onTap: onResendPressed,
              child: Text(
                'Renvoyer maintenant',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
        const SizedBox(height: 12),
      ],
    );
  }
}
