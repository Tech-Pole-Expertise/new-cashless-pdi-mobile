import 'package:flutter/widgets.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:pdi_deme/constant/app_color.dart';

class CustomOtpField extends StatelessWidget {
  final int numberOfFields;
  final void Function(String)? onCodeChanged;
  final void Function(String)? onSubmit;
  const CustomOtpField({
    super.key,
    required this.numberOfFields,
    this.onCodeChanged,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Veuillez entrer le code à 6 chiffres reçu sur +226 07297755',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),
          OtpTextField(
            numberOfFields: numberOfFields,
            borderColor: AppColors.primary,
            showFieldAsBox: true,
            onCodeChanged: (String code) {
              onCodeChanged?.call(code);
            },
            onSubmit: (String verificationCode) {
              onSubmit?.call(verificationCode);
            },
          ),
        ],
      ),
    );
  }
}
