import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';
import 'package:pdi_deme/api/Service/merchant_data_store_controller.dart';
import 'package:pdi_deme/api/controllers/api_controller.dart';
import 'package:pdi_deme/constant/app_color.dart';
import 'package:pdi_deme/routes/app_routes.dart';
import 'package:pdi_deme/views/widget/custom_text_field.dart';
import 'package:pdi_deme/views/widget/elevated_button.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final TextEditingController cardNumberController = TextEditingController();
  final ApiController apiController = Get.find<ApiController>();
  final GlobalKey<FormState> _key = GlobalKey();

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
      appBar: AppBar(title: const Text('Accueil'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          (merchant.photoUrl != null &&
                                  merchant.photoUrl!.isNotEmpty)
                              ? NetworkImage(merchant.photoUrl!)
                              : const AssetImage(
                                    'assets/img/defaut_profil.jpeg',
                                  )
                                  as ImageProvider,
                    ),
                  ),

                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${merchant.firstName} ${merchant.lastName}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(merchant.username, style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 215,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha((0.08 * 255).toInt()),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Scannnez manuellement',
                    style: TextStyle(
                      fontSize: 24,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Veuillez entrer le numéro de la carte',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 12),
                  Form(
                    key: _key,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomTextField(
                        controller: cardNumberController,
                        label: 'Numéro de la carte',
                        isPassword: false,
                        maxLength: 24,
                        hint: 'Entrez le numéro de la carte',
                        keyboardType: TextInputType.number,

                        suffixIcon: IconButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.scan);
                          },
                          icon: Icon(Icons.qr_code_scanner),
                        ),
                        prefixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 8),
                            Icon(Icons.credit_card),
                            const Text(
                              'No : ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => CustomElevatedButton(
                label: 'Valider',
                isLoading: apiController.isLoading.value,
                onPressed: () {
                  if (!_key.currentState!.validate()) {
                    
                  }
                  apiController.getPdiProfile(cardNumberController.text);
                },
                backgroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
