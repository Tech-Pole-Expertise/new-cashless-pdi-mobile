import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pdi_deme/api/Service/merchand_data_store_provider.dart';
import 'package:pdi_deme/api/models/merchand_model.dart';
import 'package:pdi_deme/routes/app_routes.dart';

class MerchantController extends GetxController {
  final Rxn<MerchandModel> merchant = Rxn<MerchandModel>();
  final MerchandDataStore _merchandDataStore = MerchandDataStore();
  @override
  void onInit() {
    loadMerchant();
    super.onInit();
  }

  void loadMerchant() {
    final stored = _merchandDataStore.getUserData();
    merchant.value = stored;
  }

  void saveMerchant(MerchandModel data) {
    Logger().d('Saving merchant data: ${data.toJson()}');
    _merchandDataStore.saveUserData(data);
    merchant.value = data;
    Logger().d('Merchant saved: ${merchant.value?.toJson()}');
  }

  void logout() {
    _merchandDataStore.clearUserData();
    merchant.value = null;
    Get.offAllNamed(AppRoutes.login);
  }
}
