import 'package:pdi_deme/api/models/pdi_model.dart';

class RetraitHistoryModel {
  final String identifier;
  final String clientName;
  final DateTime date;
  final PdiModel pdi;
  final List<ProduitRetire> produits;

  RetraitHistoryModel({
    required this.identifier,
    required this.clientName,
    required this.date,
    required this.pdi,
    required this.produits,
  });

  factory RetraitHistoryModel.fromJson(Map<String, dynamic> json) {
    final pdi = PdiModel.fromJson(json['pdi']);

    final produits = (json['produits'] as List<dynamic>? ?? [])
        .map((e) => ProduitRetire.fromJson(e))
        .toList();

    return RetraitHistoryModel(
      identifier: pdi.identifier,
      clientName: '${pdi.firstname} ${pdi.lastname}',
      date: DateTime.parse(json['created_at']),
      pdi: pdi,
      produits: produits,
    );
  }
}

class ProduitRetire {
  final String produit;
  final int qte;
  final String poids;

  ProduitRetire({
    required this.produit,
    required this.qte,
    required this.poids,
  });

  factory ProduitRetire.fromJson(Map<String, dynamic> json) {
    return ProduitRetire(
      produit: json['produit'] ?? '',
      qte: json['qte'] ?? 0,
      poids: json['poids']?.toString() ?? '0',
    );
  }
}
