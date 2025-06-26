import 'dart:convert';

import 'package:get/get.dart';
import 'package:logger/web.dart';
import 'package:pdi_deme/api/Service/merchant_data_store_controller.dart';
import 'package:pdi_deme/api/models/merchand_model.dart';
import 'package:pdi_deme/api/models/pdi_model.dart';
import 'package:pdi_deme/api/providers/api_provider.dart';
import 'package:pdi_deme/routes/app_routes.dart';

class ApiController extends GetxController {
  // Add your API-related methods and properties here
  // For example, you might want to fetch data from an API or handle authentication
  final ApiProvider _apiProvider = ApiProvider();

  final Logger logger = Logger();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  // Example of an API call method

  @override
  void onClose() {
    // Clean up resources if needed
    super.onClose();
  }

  /* * //////////********Authentication System ********/////////////
 * 
 *  This section handles user authentication, including login, password change, and user profile retrieval.
 *  It uses the ApiProvider to make HTTP requests to the API endpoints defined in ApiRoutes.
 */
  Future<void> login(Map<String, dynamic> payload) async {
    try {
      isLoading.value = true;

      final response = await _apiProvider.login(payload);
      // Logger().d('Login response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final merchant = MerchandModel.fromJson(data);
        logger.d('Merchant data: ${merchant.toJson()}');

        final merchantController = Get.find<MerchantController>();
        merchantController.saveMerchant(merchant);

        Get.offAllNamed(AppRoutes.bottom);
        logger.d('Login successful: $data');
      } else {
        logger.d('Status code error');
        final data = jsonDecode(response.body);
        errorMessage.value = data['detail'];
        Get.toNamed(
          AppRoutes.apiError,
          arguments: {
            'title': 'Erreur lors de la tentative de connexion',
            'message': errorMessage.value,
          },
        );
      }
    } catch (e) {
      errorMessage.value = 'Login failed: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Change Password
  Future<void> initPasswordChange(Map<String, dynamic> payload) async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.initPasswordchange(payload);
      if (response.statusCode == 200) {
        logger.d('Password changed successfully: ${response.body}');
      } else {
        final data = jsonDecode(response.body);
        errorMessage.value = data['detail'];
        Get.toNamed(
          AppRoutes.apiError,
          arguments: {
            'title': 'Une erreur s\'est produite',
            'message': errorMessage.value,
          },
        );
      }
    } catch (e) {
      errorMessage.value = 'Change password failed: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> confirmPasswordChange(Map<String, dynamic> payload) async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.confirmPasswordchange(payload);
      if (response.statusCode == 200) {
        logger.d('Password changed successfully: ${response.body}');
      } else {
        final data = jsonDecode(response.body);
        errorMessage.value = data['detail'];
        Get.toNamed(
          AppRoutes.apiError,
          arguments: {
            'title': 'Une erreur s\'est produite',
            'message': errorMessage.value,
          },
        );
      }
    } catch (e) {
      errorMessage.value = 'Change password failed: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Reset Password
  Future<bool> initPasswordReset(Map<String, dynamic> payload) async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.initPasswordReset(payload);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        logger.d('Password changed successfully: $data');
        return true;
      } else {
        final data = jsonDecode(response.body);
        errorMessage.value = data['detail'];
        Get.toNamed(
          AppRoutes.apiError,
          arguments: {
            'title': 'Une erreur s\'est produite',
            'message': errorMessage.value,
          },
        );
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Change password failed: $e';
      Get.toNamed(
        AppRoutes.apiError,
        arguments: {
          'title': 'Une erreur s\'est produite',
          'message': 'Une erreur inconnue est survenue',
        },
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> confirmPasswordReset(Map<String, dynamic> payload) async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.confirmPasswordReset(payload);
      if (response.statusCode == 200) {
        logger.d('Password changed successfully: ${response.body}');
      } else {
        final data = jsonDecode(response.body);
        errorMessage.value = data['detail'];
        Get.toNamed(
          AppRoutes.apiError,
          arguments: {
            'title': 'Une erreur s\'est produite',
            'message': errorMessage.value,
          },
        );
      }
    } catch (e) {
      errorMessage.value = 'Change password failed: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getUserProfile() async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.getUserProfile();
      if (response.statusCode == 200) {
        logger.d('User profile fetched successfully: ${response.body}');
      } else {
        errorMessage.value =
            'Fetch user profile failed: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Fetch user profile failed: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /* * //////////********Withdraw System ********/////////////
   * 
   *  This section allows for updating the user profile with new data.
   *  It uses the ApiProvider to send a PUT request to the user profile update endpoint.
   */

  Future<void> getPdiProfile(String idPdi) async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.getPdiProfile(idPdi);
      logger.d('API REQUESTED SUCCESSFULY');
      if (response.statusCode == 200) {
        logger.d('Status code 200');
        final data = jsonDecode(response.body);
        final pdiProfile = PdiModel.fromJson(data);
        Get.toNamed(AppRoutes.pdiProfile, arguments: pdiProfile);
        logger.d('PDI profile fetched successfully: ${response.body}');
      } else {
        logger.d('Status code error');
        final data = jsonDecode(response.body);
        errorMessage.value = data['detail'];
        Get.toNamed(
          AppRoutes.apiError,
          arguments: {
            'title': 'Erreur lors de la récupération du profil PDI',
            'message': errorMessage.value,
          },
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.toNamed(
        AppRoutes.apiError,
        arguments: {
          'title': 'Une erreur s\'est produite',
          'message': errorMessage.value,
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> initWithdraw(Map<String, dynamic> payload) async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.initWithdraw(payload);
      if (response.statusCode == 200) {
        logger.d('Withdrawal initiated successfully: ${response.body}');
        Get.toNamed(AppRoutes.otpVerify, arguments: {'time': 60});
      } else {
        final data = jsonDecode(response.body);
        errorMessage.value =
            'Initiate withdrawal failed: ${response.statusCode}';
        Get.toNamed(
          AppRoutes.apiError,
          arguments: {
            'title': 'Une erreur s\'est produite',
            'message': data['detail'],
          },
        );
      }
    } catch (e) {
      errorMessage.value = 'Initiate withdrawal failed: $e';
      Get.toNamed(
        AppRoutes.apiError,
        arguments: {
          'title': 'Une erreur s\'est produite',
          'message': errorMessage.value,
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> withdrawValidation(Map<String, dynamic> payload) async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.withdrawValidation(payload);
      if (response.statusCode == 200) {
        logger.d('Withdrawal validated successfully: ${response.body}');
      } else {
        errorMessage.value =
            'Withdrawal validation failed: ${response.statusCode}';
             final data = jsonDecode(response.body);
        errorMessage.value =
            'Initiate withdrawal failed: ${response.statusCode}';
        Get.toNamed(
          AppRoutes.apiError,
          arguments: {
            'title': 'Une erreur s\'est produite',
            'message': data['detail'],
          },
        );
      }
    } catch (e) {
      errorMessage.value = 'Withdrawal validation failed: $e';
       Get.toNamed(
        AppRoutes.apiError,
        arguments: {
          'title': 'Une erreur s\'est produite',
          'message': errorMessage.value,
        },
      );
    } finally {
      isLoading.value = false;
    }
  }
}
