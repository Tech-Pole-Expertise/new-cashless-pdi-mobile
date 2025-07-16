import 'category_model.dart'; // à adapter selon ton chemin

class UserInfosModel {
  final String? birthdate;
  final String? gender;
  final String centre;
  final String? docType;
  final String? docNumber;
  final CategoryModel category;

  UserInfosModel({
     this.birthdate,
     this.gender,
    required this.centre,
     this.docType,
     this.docNumber,
    required this.category,
  });

  factory UserInfosModel.fromJson(Map<String, dynamic> json) {
    return UserInfosModel(
      birthdate: json['birthdate']??'Non précisé',
      gender: json['gender'] ??'Non précisé',
      centre: json['centre_pdi']??'Non précisé',
      docType: json['document_type']??'Non précisé',
      docNumber: json['document_number'] ?? 'Non précisé',

      category: json['category'] != null
    ? CategoryModel.fromJson(json['category'])
    : CategoryModel.empty(),

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'birthdate': birthdate,
      'gender': gender,
      'centre_pdi':centre,
      'document_type':docType,
      'document_number': docNumber,
      'category': category.toJson(),
    };
  }
}
