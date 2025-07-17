import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pv_deme/api/models/retrait_history_model.dart'; // Assure-toi d'importer le bon fichier
import 'package:pv_deme/constant/app_color.dart';

class CustomTableForHistory extends StatelessWidget {
  final List<RetraitHistoryModel> data;
  final Logger logger = Logger();
  final void Function(RetraitHistoryModel)? onRowTap;

  CustomTableForHistory({super.key, required this.data, this.onRowTap});

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
              'Juin 2025',
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
              DataColumn(label: Text('Quantité')),
            ],
            rows:
                data.map((item) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(item.identifier),
                        onTap: () => onRowTap?.call(item),
                      ),
                      DataCell(
                        Text(item.clientName),
                        onTap: () => onRowTap?.call(item),
                      ),
                      DataCell(
                        Text(
                          item.date.timeZoneName,
                        ), // juste la date sans l'heure
                        onTap: () => onRowTap?.call(item),
                      ),
                      DataCell(
                        Text('${item.produits.length}P'),
                        onTap: () => onRowTap?.call(item),
                      ),
                    ],
                    onSelectChanged: (_) => onRowTap?.call(item),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
