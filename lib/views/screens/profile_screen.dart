import 'package:flutter/material.dart';
import 'package:pdi_deme/constant/app_color.dart';
import 'package:pdi_deme/views/widget/elevated_button_with_icons.dart';
import 'package:pdi_deme/views/widget/list_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(
                                'assets/img/profile.png',
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Stephane Deme',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '+226 70 00 00 00',
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
                    ),
                    CustomLisTile(
                      title: 'Modifier le numéro de téléphone',
                      subtitle:
                          'Cliquez ici pour modifier votre numéro de téléphone',
                      leadingIcon: Icon(Icons.phone_android),
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
