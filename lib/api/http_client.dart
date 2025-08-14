import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:pv_deme/api/Service/merchant_data_store_controller.dart';
import 'package:pv_deme/api/Service/token_data_controller.dart';
import 'package:pv_deme/api/models/token_model.dart';
import 'package:pv_deme/api/providers/api_provider.dart';
import 'package:pv_deme/views/widget/custom_snack_bar.dart';

class CustomHttpClient {

  final storage = GetStorage();
  bool isSessionExpiredHandled = false;
  // final ApiController _apiController = Get.find<ApiController>();
  // final MerchantController _merchantController = Get.put(MerchantController());
  // final ApiController _apiController = Get.put(ApiController());
 late final MerchantController _merchantController;
  late final TokenDataController _tokenDataController;


  CustomHttpClient() {
    _merchantController = Get.find<MerchantController>();
    _tokenDataController = Get.find<TokenDataController>();
  }
  Future<Map<String, String>> _getHeaders({bool authRequired = false}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (authRequired) {
      final TokenModel? token = _tokenDataController.getToken();
      final String? tokenValue = token?.token;
      final String? resetTokenForPassword = storage.read('reset_token');
      if (resetTokenForPassword != null) {
        headers['Authorization'] = 'Bearer $resetTokenForPassword';
      } else if (token != null) {
        headers['Authorization'] = 'Bearer $tokenValue';
      }
    }

    return headers;
  }

  Future<http.Response> _retryRequest(
    Future<http.Response> Function() requestFn,
  ) async {
    final refreshSuccess = await refreshToken();

    if (refreshSuccess) {
      isSessionExpiredHandled = false; // Reset le flag
      return await requestFn(); // Refaire la requête
    } else {
      // Afficher le message et logout une seule fois
      if (!isSessionExpiredHandled) {
        isSessionExpiredHandled = true;

        CustomSnackBar().showError(
          'Session Expirée',
          'Votre session est expirée. Veuillez vous reconnecter.',
        );
        _merchantController.logout();
      }

      throw Exception('Échec du renouvellement du token');
    }
  }

  Future<bool> refreshToken() async {
    try {
      final tokenController = Get.find<TokenDataController>();
      final token = tokenController.getToken();
      final response = await ApiProvider().refreshToken({
        'refresh': token!.refreshToken.toString(),
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        tokenController.saveToken(TokenModel.fromJson(data));
        Logger().d('Token refreshed successfully: ${response.body}');
        return true;
      } else {
        Logger().d('Failed to refresh token: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // logger.d('Error refreshing token: $e');
      return false;
    }
  }

  // Méthodes HTTP avec retry automatique
  Future<http.Response> get(Uri endpoint, {bool authRequired = false}) async {
    final headers = await _getHeaders(authRequired: authRequired);
    final response = await http.get(endpoint, headers: headers);

    if (authRequired && response.statusCode == 401) {
      return await _retryRequest(
        () => get(endpoint, authRequired: authRequired),
      );
    }

    return response;
  }

  Future<http.Response> post(
    Uri endpoint, {
    Map<String, dynamic>? data,
    bool authRequired = false,
  }) async {
    final headers = await _getHeaders(authRequired: authRequired);
    final response = await http.post(
      endpoint,
      headers: headers,
      body: jsonEncode(data),
    );

    if (authRequired && response.statusCode == 401) {
      return await _retryRequest(
        () => post(endpoint, data: data, authRequired: authRequired),
      );
    }

    return response;
  }

  Future<http.Response> put(
    Uri endpoint, {
    Map<String, dynamic>? data,
    bool authRequired = false,
  }) async {
    final headers = await _getHeaders(authRequired: authRequired);
    final response = await http.put(
      endpoint,
      headers: headers,
      body: jsonEncode(data),
    );

    if (authRequired && response.statusCode == 401) {
      return await _retryRequest(
        () => put(endpoint, data: data, authRequired: authRequired),
      );
    }

    return response;
  }

  Future<http.Response> delete(
    Uri endpoint, {
    bool authRequired = false,
  }) async {
    final headers = await _getHeaders(authRequired: authRequired);
    final response = await http.delete(endpoint, headers: headers);

    if (authRequired && response.statusCode == 401) {
      return await _retryRequest(
        () => delete(endpoint, authRequired: authRequired),
      );
    }

    return response;
  }
}
