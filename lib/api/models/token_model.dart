class TokenModel {
  final String token;
  final String refresh;

  TokenModel({
    required this.token,
    required this.refresh,
  });


factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      token: json['access'] as String,
      refresh: json['refresh'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access': token,
      'refresh': refresh,
    };
  }
  @override
  String toString() {
    return 'TokenModel(access: $token, refresh: $refresh)';
  }
}