import 'package:get/get.dart';
import 'package:pv_deme/api/controllers/api_controller.dart';

class HomeController extends GetxController {
  final ApiController apiController = Get.find<ApiController>();

  @override
  void onReady() {
    super.onReady();
    apiController.getMarchandStat(); // Recharge les stats automatiquement
  }
}
