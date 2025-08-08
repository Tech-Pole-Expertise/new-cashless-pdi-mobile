class TokenModel {
  final String token;
  final String refreshToken;

  TokenModel({
    required this.token,
    required this.refreshToken,
  });


factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
    };
  }
  @override
  String toString() {
    return 'TokenModel(token: $token, refreshToken: $refreshToken)';
  }
}