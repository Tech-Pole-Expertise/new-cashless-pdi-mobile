class ContactInfoModel {
  final String callCenterPhoneNumber;
  final String whatsappPhoneNumber;
  final String callCenterEmail;

  ContactInfoModel({
    required this.callCenterPhoneNumber,
    required this.whatsappPhoneNumber,
    required this.callCenterEmail,
  });

  factory ContactInfoModel.fromJson(Map<String, dynamic> json) {
    return ContactInfoModel(
      callCenterPhoneNumber: json['call_center_phonenumber'] ?? '',
      whatsappPhoneNumber: json['whatsapp_phonenumber'] ?? '',
      callCenterEmail: json['call_center_email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'call_center_phonenumber': callCenterPhoneNumber,
      'whatsapp_phonenumber': whatsappPhoneNumber,
      'call_center_email': callCenterEmail,
    };
  }
}
