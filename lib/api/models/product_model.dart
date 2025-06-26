class ProductModel {
  final String id;
  final String label;
  final String weight;
  final String quantite;

  ProductModel( {required this.id, required this.label, required this.weight,required this.quantite,});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      label: json['name'] as String,
      weight: json['description'] as String,
      quantite:json['qte_virtuelle'] as String
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': label, 'description': weight,'qte_virtuelle':quantite};
  }
}
