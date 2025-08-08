import 'package:get_storage/get_storage.dart';
import 'package:pv_deme/api/models/token_model.dart';

class TokenDataStoreProvider {
   final box = GetStorage();


  void saveToken(final TokenModel token) {
    box.write('token', token.toJson());
  }
  TokenModel? getToken() {
    final data = box.read('token');
    if (data != null) {
      return TokenModel.fromJson(data);
    }
    return null;
  }
  Future<void> clearToken() async {
    await box.remove('token');
  }

   
  
}