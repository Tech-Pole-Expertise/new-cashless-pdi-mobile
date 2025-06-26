class RetraitProductModel {
  final String code;
  final int qtte;

  RetraitProductModel({required this.code, required this.qtte});

  Map<String, dynamic> toJson() {
    return {'code': code, 'qte': qtte};
  }
}
