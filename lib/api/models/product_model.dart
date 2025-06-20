class ProductModel {
  final String id;
  final String label;
  final String weight;

  ProductModel({required this.id, required this.label, required this.weight});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      label: json['name'] as String,
      weight: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': label, 'description': weight};
  }
}
