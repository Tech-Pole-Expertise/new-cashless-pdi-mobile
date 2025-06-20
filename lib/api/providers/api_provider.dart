import 'package:dio/dio.dart';
import 'package:pdi_deme/api/api_routes.dart';
import 'package:pdi_deme/api/dio_client.dart';

class ApiProvider {
  final DioClient dioClient = DioClient();

  /*   * //////////********Authentication System ********/////////////
   * 
   *  This section handles user authentication, including login, password change, and user profile retrieval.
   *  It uses the DioClient to make HTTP requests to the API endpoints defined in ApiRoutes.
   */
   
  // Login, Change Password, Get User Profile
   

  Future<Response<dynamic>> login(Map<String,dynamic>payload) async {
     return dioClient.post(ApiRoutes.login,data:payload);
 
  }

  Future<Response<dynamic>> changePassword(Map<String,dynamic>payload) async {
    return dioClient.put(ApiRoutes.passwordChange,data: payload);
  }

  Future<Response<dynamic>> getUserProfile() async {
    return dioClient.get(ApiRoutes.userProfile, queryParameters: {'authRequired': true});
  }


 /*   * //////////********Withdraw System ********/////////////
   * 
   *  This section allows for updating the user profile with new data.
   *  It uses the DioClient to send a PUT request to the user profile update endpoint.
   */

  Future<Response<dynamic>> getPdiProfile(String idPdi) async {
    return dioClient.get('${ApiRoutes.getPdiProfile}$idPdi/', queryParameters: {'authRequired': true});
  }
  Future<Response<dynamic>> initWithdraw(Map<String, dynamic> payload) async {
    return dioClient.post(ApiRoutes.initWithdraw, data: payload);
  }
  Future<Response<dynamic>> withdrawValidation(Map<String, dynamic> payload) async {
    return dioClient.post(ApiRoutes.withdrawValidation, data: payload);
  }
  Future<Response<dynamic>> getHistory() async {
    return dioClient.get(ApiRoutes.history, queryParameters: {'authRequired': true});
  }
}
