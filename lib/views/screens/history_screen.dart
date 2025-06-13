import 'package:flutter/material.dart';
import 'package:pdi_deme/views/widget/custom_card_for_history.dart';
import 'package:pdi_deme/views/widget/custom_text_field.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});
  final TextEditingController recherche = TextEditingController();
  final TextEditingController filter = TextEditingController();
  final List<Map<String, dynamic>> data = [
    {
      'cardNumber': '0045TYHS',
      'clientName': 'Zakaria ZOUAR',
      'date': '2023-10-01',
      'montant': '3P',
    },
    {
      'cardNumber': '0089HJGF',
      'clientName': 'Samira ZONGO',
      'date': '2023-12-01',
      'montant': '3P',
    },
    {
      'cardNumber': '0325RFQS',
      'clientName': 'Ramires KABRE',
      'date': '2023-11-15',
      'montant': '2P',
    },
    {
      'cardNumber': '0912KLMP',
      'clientName': 'Fatimata OUEDRAOGO',
      'date': '2023-09-20',
      'montant': '5P',
    },
    {
      'cardNumber': '1147TZBC',
      'clientName': 'Ibrahim TRAORE',
      'date': '2023-08-10',
      'montant': '1P',
    },
    {
      'cardNumber': '2894WQER',
      'clientName': 'Awa KABORE',
      'date': '2023-07-05',
      'montant': '4P',
    },
    {
      'cardNumber': '3389YTRE',
      'clientName': 'Hamidou NIKIEMA',
      'date': '2023-06-01',
      'montant': '3P',
    },
    {
      'cardNumber': '4590UIOP',
      'clientName': 'Nadège BAKO',
      'date': '2023-05-28',
      'montant': '6P',
    },
    {
      'cardNumber': '5638LKJD',
      'clientName': 'Mohamed SAWADOGO',
      'date': '2023-04-17',
      'montant': '2P',
    },
    {
      'cardNumber': '6710ZXCV',
      'clientName': 'Clarisse TALL',
      'date': '2023-03-09',
      'montant': '4P',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique ventes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Logique de rafraîchissement ici
            },
          ),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: CustomTextField(
                      label: 'Recherche',
                      controller: recherche,
                      hint: 'Rechercher une transaction',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          // Logique de recherche ici
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  SizedBox(
                    width: 120,
                    child: CustomTextField(
                      label: 'Filtrer',
                      controller: filter,
                      hint: 'Filtrer par date ou montant',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.filter_alt),
                        onPressed: () {
                          // Logique de filtrage ici
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: CustomTableForHistory(data: data),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
