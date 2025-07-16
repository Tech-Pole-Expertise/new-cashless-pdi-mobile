import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdi_deme/api/Service/merchant_data_store_controller.dart';
import 'package:pdi_deme/api/Service/merchant_stat_controller.dart';
import 'package:pdi_deme/api/controllers/api_controller.dart';
import 'package:pdi_deme/api/models/contact_info_model.dart';
import 'package:pdi_deme/constant/app_color.dart';
import 'package:pdi_deme/routes/app_routes.dart';
import 'package:pdi_deme/views/widget/custom_circle_progress_bar.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final TextEditingController currentPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController newPasswordConfirm = TextEditingController();
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final merchantController = Get.find<MerchantController>();
    final apiController = Get.find<ApiController>();
    final merchant = apiController.merchantStat.value;

    if (merchant == null) {
      return const Scaffold(
        body: Center(child: Text('Aucune donnée utilisateur trouvée')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          /// 🔷 Section du haut avec fond vert clair
          Container(
            width: double.infinity,
            height: 200,
            color: AppColors.primaryLight,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Mon profil',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            const AssetImage('assets/img/pro.png')
                                as ImageProvider,
                        // merchant.photoUrl != null
                        //     ? NetworkImage(merchant.photoUrl!)
                        //     : const AssetImage('assets/img/pro.png')
                        //         as ImageProvider,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              '${merchant.lastname.toUpperCase()} ${merchant.firstname}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 4),

                            /// ✅ Numéro dynamique
                            Text(
                              merchant.phone,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),

                      /// ✅ Texte dynamique "Hello"
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// 🔷 Corps principal scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Gestion du compte', Icons.settings),
                  _simpleCard(
                    icon: Icons.lock_outline,
                    text: 'Modifier le mot de passe',
                    onTap: () {
                      Get.toNamed(AppRoutes.updatePassword);
                    },
                  ),

                  const SizedBox(height: 20),
                  _sectionTitle('Contacts et infos utiles', Icons.contact_page),
                  Obx(() {
                    final contact = apiController.contactInfoModel.value;
                    if (apiController.isLoading.value) {
                      return const Center(
                        child: CustomCircleProgressBar(
                          color: Colors.white,
                          backgroundColor: AppColors.primary,
                          strokeWidth: 5,
                        ),
                      );
                    }
                    if (contact == null) {
                      return const Center(
                        child: Text("Nous n'avons pas pu charger les infos"),
                      );
                    } else {
                     return  _contactCard(contact);
                    }}
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      /// 🔷 Bouton Déconnexion
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: OutlinedButton.icon(
          onPressed: () {
            merchantController.logout();
          },
          icon: const Icon(Icons.logout, color: AppColors.primary),
          label: const Text(
            'Déconnexion',
            style: TextStyle(color: AppColors.primary),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _simpleCard({
    required IconData icon,
    required String text,
    VoidCallback? onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: AppColors.textPrimary),
        title: Text(text, style: const TextStyle(fontSize: 14)),
        onTap: onTap,
      ),
    );
  }

  Widget _contactCard(ContactInfoModel contact) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(contact.callCenterPhoneNumber),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text(contact.callCenterEmail),
            ),
            const ListTile(
              leading: Icon(Icons.language),
              title: Text('www.website.com'),
            ),
            const ListTile(
              leading: Icon(Icons.map),
              title: Text('Ouagadougou'),
            ),
          ],
        ),
      ),
    );
  }
}
