import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pdi_deme/api/Service/merchand_data_store_provider.dart';
import 'package:pdi_deme/api/models/merchand_model.dart';

class CustomHttpClient {
  final MerchandDataStore _merchandDataStore = MerchandDataStore();

  Future<Map<String, String>> _getHeaders({bool authRequired = false}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (authRequired) {
      final MerchandModel? merchand = _merchandDataStore.getUserData();
      final String? token = merchand?.token;
      final String? resetToken = GetStorage().read('reset_token');
      if (resetToken != null) {
        headers['Authorization'] = 'Bearer $resetToken';
      } else if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<http.Response> get(Uri endpoint, {bool authRequired = false}) async {
    final headers = await _getHeaders(authRequired: authRequired);
    return await http.get(endpoint, headers: headers);
  }

  Future<http.Response> post(
    Uri endpoint, {
    Map<String, dynamic>? data,
    bool authRequired = false,
  }) async {
    final headers = await _getHeaders(authRequired: authRequired);

    return await http.post(endpoint, headers: headers, body: jsonEncode(data));
  }

  Future<http.Response> put(
    Uri endpoint, {
    Map<String, dynamic>? data,
    bool authRequired = false,
  }) async {
    final headers = await _getHeaders(authRequired: authRequired);
    return await http.put(endpoint, headers: headers, body: jsonEncode(data));
  }

  Future<http.Response> delete(
    Uri endpoint, {
    bool authRequired = false,
  }) async {
    final headers = await _getHeaders(authRequired: authRequired);
    return await http.delete(endpoint, headers: headers);
  }
}
