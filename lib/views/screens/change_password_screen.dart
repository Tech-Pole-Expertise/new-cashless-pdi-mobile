import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pv_deme/api/controllers/api_controller.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/views/widget/custom_app_bar.dart';
import 'package:pv_deme/views/widget/custom_text_field.dart';
import 'package:pv_deme/views/widget/elevated_button.dart';
// à adapter

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final ApiController apiController = Get.find<ApiController>();

  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final String action = args['operationType'] as String;

    void submit() async {
      if (_formKey.currentState!.validate()) {
        action.toString() == 'reset'
            ? await apiController.confirmPasswordReset({
              "new_password": newPasswordController.text,
            })
            : await apiController.confirmPasswordChange({
              "new_password": newPasswordController.text,
            });
      }
    }

    return Scaffold(
      appBar: CustomAppBar(
        title:
            action.toString() != 'reset'
                ? "Changer le mot de passe"
                : "Rénitialiser le mot de passe",
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.sp),
        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.h),
              Center(
                child: Icon(
                  action.toString() != 'reset'
                      ? Icons.lock_outline
                      : Icons.restore,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 16.h),
              const Center(
                child: Text(
                  "Définir un nouveau mot de passe",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 24.h),
              CustomTextField(
                label: "Nouveau mot de passe",
                controller: newPasswordController,

                isPassword: _obscureNew,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNew ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureNew = !_obscureNew;
                    });
                  },
                ),
                regexPattern: r'^.{6,}$',
                validationMessage: "Minimum 6 caractères",
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                label: "Confirmer le mot de passe",
                controller: confirmPasswordController,
                isPassword: _obscureConfirm,
                validator: (p0) {
                  final newPass = newPasswordController.text.trim();
                  final confirmPass = confirmPasswordController.text.trim();

                  if (newPass != confirmPass) {
                    return "Les mots de passe ne correspondent pas.";
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirm = !_obscureConfirm;
                    });
                  },
                ),
                regexPattern: r'^.{6,}$',
                validationMessage: "Veuillez confirmer le mot de passe",
              ),
              SizedBox(height: 32.h),
              Obx(
                () => CustomElevatedButton(
                  label:
                      action.toString() != 'reset' ? 'Changer' : 'Rénitialiser',
                  labelColor: Colors.yellow,
                  isLoading: apiController.isLoading.value,
                  onPressed: submit,
                  backgroundColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
