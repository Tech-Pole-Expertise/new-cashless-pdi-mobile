class CategoryModel {
  final String code;
  final String label;

  CategoryModel({
    required this.code,
    required this.label,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      code: json['code'] ?? 'unknown',
      label: json['label'] ?? 'Non précisé',
    );
  }

  /// ✅ Constructeur vide par défaut
  factory CategoryModel.empty() {
    return CategoryModel(
      code: 'unknown',
      label: 'Non précisé',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'label': label,
    };
  }
}
