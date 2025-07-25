import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pv_deme/api/Service/merchant_stat_controller.dart';
import 'package:pv_deme/api/controllers/api_controller.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/routes/app_routes.dart';
import 'package:pv_deme/views/widget/custom_outline_button.dart';
import 'package:pv_deme/views/widget/custom_text_field.dart';
import 'package:pv_deme/views/widget/elevated_button.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TextEditingController pdiPhoneController = TextEditingController();
  final ApiController apiController = Get.find<ApiController>();
  final GlobalKey<FormState> _key = GlobalKey();
  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final merchantStat = apiController.merchantStat.value;

      if (apiController.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildUserHeader(merchantStat),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.all(  12.0),
                  child: _buildStatsCards(merchantStat),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: _buildRetraitSection(context),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildUserHeader(merchantStat) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('assets/img/pro.png'),
        ),
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 14),
            children: [
              TextSpan(
                text:
                    merchantStat != null
                        ? '${merchantStat.lastname.toUpperCase()} ${merchantStat.firstname}\n'
                        : 'Utilisateur inconnu\n',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: merchantStat?.phone ?? 'Téléphone indisponible',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards(merchantStat) {
    return Column(
      children: [
        _buildStatCard(
          icon: Icons.local_shipping,
          title: "Approvisionnement reçu",
          count: merchantStat?.supplyCount ?? 0,
          subtitle: "Statistiques générales",
          color: AppColors.primary,
        ),
        _buildStatCard(
          icon: Icons.import_export,
          title: "Retraits effectués",
          count: merchantStat?.withdrawalCount ?? 0,
          subtitle: "Ce mois",
          color: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required int count,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(icon, color: AppColors.primaryLight, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                const SizedBox(height: 4),
                Text(
                  "Total : $count",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(subtitle, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Image.asset('assets/img/group.png', height: 40),
        ],
      ),
    );
  }

  Widget _buildRetraitSection(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Veuillez sélectionner\nune méthode de retrait',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          CustomElevatedButton(
            label: "Scanner le QR code",
            onPressed: () => Get.toNamed(AppRoutes.scan),
            backgroundColor: Colors.green[900]!,
            labelColor: Colors.yellow,
          ),
          const SizedBox(height: 12),
          CustomOutlinedButton(
            label: "Entrer le numéro de la personne",
            onPressed: () => _showPhoneEntryBottomSheet(context),
            borderColor: AppColors.primary,
            labelColor: Colors.green[900],
          ),
        ],
      ),
    );
  }

  void _showPhoneEntryBottomSheet(BuildContext context) {
    pdiPhoneController.clear();
    _key.currentState?.reset();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Form(
              key: _key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Veuillez saisir le numéro de téléphone de la personne",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: pdiPhoneController,
                    label: 'Numéro de téléphone',
                    isPassword: false,
                    hint: '74 47 56 74',
                    keyboardType: TextInputType.number,
                    formatAsPhoneNumber: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez saisir un numéro de téléphone valide';
                      }
                      if (value.replaceAll(' ', '').length != 8) {
                        return 'Le numéro doit contenir 8 chiffres';
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      onPressed: () => Get.toNamed(AppRoutes.scan),
                      icon: const Icon(Icons.phone_android),
                    ),
                    prefix: const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Text(
                        '+226',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => CustomElevatedButton(
                      label: 'Rechercher',
                      labelColor: Colors.yellow,
                      isLoading: apiController.isLoading.value,
                      onPressed: () async {
                        if (!_key.currentState!.validate()) return;

                        final success = await apiController.getPdiProfile(
                          '+226${pdiPhoneController.text.replaceAll(' ', '').trim()}',
                        );
                        if (success) {
                          Get.back();
                          Get.toNamed(
                            AppRoutes.panier,
                            arguments: {'pdi': apiController.pdiProfile.value},
                          );
                        }
                      },
                      backgroundColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
