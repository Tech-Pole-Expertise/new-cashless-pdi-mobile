import 'package:pdi_deme/api/models/retrait_product_model.dart';

class PanierProduitModel {
  final String id;
  final String label;
  final String code;
  final int quantite;
  final String poids;
  bool isSelected;
  String retrait;

  PanierProduitModel({
    required this.id,
    required this.label,
    required this.code,
    required this.quantite,
    required this.poids,
    this.isSelected = false,
    this.retrait = '',
  });

  factory PanierProduitModel.fromJson(Map<String, dynamic> json) {
    // final produit = json['produit'];
    return PanierProduitModel(
      id: json['id'], // ou utilise un autre identifiant unique si tu veux un `int`
      label: json['label'],
      code: json['code'],
      quantite: json['qte_virtuelle'],
      poids: json['poids'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'code':code,
      'qte_virtuelle': quantite,
      'poids': poids,
      'isSelected': isSelected,
      'retrait': retrait,
    };
  }
   RetraitProductModel toRetraitModel() {
    return RetraitProductModel(
      id:id,
      code: code,
      qtte: retrait,
    );
  }
}
