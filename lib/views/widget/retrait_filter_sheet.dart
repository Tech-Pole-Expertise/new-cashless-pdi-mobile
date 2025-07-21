import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pv_deme/api/controllers/api_controller.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/views/widget/elevated_button_with_icons.dart';

class RetraitFilterSheet extends StatefulWidget {
  const RetraitFilterSheet({super.key});

  @override
  State<RetraitFilterSheet> createState() => _RetraitFilterSheetState();
}

class _RetraitFilterSheetState extends State<RetraitFilterSheet> {
  final TextEditingController clientController = TextEditingController();
  final TextEditingController identifierController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  final ApiController apiController = Get.find<ApiController>();
  void applyFilters() {
    final queryClient = clientController.text.toLowerCase();
    final queryId = identifierController.text.toLowerCase();

    // Ajuster startDate et endDate aux bornes de journée
    final adjustedStart =
        startDate != null
            ? DateTime(
              startDate!.year,
              startDate!.month,
              startDate!.day,
              0,
              0,
              0,
            )
            : null;

    final adjustedEnd =
        endDate != null
            ? DateTime(endDate!.year, endDate!.month, endDate!.day, 23, 59, 59)
            : null;

    final filtered =
        apiController.retraitHistoryData.where((retrait) {
          final identifier = retrait.pdi.identifier.toLowerCase();
          final clientName = retrait.clientName.toLowerCase();
          final retraitDate = retrait.date;

          final matchClient =
              queryClient.isEmpty || clientName.contains(queryClient);

          final matchId = queryId.isEmpty || identifier.contains(queryId);

          final matchDate =
              (adjustedStart == null ||
                  retraitDate.isAtSameMomentAs(adjustedStart) ||
                  retraitDate.isAfter(adjustedStart)) &&
              (adjustedEnd == null ||
                  retraitDate.isAtSameMomentAs(adjustedEnd) ||
                  retraitDate.isBefore(adjustedEnd));

          return matchClient && matchId && matchDate;
        }).toList();

    apiController.filteredRetraitHistoryData.assignAll(filtered);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          TextFormField(
            controller: clientController,
            decoration: InputDecoration(
              label: Text("Nom du client"),
              hintText: "Zongo Karim",
              prefixIcon: Icon(Icons.person, color: AppColors.primary),

              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
          ),

          const SizedBox(height: 12),
          TextFormField(
            controller: identifierController,
            decoration: InputDecoration(
              label: Text("Identifiant"),
              hintText: "22 00 34 56",
              prefixIcon: Icon(Icons.code_sharp, color: AppColors.primary),

              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
          ),

          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                    text:
                        startDate != null
                            ? DateFormat('dd/MM/yyyy').format(startDate!)
                            : '',
                  ),
                  decoration: InputDecoration(
                    labelText: 'Date de début',
                    hintText: 'Choisir',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: const OutlineInputBorder(),
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: startDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                      locale: const Locale('fr', 'FR'),
                    );
                    if (picked != null) {
                      setState(() {
                        startDate = picked;
                      });
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
                        endDate != null
                            ? DateFormat('dd/MM/yyyy').format(endDate!)
                            : '',
                  ),
                  decoration: InputDecoration(
                    labelText: 'Date de fin',
                    hintText: 'Choisir',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: const OutlineInputBorder(),
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: endDate ?? startDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                      locale: const Locale('fr', 'FR'),
                    );
                    if (picked != null) {
                      setState(() {
                        endDate = picked;
                      });
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          SizedBox(
            width: Get.width,
            child: CustomElevatedButonWithIcons(
              backgroundColor: AppColors.primary,
              label: 'Appliquer les filtres',
              labelColor: Colors.yellow,
              iconColor: Colors.yellow,
              icon: Icons.filter_alt,
              onPressed: applyFilters,
            ),
          ),
        ],
      ),
    );
  }
}
