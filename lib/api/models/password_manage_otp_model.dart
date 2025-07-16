class PasswordManageOtpModel {
  final String detail;
  final String otp;
  final int otpDuration;
  PasswordManageOtpModel({
    required this.detail,
    required this.otp,
    required this.otpDuration
  });

  factory  PasswordManageOtpModel.fromJson(Map<String,dynamic>json){
    return PasswordManageOtpModel(
      detail: json['message'],
      otp: json['otp'],
      otpDuration: json['otp_valid_duration']
    );
  }
  

 Map<String, dynamic> toJson() {
   
    return {
      'message':detail,
      'otp':otp,
      'otpDuration':otpDuration
    };
  }
}
