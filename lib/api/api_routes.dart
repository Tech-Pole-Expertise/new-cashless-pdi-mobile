class ApiRoutes {
  static const String baseUrl = 'https://cashless.mzeba.dev/merchant-api';

  static const String login = '$baseUrl/login/';
  static const String passwordChange = '$baseUrl/auth/change-password/';
  static const String userProfile = '$baseUrl/auth/user/profile/';
  static const String userProfileUpdate = '$baseUrl/auth/user/profile/update/';
  static const String getPdiProfile = '$baseUrl/merchant-api/get-pdi/';
  static const String history = '$baseUrl/history/';
  static const String initWithdraw = '$baseUrl/withdrawal/';
  static const String withdrawValidation ='$baseUrl/otp/withdraw-verification/';
}
