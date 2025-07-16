class ProduitAppro {
  final int qte;
  final String produit;
  final String poids; // On laisse en String après conversion

  ProduitAppro({
    required this.qte,
    required this.produit,
    required this.poids,
  });

  factory ProduitAppro.fromJson(Map<String, dynamic> json) {
    return ProduitAppro(
      qte: json['qte'],
      produit: json['produit'],
      poids: json['poids'].toString(), // conversion ici
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'qte': qte,
      'produit': produit,
      'poids': poids,
    };
  }
}

class ApproModel {
  final List<ProduitAppro> produits;
  final DateTime date;

  ApproModel({
    required this.produits,
    required this.date,
  });

  factory ApproModel.fromJson(Map<String, dynamic> json) {
    return ApproModel(
      produits: (json['produits'] as List)
          .map((e) => ProduitAppro.fromJson(e))
          .toList(),
      date: DateTime.parse(json['date']), // conversion String → DateTime
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'produits': produits.map((e) => e.toJson()).toList(),
      'date': date.toIso8601String(),
    };
  }
}
