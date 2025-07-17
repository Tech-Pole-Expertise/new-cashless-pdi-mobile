import 'package:pv_deme/api/models/panier_model.dart';
import 'package:pv_deme/api/models/user_info_for_pdi_model.dart';
// à adapter

class PdiModel {
  final String identifier;
  final String firstname;
  final String lastname;
  final String phone;
  
  final bool isPdi;
  final String? photoUrl;
  final List<PanierProduitModel> possessions;
  final UserInfosModel userInfos;

  PdiModel({
    required this.identifier,
    required this.firstname,
    required this.lastname,
    required this.phone,
    
    required this.isPdi,
     this.photoUrl,
    required this.possessions,
    required this.userInfos,
  });

  factory PdiModel.fromJson(Map<String, dynamic> json) {
    return PdiModel(
      identifier: json['identifier'],
      firstname: json['first_name'],
      lastname: json['last_name'],
      phone: json['phone'],
      
      isPdi: json['is_pdi'],
      photoUrl: json['photo'],
      possessions:
          (json['produits'] as List<dynamic>)
              .map((e) => PanierProduitModel.fromJson(e))
              .toList(),
      userInfos: UserInfosModel.fromJson(json['user_infos']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'first_name': firstname,
      'last_name': lastname,
      'phone': phone,
      'is_pdi': isPdi,
      'photo': photoUrl,
      'possessions': possessions.map((e) => e.toJson()).toList(),
      'user_infos': userInfos.toJson(),
    };
  }
}
