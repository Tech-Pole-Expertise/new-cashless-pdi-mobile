import 'package:get/get.dart';
import 'package:logger/web.dart';
import 'package:pdi_deme/api/providers/api_provider.dart';

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
      if (response.statusCode == 200) {
        logger.d('Login successful: ${response.data}');
      } else {
        // Handle error response
        errorMessage.value = 'Login failed: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Login failed: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword(Map<String, dynamic> payload) async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.changePassword(payload);
      if (response.statusCode == 200) {
        logger.d('Password changed successfully: ${response.data}');
      } else {
        errorMessage.value = 'Change password failed: ${response.statusCode}';
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
        logger.d('User profile fetched successfully: ${response.data}');
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
      if (response.statusCode == 200) {
        logger.d('PDI profile fetched successfully: ${response.data}');
      } else {
        errorMessage.value = 'Fetch PDI profile failed: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Fetch PDI profile failed: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> initWithdraw(Map<String, dynamic> payload) async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.initWithdraw(payload);
      if (response.statusCode == 200) {
        logger.d('Withdrawal initiated successfully: ${response.data}');
      } else {
        errorMessage.value =
            'Initiate withdrawal failed: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Initiate withdrawal failed: $e';
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> withdrawValidation(Map<String, dynamic> payload) async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.withdrawValidation(payload);
      if (response.statusCode == 200) {
        logger.d('Withdrawal validated successfully: ${response.data}');
      } else {
        errorMessage.value =
            'Withdrawal validation failed: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Withdrawal validation failed: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
