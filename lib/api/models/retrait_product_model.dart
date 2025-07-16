class RetraitProductModel {
  final String id;
  final String code;
  final String qtte;

  RetraitProductModel({required this.id, required this.code,  required this.qtte});

  Map<String, dynamic> toJson() {
    return {'id':id, 'code': code,  'qte': qtte};
  }

}
