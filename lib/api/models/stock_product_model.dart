class StockProductModel {
  final String id;
  final String code;
  final String label;
  final String poids;
  final int qtePhysique;

  StockProductModel({
    required this.id,
    required this.code,
    required this.label,
    required this.poids,
    required this.qtePhysique,
  });

  factory StockProductModel.fromJson(Map<String, dynamic> json) {
    return StockProductModel(
      id: json['id'] as String,
      code: json['code'] as String,
      label: json['label'] as String,
      poids: json['poids'] as String,
      qtePhysique: json['qte_physique'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'label': label,
      'poids': poids,
      'qte_physique': qtePhysique,
    };
  }
}
