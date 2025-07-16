class RetraitOtpModel {
  final String message;
  final String retraitId;
  final String otp;
  final int otpDuration;
  RetraitOtpModel({
    required this.message,
    required this.retraitId,
    required this.otp,
    required this.otpDuration
  });

  factory  RetraitOtpModel.fromJson(Map<String,dynamic>json){
    return RetraitOtpModel(
      message: json['message'],
      retraitId: json['retrait_id'],
      otp: json['otp'],
      otpDuration: json['otp_valid_duration']
    );
  }
  

 Map<String, dynamic> toJson() {
   
    return {
      'message':message,
      'retraitId':retraitId,
      'otp':otp,
      'otpDuration':otpDuration
    };
  }
}
