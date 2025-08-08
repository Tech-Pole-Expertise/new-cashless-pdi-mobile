import 'package:get/get.dart';
import 'package:pv_deme/api/Service/token_data_store_provider.dart';
import 'package:pv_deme/api/models/token_model.dart';

class TokenDataController  extends GetxController{
  final TokenDataStoreProvider tokenProvider = TokenDataStoreProvider();

  void saveToken(TokenModel token) {
    tokenProvider.saveToken(token);
  }
  TokenModel? getToken() {
    return tokenProvider.getToken();
  }
  Future<void> clearToken() async {
    await tokenProvider.clearToken();
  }
}