import 'package:dio/dio.dart';
import 'package:pdi_deme/api/api_routes.dart';
import 'package:pdi_deme/api/dio_client.dart';

class ApiProvider {
  final DioClient dioClient = DioClient();

  Future<Response<dynamic>> login(String email, String password) async {
     return dioClient.post(ApiRoutes.login);
 
  }

  Future<Response<dynamic>> changePassword() async {
    return dioClient.put(ApiRoutes.passwordChange);
  }
}
