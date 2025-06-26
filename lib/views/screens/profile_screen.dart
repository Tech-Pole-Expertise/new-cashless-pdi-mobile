import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdi_deme/api/Service/merchant_data_store_controller.dart';
import 'package:pdi_deme/constant/app_color.dart';
import 'package:pdi_deme/routes/app_routes.dart';
import 'package:pdi_deme/views/widget/custom_bottom_sheet.dart';
import 'package:pdi_deme/views/widget/custom_dialog.dart';
import 'package:pdi_deme/views/widget/custom_otp_field.dart';
import 'package:pdi_deme/views/widget/custom_text_field.dart';
import 'package:pdi_deme/views/widget/elevated_button.dart';
import 'package:pdi_deme/views/widget/elevated_button_with_icons.dart';
import 'package:pdi_deme/views/widget/list_tile.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final TextEditingController currentPassword = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final merchantController = Get.find<MerchantController>();
    final merchant = merchantController.merchant.value;
    if (merchant == null) {
      return const Scaffold(
        body: Center(child: Text('Aucune donnée utilisateur trouvée')),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ✅ Entête fixe
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(color: AppColors.primaryLight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Mon Profil',
                      style: TextStyle(
                        fontSize: 24,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  merchant.photoUrl != null
                                      ? NetworkImage(
                                        merchant.photoUrl.toString(),
                                      )
                                      : AssetImage(
                                        'assets/img/defaut_profil.jpeg',
                                      ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${merchant.firstName} ${merchant.lastName}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                merchant.username,
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.edit, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ✅ Partie scrollable
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'GESTION  DE COMPTE',
                        style: TextStyle(
                          fontSize: 20,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    CustomLisTile(
                      title: 'Modifier le mot de passe',
                      subtitle: 'Cliquez ici pour changer votre mot de passe',
                      leadingIcon: Icon(Icons.security),
                      onTap: () {
                        CustomBottomSheet.show(
                          context: context,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 24,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Icon(
                                    Icons.lock_outline,
                                    size: 40,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Center(
                                  child: Text(
                                    "Vérification du mot de passe",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Center(
                                  child: Text(
                                    "Veuillez entrer votre mot de passe actuel pour continuer.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                CustomTextField(
                                  label: 'Mot de passe actuel',
                                  controller: currentPassword,
                                  isPassword: true,
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  child: CustomElevatedButton(
                                    label: 'Vérifier',
                                    onPressed: () {
                                      Get.toNamed(
                                        AppRoutes.changePassword,
                                        arguments: 'change',
                                      );
                                    },
                                    backgroundColor: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    CustomLisTile(
                      title: 'Modifier le numéro de téléphone',
                      subtitle:
                          'Cliquez ici pour modifier votre numéro de téléphone',
                      leadingIcon: Icon(Icons.phone_android),
                      onTap: () {
                        CustomBottomSheet.show(
                          context: context,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 24,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Icon(
                                    Icons.phone_android,
                                    size: 40,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Center(
                                  child: Text(
                                    "Vérification du numéro",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Center(
                                  child: Text(
                                    "Veuillez entrer votre numéro actuel pour continuer.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                CustomTextField(
                                  controller: phoneController,
                                  label: 'Numéro de téléphone',
                                  maxLength: 8,
                                  regexPattern: r'^\d{8}$',
                                  validationMessage:
                                      'Veuillez entrer un numéro de téléphone valide.',
                                  hint: '56 78 90 12',
                                  keyboardType: TextInputType.phone,

                                  prefixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(width: 8),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          'assets/img/drapeau.png',
                                          height: 20,
                                          width: 20,
                                        ),
                                      ),
                                      const Text(
                                        '+226',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  child: CustomElevatedButton(
                                    label: 'Vérifier',
                                    onPressed: () {
                                      CustomBottomSheet.show(
                                        context: context,
                                        child: Container(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CustomOtpField(
                                                text:
                                                    'Veuillez entrer le code OTP réçu sur le  +22${phoneController.text}',
                                                numberOfFields: 6,
                                                onCodeChanged: (String code) {
                                                  // Logique de validation du code ici
                                                },
                                                onSubmit: (code) {
                                                  Get.back();
                                                  Get.toNamed(
                                                    AppRoutes.changePhone,
                                                    arguments: 'change',
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    backgroundColor: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    CustomLisTile(
                      title: 'FAQ',
                      subtitle: 'Toutes vos questions répondues',
                      leadingIcon: Icon(Icons.question_answer),
                    ),
                    CustomLisTile(
                      title: 'Confidentialité et sécurité',
                      subtitle: 'Nos engagements pour votre sécurité',
                      leadingIcon: Icon(Icons.support_agent),
                    ),
                    const SizedBox(
                      height: 80,
                    ), // Pour laisser de l'espace au-dessus du bouton
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ✅ Bouton bas fixe
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: CustomElevatedButonWithIcons(
            onPressed: () {
              // Déconnexion
              CustomDialog.showCustomDialog(
                context,
                title: 'Confirmation',
                content: 'Etes vous sûr de vouloir vous déconnectez?',
                onCancel: () => Get.back(),
                onConfirm: () {
                  merchantController.logout();
                },
              );
            },
            backgroundColor: AppColors.error,
            label: 'Deconnexion',
            icon: Icons.logout,
          ),
        ),
      ),
    );
  }
}
