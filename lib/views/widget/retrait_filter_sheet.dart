import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pv_deme/api/controllers/api_controller.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/views/widget/custom_outlined_button_with_icons.dart';
import 'package:pv_deme/views/widget/elevated_button_with_icons.dart';

class RetraitFilterSheet extends StatelessWidget {
  final BuildContext context;
  RetraitFilterSheet({super.key, required this.context});

  final ApiController apiController = Get.find<ApiController>();

  @override
  Widget build(context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Filtres avancés",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),

            // ✅ Nom client (pas besoin de Obx)
            TextFormField(
              controller: apiController.filterClientController,
              decoration: InputDecoration(
                label: Text("Nom du client"),
                hintText: "Zongo Karim",
                prefixIcon: Icon(Icons.person, color: AppColors.primary),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            // ✅ Identifiant
            TextFormField(
              controller: apiController.filterIdentifierController,
              decoration: InputDecoration(
                label: Text("Identifiant"),
                hintText: "22 00 34 56",
                prefixIcon: Icon(Icons.code_sharp, color: AppColors.primary),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            // ✅ Dates → ici on garde Obx car elles sont Rx
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                        text:
                            apiController.filterStartDate.value != null
                                ? DateFormat(
                                  'dd/MM/yyyy',
                                ).format(apiController.filterStartDate.value!)
                                : '',
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Date de début',
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate:
                              apiController.filterStartDate.value ??
                              DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                          locale: const Locale('fr', 'FR'),
                        );
                        if (picked != null) {
                          apiController.filterStartDate.value = picked;
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                        text:
                            apiController.filterEndDate.value != null
                                ? DateFormat(
                                  'dd/MM/yyyy',
                                ).format(apiController.filterEndDate.value!)
                                : '',
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Date de fin',
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate:
                              apiController.filterEndDate.value ??
                              apiController.filterStartDate.value ??
                              DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                          locale: const Locale('fr', 'FR'),
                        );
                        if (picked != null) {
                          apiController.filterEndDate.value = picked;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Bouton appliquer
            SizedBox(
              width: Get.width,
              child: CustomElevatedButonWithIcons(
                backgroundColor: AppColors.primary,
                label: 'Appliquer les filtres',
                labelColor: Colors.yellow,
                iconColor: Colors.yellow,
                icon: Icons.filter_alt,
                onPressed: () {
                  apiController.applyFilters();
                  Navigator.pop(context);
                },
              ),
            ),

            // ✅ Bouton reset (ne ferme pas)
            SizedBox(
              width: Get.width,
              child: CustomOutlinedButtonWithIcons(
                label: 'Réinitialiser les filtres',
                labelColor: AppColors.primary,
                icon: Icons.delete,
                onPressed: () {
                  apiController.resetFilters();
                },
                borderColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
