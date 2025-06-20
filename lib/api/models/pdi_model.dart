import 'package:pdi_deme/api/models/pdi_possesion_model.dart';

class PdiModel {
  final String identifier;
  final String firstname;
  final String lastname;
  final String phone;
  final bool isPdi;
  final String photoUrl;
  final PdiPossesionModel possesions;

  PdiModel({
    required this.identifier,
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.isPdi,
    required this.photoUrl,
    required this.possesions,
  });

  factory PdiModel.fromJson(Map<String, dynamic> json) {
    return PdiModel(
      identifier: json['id'],
      firstname: json['name'],
      lastname: json['description'],
      phone: json['imageUrl'],
      isPdi: json['type'],
      photoUrl: json['status'],
      possesions: PdiPossesionModel.fromJson(json['possesions'] ?? {}),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': identifier,
      'name': firstname,
      'description': lastname,
      'imageUrl': phone,
      'type': isPdi,
      'status': photoUrl,
      'possesions': possesions.toJson(),
    };
  }
}
