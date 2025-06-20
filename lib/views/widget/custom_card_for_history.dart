import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pdi_deme/constant/app_color.dart';

class CustomTableForHistory extends StatelessWidget {
  final List<Map<String, dynamic>> data;
   CustomTableForHistory({super.key, required this.data});
  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Juin 2023',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          DataTable(
            columnSpacing: 15,
            headingRowColor: WidgetStateProperty.all(AppColors.primaryLight),
            dataRowColor: WidgetStateProperty.all(Colors.white),
            columns: const [
              DataColumn(label: Text('N° Carte')),
              DataColumn(label: Text('Client')),
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Montant')),
            ],
            rows:
                data.map((item) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(item['cardNumber']),
                        onTap: () {
                          logger.d('Le cardNumber est : ${item['cardNumber']}');
                        },
                      ),
                      DataCell(
                        Text(item['clientName']),
                        onTap: () {
                          logger.d(
                            'Le nom du client est : ${item['clientName']}',
                          );
                        },
                      ),
                      DataCell(
                        Text(item['date']),
                        onTap: () {
                          logger.d('La date est : ${item['date']}');
                        },
                      ),
                      DataCell(
                        Text(item['montant']),
                        onTap: () {
                          logger.d('Le montant est : ${item['montant']}');
                        },
                      ),
                    ],
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  // Exemple de fonction pour afficher les détails, par exemple via un dialog
  // void showDetails(MyItem item) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('Détails'),
  //       content: Text('Nom : ${item.name}\nÂge : ${item.age}'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('Fermer'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
