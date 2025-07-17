import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pv_deme/api/Service/merchant_stat_controller.dart';
import 'package:pv_deme/api/controllers/api_controller.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/routes/app_routes.dart';
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
    // final merchantController = Get.find<MerchantController>();
    // final merchant = merchantController.merchant.value;
    // final merchantStat = apiController.merchantStat.value;
    return Obx(() {
      final merchantStat = apiController.merchantStat.value;
      //  final merchant = merchantController.merchant.value;

      // Si le chargement est encore en cours
      if (apiController.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      // Si le chargement est terminé mais que les données sont nulles
      if (merchantStat == null) {
        return const Scaffold(
          body: Center(
            child: Text(
              'Nous avons rencontré un problème lors du chargement des informations.',
            ),
          ),
        );
      }

      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Haut : profil utilisateur
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          const AssetImage('assets/img/pro.png')
                              as ImageProvider,
                      // (merchant.photoUrl != null &&
                      //         merchant.photoUrl!.isNotEmpty)
                      //     ? NetworkImage(merchant.photoUrl!)
                      //     : const AssetImage('assets/img/pro.png')
                      //         as ImageProvider,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${merchantStat.lastname.toUpperCase()} ${merchantStat.firstname}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          merchantStat.phone,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Statistiques customisées comme dans l'image
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade700),
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
                            child: const Icon(
                              Icons.local_shipping,
                              color: AppColors.primaryLight,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Approvionnement reçu"),
                                SizedBox(height: 4),
                                Text(
                                  "Total: ${merchantStat.supplyCount.toString()}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Statistiques générales",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Image.asset('assets/img/group.png', height: 40),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.primary),
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
                            child: const Icon(
                              Icons.import_export,
                              color: AppColors.primaryLight,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Retrait effectués"),
                                SizedBox(height: 4),
                                Text(
                                  "Ce mois: ${merchantStat.withdrawalCount.toString()}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Statistiques du mois en cours",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Image.asset('assets/img/group.png', height: 40),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                // Bloc retrait
                Container(
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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // déclenche le formulaire manuel
                            pdiPhoneController.clear();
                            _key.currentState?.reset();
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.of(
                                          context,
                                        ).viewInsets.bottom,
                                  ),
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 24,
                                    ),
                                    child: Form(
                                      key: _key,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            "Veuillez saisir le numéro de teléphone de la personne",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          CustomTextField(
                                            controller: pdiPhoneController,
                                            label: 'Numéro de teléphone',
                                            maxLength: 8,
                                            isPassword: false,
                                            hint: '74 47 56 74',
                                            keyboardType: TextInputType.number,
                                            formatAsPhoneNumber: true,

                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                Get.toNamed(AppRoutes.scan);
                                              },
                                              icon: const Icon(
                                                Icons.phone_android,
                                              ),
                                            ),
                                            prefix: const Padding(
                                              padding: EdgeInsets.only(
                                                right: 8.0,
                                              ),
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

                                              isLoading:
                                                  apiController.isLoading.value,
                                              onPressed: () async {
                                                if (!_key.currentState!
                                                    .validate()) {
                                                  return;
                                                }

                                                final success = await apiController
                                                    .getPdiProfile(
                                                      '+226${pdiPhoneController.text.replaceAll(' ', '').trim()}',
                                                    );
                                                if (success) {
                                                  Get.back();
                                                  Get.toNamed(
                                                    AppRoutes.panier,

                                                    arguments: {
                                                      'pdi':
                                                          apiController
                                                              .pdiProfile
                                                              .value,
                                                    },
                                                  );
                                                }
                                              },
                                              backgroundColor:
                                                  AppColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[900],
                            foregroundColor: Colors.yellow,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text("Entrer le numéro de la personne"),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.scan);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green[900],

                            side: BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text("Scanner le QR code"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
