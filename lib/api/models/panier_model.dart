class PanierProduitModel {
  final int id;
  final String libelle;
  final int quantite;
  bool isSelected;
  String retrait;

  PanierProduitModel({
    required this.id,
    required this.libelle,
    required this.quantite,
    this.isSelected = false,
    this.retrait = '',
  });

  factory PanierProduitModel.fromJson(Map<String, dynamic> json) {
    return PanierProduitModel(
      id: json['id'],
      libelle: json['libelle'],
      quantite: json['quantite'],
    );
  }
}
