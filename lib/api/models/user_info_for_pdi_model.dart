import 'category_model.dart'; // à adapter selon ton chemin

class UserInfosModel {
  final String birthdate;
  final String gender;
  final String centre;
  final String docType;
  final String docNumber;
  final CategoryModel category;

  UserInfosModel({
    required this.birthdate,
    required this.gender,
    required this.centre,
    required this.docType,
    required this.docNumber,
    required this.category,
  });

  factory UserInfosModel.fromJson(Map<String, dynamic> json) {
    return UserInfosModel(
      birthdate: json['birthdate'],
      gender: json['gender'],
      centre: json['centre_pdi'],
      docType: json['document_type'],
      docNumber: json['document_number'],

      category: CategoryModel.fromJson(json['category']),
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
