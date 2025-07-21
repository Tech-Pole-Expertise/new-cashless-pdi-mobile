import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pv_deme/api/Service/merchand_data_store_provider.dart';
import 'package:pv_deme/api/Service/merchant_data_store_controller.dart';
import 'package:pv_deme/api/controllers/api_controller.dart';
import 'package:pv_deme/api/models/merchand_model.dart';
import 'package:pv_deme/views/widget/custom_snack_bar.dart';

class CustomHttpClient {
  final MerchandDataStore _merchandDataStore = MerchandDataStore();
  final storage = GetStorage();
  // final ApiController _apiController = Get.find<ApiController>();
  // final MerchantController _merchantController = Get.find<MerchantController>();  
  Future<Map<String, String>> _getHeaders({bool authRequired = false}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (authRequired) {
      final MerchandModel? merchand = _merchandDataStore.getUserData();
      final String? token = merchand?.token;
      final String? resetToken = storage.read('reset_token');
      if (resetToken != null) {
        headers['Authorization'] = 'Bearer $resetToken';
      } else if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<http.Response> _retryRequest(
    Future<http.Response> Function() requestFn,
  ) async {
    final refreshSuccess = await _refreshToken();
    if (refreshSuccess) {
      return await requestFn(); // Retry original request
    } else {
      CustomSnackBar().showError(
        'Session Expirée',
        'Votre session est expirée. Veuillez vous reconnecter.',
      );
    // return _merchantController.logout(); // Logout if refresh fails
      throw Exception('Échec du renouvellement du token');

    }
  }

  Future<bool> _refreshToken() async {
    final refreshToken = storage.read('refresh_token');
    if (refreshToken == null) return false;

    final response = await http.post(
      Uri.parse('https://api.tonsite.com/refresh-token'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $refreshToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newAccessToken = data['access_token'];
      if (newAccessToken != null) {
        storage.write('reset_token', newAccessToken);
        return true;
      }
    }

    return false;
  }

  // Méthodes HTTP avec retry automatique
  Future<http.Response> get(Uri endpoint, {bool authRequired = false}) async {
    final headers = await _getHeaders(authRequired: authRequired);
    final response = await http.get(endpoint, headers: headers);

    if (authRequired && response.statusCode == 401) {
      return await _retryRequest(() => get(endpoint, authRequired: authRequired));
    }

    return response;
  }

  Future<http.Response> post(
    Uri endpoint, {
    Map<String, dynamic>? data,
    bool authRequired = false,
  }) async {
    final headers = await _getHeaders(authRequired: authRequired);
    final response = await http.post(endpoint, headers: headers, body: jsonEncode(data));

    if (authRequired && response.statusCode == 401) {
      return await _retryRequest(() => post(endpoint, data: data, authRequired: authRequired));
    }

    return response;
  }

  Future<http.Response> put(
    Uri endpoint, {
    Map<String, dynamic>? data,
    bool authRequired = false,
  }) async {
    final headers = await _getHeaders(authRequired: authRequired);
    final response = await http.put(endpoint, headers: headers, body: jsonEncode(data));

    if (authRequired && response.statusCode == 401) {
      return await _retryRequest(() => put(endpoint, data: data, authRequired: authRequired));
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
      return await _retryRequest(() => delete(endpoint, authRequired: authRequired));
    }

    return response;
  }
}
