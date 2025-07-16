import 'package:http/http.dart' as http;
import 'package:pdi_deme/api/api_routes.dart';
import 'package:pdi_deme/api/http_client.dart';

class ApiProvider {
  final CustomHttpClient _client = CustomHttpClient();

  /*   * //////////********Authentication System ********/////////////
   * 
   *  This section handles user authentication, including login, password change, and user profile retrieval.
   *  It uses the httpClient to make HTTP requests to the API endpoints defined in ApiRoutes.
   */

  // Login

  Future<http.Response> login(Map<String, dynamic> payload) async {
    return await _client.post(
      ApiRoutes.login,
      data: payload,
      authRequired: false,
    );
  }

  Future<http.Response> checkToken() async {
    return await _client.get(ApiRoutes.checkToken, authRequired: false);
  }

  Future<http.Response> refreshToken() async {
    return await _client.get(ApiRoutes.refreshToken, authRequired: false);
  }

  // Reset Password
  Future<http.Response> initPasswordReset(Map<String, dynamic> payload) async {
    return await _client.post(
      ApiRoutes.initPasswordReset,
      data: payload,
      authRequired: false,
    );
  }

  Future<http.Response> resumePasswordReset(
    Map<String, dynamic> payload,
  ) async {
    return await _client.post(
      ApiRoutes.resumePasswordReset,
      data: payload,
      authRequired: false,
    );
  }

  Future<http.Response> confirmPasswordReset(
    Map<String, dynamic> payload,
  ) async {
    return await _client.post(
      ApiRoutes.completePasswordReset,
      data: payload,
      authRequired: true,
    );
  }

  // Change Password
  Future<http.Response> initPasswordchange(Map<String, dynamic> payload) async {
    return await _client.post(
      ApiRoutes.initPasswordChange,
      data: payload,
      authRequired: true,
    );
  }

  Future<http.Response> confirmPasswordchange(
    Map<String, dynamic> payload,
  ) async {
    return await _client.post(
      ApiRoutes.confirmPasswordChange,
      data: payload,
      authRequired: true,
    );
  }

  // Get Logged User Profile
  Future<http.Response> getUserProfile() async {
    return await _client.get(ApiRoutes.userProfile, authRequired: true);
  }

  /*   * //////////********Withdraw System ********/////////////
   * 
   *  This section allows for viewing PDI profile, initiating withdrawals, validating, and viewing history.
   */

  // Get PDI Profile by ID
  Future<http.Response> getPdiProfile(String idPdi) async {
    return await _client.get(
      ApiRoutes.getPdiProfile(idPdi),
      authRequired: true,
    );
  }

  // Init Withdraw
  Future<http.Response> initWithdraw(Map<String, dynamic> payload) async {
    return await _client.post(
      ApiRoutes.initWithdraw,
      data: payload,
      authRequired: true,
    );
  }

  Future<http.Response> refreshWithdrawOtp(Map<String, dynamic> payload) async {
    return await _client.post(
      ApiRoutes.refreshWihtdrawalOtp,
      data: payload,
      authRequired: true,
    );
  }

  // Withdraw Validation
  Future<http.Response> withdrawValidation(Map<String, dynamic> payload) async {
    return await _client.post(
      ApiRoutes.withdrawValidation,
      data: payload,
      authRequired: true,
    );
  }

  // Get History
  Future<http.Response> getHistory() async {
    return await _client.get(ApiRoutes.history, authRequired: true);
  }

  Future<http.Response> getMarchandAppro() async {
    return await _client.get(ApiRoutes.getMarchandAppro, authRequired: true);
  }

  Future<http.Response> getMarchandStock() async {
    return await _client.get(ApiRoutes.getMarchandStock, authRequired: true);
  }
   Future<http.Response> getMarchandStat() async {
    return await _client.get(ApiRoutes.getMarchandStats, authRequired: true);
  }

    Future<http.Response> getCallCenterInfos() async {
    return await _client.get(ApiRoutes.getContactInfos, authRequired: true);
  }
}
