import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:pdi_deme/api/models/merchand_model.dart';

class MerchandDataStore {
  final box = GetStorage();

  // Save user data
  Future<void> saveUserData(final MerchandModel merchant) async {
    await box.write('merchant',merchant.toJson());
}

  // Get user data
  MerchandModel? getUserData() {
    final data = box.read('merchant');
   Logger().d('Retrieved merchant data: $data');
    if (data != null) {
      return MerchandModel.fromJson(data);
    }
    return null;
  }

  // Clear user data
  Future<void> clearUserData() async {
    await box.remove('merchant');
  }
}
