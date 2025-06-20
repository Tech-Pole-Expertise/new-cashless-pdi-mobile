class PdiPossesionModel {
  final String products;
  final String quantity;

  PdiPossesionModel({
    required this.products,
    required this.quantity,
  });
  factory PdiPossesionModel.fromJson(Map<String,dynamic>json){
    return PdiPossesionModel(
      products: json['products'] ?? '',
      quantity: json['quantity'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'products': products,
      'quantity': quantity,
    };
  }
}
