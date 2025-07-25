import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pv_deme/api/Service/merchant_data_store_controller.dart';
import 'package:pv_deme/api/Service/merchant_stat_controller.dart';
import 'package:pv_deme/api/controllers/api_controller.dart';
import 'package:pv_deme/api/models/contact_info_model.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/routes/app_routes.dart';
import 'package:pv_deme/views/widget/custom_circle_progress_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final apiController = Get.find<ApiController>();
  final merchantController = Get.find<MerchantController>();
  final homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    if (apiController.contactInfoModel.value == null) {
      apiController.getContatInfos();
    }
  }

  @override
  Widget build(BuildContext context) {
    final merchant = apiController.merchantStat.value;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 🔷 HEADER
          Container(
            width: double.infinity,
            height: 200,
            color: AppColors.primaryLight,
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Mon profil',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage('assets/img/pro.png'),
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text:
                                merchant != null
                                    ? '${merchant.lastname.toUpperCase()} ${merchant.firstname}\n'
                                    : 'Utilisateur inconnu\n',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text: merchant?.phone ?? 'Téléphone non disponible',
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 🔷 CONTENU PRINCIPAL
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
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
                    _sectionTitle(
                      'Contacts et infos utiles',
                      Icons.contact_page,
                    ),

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
                        return Column(
                          children: [
                            SizedBox(height: 20),
                            Icon(
                              Icons.error,
                              color: AppColors.primary,
                              size: 80,
                            ),
                            SizedBox(height: 8),
                            Text("Impossible de charger les infos de contact"),
                          ],
                        );
                      } else {
                        return _contactCard(contact);
                      }
                    }),
                  ],
                ),
              ),
            ),
          ),

          // 🔷 BOUTON DÉCONNEXION
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: Get.width,
              child: OutlinedButton.icon(
                onPressed: () => merchantController.logout(),
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
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
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
        title: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            decoration: TextDecoration.underline,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _contactCard(ContactInfoModel contact) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.phone),
          title: Text(contact.callCenterPhoneNumber),
        ),
        ListTile(
          leading: const Icon(Icons.email),
          title: Text(contact.callCenterEmail),
        ),
        const ListTile(
          leading: Icon(Icons.language),
          title: Text('www.website.com'),
        ),
        const ListTile(leading: Icon(Icons.map), title: Text('Ouagadougou')),
      ],
    );
  }
}
