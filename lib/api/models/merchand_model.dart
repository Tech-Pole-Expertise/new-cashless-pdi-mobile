class MerchandModel {

  final String username;
  final String firstName;
  final String lastName;
  final String? photoUrl;
  final String identifier;
  final bool isMerchand;

  MerchandModel( {
    
    required this.username,
    required this.firstName,
    required this.lastName,
    this.photoUrl,
    required this.identifier,
    required this.isMerchand,
  });

  factory MerchandModel.fromJson(Map<String,dynamic>json){
    return MerchandModel(
     
      username: json['username'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      photoUrl: json['photo'] ?? '',
      identifier: json['identifier'] ?? '',
      isMerchand: json['is_merchant'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
     
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'photo': photoUrl,
      'identifier': identifier,
      'is_merchant': isMerchand,
    };
  }
}
