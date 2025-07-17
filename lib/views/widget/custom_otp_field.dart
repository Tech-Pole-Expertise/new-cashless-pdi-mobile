import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';
import 'package:pv_deme/api/controllers/api_controller.dart';
import 'package:pv_deme/constant/app_color.dart';

class CustomOtpField extends StatefulWidget {
  final int numberOfFields;
  final String text;
  final int? otpTime;
  final String? retraitId;
  final String operationType;
  final void Function(String)? onCodeChanged;
  final void Function(String)? onSubmit;

  const CustomOtpField({
    super.key,
    required this.numberOfFields,
    required this.text,
    this.otpTime,
    this.retraitId,
    required this.operationType,
    this.onCodeChanged,
    this.onSubmit,
  });

  @override
  State<CustomOtpField> createState() => CustomOtpFieldState();
}

class CustomOtpFieldState extends State<CustomOtpField> {
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;
  late int remainingSeconds;
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.otpTime ?? 60;

    controllers = List.generate(
      widget.numberOfFields,
      (_) => TextEditingController(),
    );
    focusNodes = List.generate(widget.numberOfFields, (_) => FocusNode());

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
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void onInputChanged(int index, String value) {
    if (value.length == 1 && index < widget.numberOfFields - 1) {
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    }

    final otpCode = controllers.map((c) => c.text).join();
    widget.onCodeChanged?.call(otpCode);

    if (otpCode.length == widget.numberOfFields) {
      widget.onSubmit?.call(otpCode);
    }
  }

  void clearFields() {
    for (final controller in controllers) {
      controller.clear();
    }
    FocusScope.of(context).requestFocus(focusNodes[0]);
  }

  void onResendPressed() async {
    if (widget.operationType.toString() == 'withdraw') {
      Logger().d('Je suis appélé pour refresh otp');
      final otp = await ApiController().refreshWithdrawOtp({
        "retrait_id": widget.retraitId,
      });
      setState(() {
        remainingSeconds = otp.otpDuration;
      });
      startCountdown();
      clearFields();
    } else if (widget.operationType.toString() == 'change') {
      Logger().d('Je suis appélé pour refresh otp pour changer mot de passe');
      final otp = await ApiController().refreshWithdrawOtp({
        "retrait_id": widget.retraitId,
      });
      setState(() {
        remainingSeconds = otp.otpDuration;
      });
      startCountdown();
      clearFields();
    } else {
      Logger().d('Je suis appélé pour refresh otp pour modifier mot de passe');
      final otp = await ApiController().refreshWithdrawOtp({
        "retrait_id": widget.retraitId.toString(),
      });
      setState(() {
        remainingSeconds = otp.otpDuration;
      });
      startCountdown();
      clearFields();
    }
    // on réinitialise aussi le champ
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.numberOfFields, (index) {
            return Container(
              width: 40,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child: KeyboardListener(
                focusNode: FocusNode(), // 👈 focus temporaire et anonyme
                onKeyEvent: (KeyEvent event) {
                  if (event is KeyDownEvent &&
                      event.logicalKey == LogicalKeyboardKey.backspace &&
                      controllers[index].text.isEmpty &&
                      index > 0) {
                    FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                    controllers[index - 1].clear();
                  }
                },

                child: TextFormField(
                  controller: controllers[index],
                  focusNode: focusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLength: 1,
                  decoration: InputDecoration(
                    counterText: '',
                    contentPadding: const EdgeInsets.all(12),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) => onInputChanged(index, value),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 32),

        remainingSeconds > 0
            ? Text(
              'OTP expire dans $remainingSeconds secondes',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            )
            : (widget.operationType == 'reset' ||
                widget.operationType == 'change')
            ? Text(
              'Votre OTP est expiré.\nPour plus de sécurité, reprenez toute l\'opération.',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            )
            : Obx(
              () => InkWell(
                onTap: onResendPressed,
                child: Text(
                  ApiController().isLoading.value
                      ? 'Renvoyer en cours....'
                      : 'Renvoyer un nouveau OTP',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),

        const SizedBox(height: 12),
      ],
    );
  }
}
