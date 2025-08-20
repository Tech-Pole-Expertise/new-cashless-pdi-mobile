import 'package:get/get.dart';
import 'package:pv_deme/api/controllers/network_controller.dart';

class DependancyInjection {
  static void init() {
    // Initialize the controllers
    Get.put<NetworkController>(NetworkController(),permanent:true);
   
  }
}