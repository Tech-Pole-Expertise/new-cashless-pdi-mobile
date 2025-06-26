class ApiRoutes {
  static const String _base = 'cashless.mzeba.dev';

  static Uri login = Uri.https(_base, '/merchant-api/auth/login/');
  static Uri initPasswordChange = Uri.https(
    _base,
    'merchant-api/auth/update-password/',
  );
   static Uri confirmPasswordChange = Uri.https(
    _base,
   ' /merchant-api/auth/otp/verify/update-password/'
,
  );
  static Uri initPasswordReset = Uri.https(
    _base,
    '/merchant-api/auth/reset-password/',
  );
  static Uri resetPasswordConfirm = Uri.https(
    _base,
    'merchant-api/auth/otp/verify/reset-password/'
  );

  static Uri userProfile = Uri.https(_base, '/merchant-api/auth/user/profile/');
  static Uri userProfileUpdate = Uri.https(
    _base,
    '/merchant-api/auth/user/profile/update/',
  );
  static Uri history = Uri.https(_base, '/merchant-api/history/');
  static Uri initWithdraw = Uri.https(_base, '/merchant-api/withdrawal/');
  static Uri withdrawValidation = Uri.https(
    _base,
    '/merchant-api/otp/withdraw-verification/',
  );

  /// Pour getPdiProfile, on doit construire dynamiquement avec l'ID
  static Uri getPdiProfile(String idPdi) =>
      Uri.https(_base, '/merchant-api/get-pdi/$idPdi/');
}
