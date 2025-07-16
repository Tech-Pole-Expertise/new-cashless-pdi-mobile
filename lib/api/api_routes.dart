class ApiRoutes {
  static const String _base = 'cashless.mzeba.dev';
  static Uri checkToken = Uri.https(
    _base,
    '/merchant-api/token-check/',
  );
    static Uri refreshToken = Uri.https(
    _base,
    '/merchant-api/token-refresh/',
  );
  static Uri login = Uri.https(_base, '/merchant-api/auth/login/');
  static Uri initPasswordChange = Uri.https(
    _base,
    '/merchant-api/auth/update-password/',
  );
  static Uri confirmPasswordChange = Uri.https(
    _base,
    '/merchant-api/auth/otp/verify/update-password/',
  );
  static Uri initPasswordReset = Uri.https(
    _base,
    '/merchant-api/auth/init-password-reset/',
  );
    static Uri resumePasswordReset = Uri.https(
    _base,
    '/merchant-api/auth/resume-password-reset/',
  );
  static Uri completePasswordReset = Uri.https(
    _base,
    '/merchant-api/auth/complete-password-reset/',
  );

  static Uri userProfile = Uri.https(_base, '/merchant-api/auth/user/profile/');
  static Uri userProfileUpdate = Uri.https(
    _base,
    '/merchant-api/auth/user/profile/update/',
  );
  static Uri history = Uri.https(_base, '/merchant-api/withdrawal-history/');
  static Uri initWithdraw = Uri.https(_base, '/merchant-api/withdrawal/');
  static Uri withdrawValidation = Uri.https(
    _base,
    '/merchant-api/validate-withdrawal/',
  );
    static Uri refreshWihtdrawalOtp = Uri.https(
    _base,
    '/merchant-api/refresh-withdrawal-otp/',
  );
  static Uri getMarchandStock = Uri.https(_base, '/merchant-api/get-stocks/');
  static Uri getMarchandAppro = Uri.https(
    _base,
    '/merchant-api/supply-history/',
  );
  static Uri getMarchandStats = Uri.https(
    _base,
    '/merchant-api/get-stats/',
  );
  static Uri getContactInfos = Uri.https(
    _base,
    '/merchant-api/call-center-infos/',
  );

  /// Pour getPdiProfile, on doit construire dynamiquement avec l'ID
  static Uri getPdiProfile(String idPdi) =>
      Uri.https(_base, '/merchant-api/get-pdi/$idPdi/');
}
