import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/web.dart';
import 'package:pv_deme/api/Service/merchant_data_store_controller.dart';
import 'package:pv_deme/api/models/contact_info_model.dart';
import 'package:pv_deme/api/models/marchand_appro_model.dart';
import 'package:pv_deme/api/models/merchand_model.dart';
import 'package:pv_deme/api/models/merchant_stat_model.dart';
import 'package:pv_deme/api/models/password_manage_otp_model.dart';
import 'package:pv_deme/api/models/pdi_model.dart';
import 'package:pv_deme/api/models/retrait_history_model.dart';
import 'package:pv_deme/api/models/retrait_otp_model.dart';
import 'package:pv_deme/api/models/stock_product_model.dart';
import 'package:pv_deme/api/providers/api_provider.dart';
import 'package:pv_deme/routes/app_routes.dart';
import 'package:pv_deme/views/widget/custom_snack_bar.dart';

class ApiController extends GetxController {
  // Add your API-related methods and properties here
  // For example, you might want to fetch data from an API or handle authentication
  final ApiProvider _apiProvider = ApiProvider();

  final Logger logger = Logger();
  var isLoading = false.obs;
  RxList<RetraitHistoryModel> retraitHistoryData = <RetraitHistoryModel>[].obs;
  RxList<RetraitHistoryModel> filteredRetraitHistoryData =
      <RetraitHistoryModel>[].obs;

  RxList<StockProductModel> marchandStocks = <StockProductModel>[].obs;
  RxList<ApproModel> marchandAppro = <ApproModel>[].obs;
  final Rx<PdiModel?> pdiProfile = Rx<PdiModel?>(null);
  final Rx<MerchantStatModel?> merchantStat = Rx<MerchantStatModel?>(null);
  final Rx<ContactInfoModel?> contactInfoModel = Rx<ContactInfoModel?>(null);

  var errorMessage = ''.obs;
  // Example of an API call method

  @override
  void onClose() {
    // Clean up resources if needed
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    getMarchandStat();
    retraitHistory();
    getContatInfos();
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
        CustomSnackBar().showError(
          'Erreur lors de la connexion',
          errorMessage.value,
        );
        logger.d('error ${errorMessage.value}');
        // CustomDialog.showError('Erreur de connexion', errorMessage.value);
        // Get.toNamed(
        //   AppRoutes.apiError,
        //   arguments: {
        //     'title': 'Erreur lors de la tentative de connexion',
        //     'message': errorMessage.value,
        //     'status_code': response.statusCode,
        //   },
        // );
      }
    } catch (e) {
      errorMessage.value = 'Login failed: $e';
      if (e is SocketException) {
        Get.toNamed(
          AppRoutes.apiError,
          arguments: {
            'title': 'Une erreur s\'est produite',
            'message':
                'Impossible de se connecter au serveur. Vérifiez votre connexion.',
            'status_code': -1,
          },
        );
      }
      logger.d('Une erreur login catch de type $e ');
      errorMessage.value = 'Login: $e';
      Get.toNamed(
        AppRoutes.apiError,
        arguments: {
          'title': 'Une erreur s\'est produite',
          'message': 'Une erreur inconnue est survenue',
        },
      );
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
        final data = jsonDecode(response.body);
        logger.d('Password changed successfully: ${response.body}');
        Get.offNamed(
          AppRoutes.otpVerifyForPassword,
          arguments: {
            'time': data['otp_valid_duration'],
            'isForPassword': true,
            'operationType': 'change',
          },
        );
      } else {
        final data = jsonDecode(response.body);
        final firstKey = data.keys.firstWhere(
          (k) => data[k] is List && data[k].isNotEmpty,
          orElse: () => '',
        );
        errorMessage.value = data[firstKey][0];
        CustomSnackBar().showError('Erreur', errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Change password failed: $e';
      if (e is SocketException) {
        Get.toNamed(
          AppRoutes.apiError,
          arguments: {
            'title': 'Une erreur s\'est produite',
            'message':
                'Impossible de se connecter au serveur. Vérifiez votre connexion.',
            'status_code': -1,
          },
        );
      }
      logger.d('Une erreur catch de type $e');
      errorMessage.value = 'Change password failed: $e';
      CustomSnackBar().showError('Erreur', 'Une erreur inconnue est survenue');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> confirmPasswordChange(Map<String, dynamic> payload) async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.confirmPasswordchange(payload);
      logger.d('Password changed successfully: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        logger.d('Message validation otp password change : ${response.body}');
        Get.offAllNamed(
          AppRoutes.successPage,
          arguments: {
            'title': 'Modification du mot de passe',
            'message': data['detail'],
            'nextRoute': AppRoutes.login,
            'logoutRequired': true,
          },
        );

        logger.d('Password changed successfully: ${response.body}');
        return true;
      } else {
        final data = jsonDecode(response.body);
        final firstKey = data.keys.firstWhere(
          (k) => data[k] is List && data[k].isNotEmpty,
          orElse: () => '',
        );
        if (firstKey.isNotEmpty && data[firstKey] != null) {
          errorMessage.value = data[firstKey][0];
        }
        CustomSnackBar().showError('Erreur', errorMessage.value);
        return false;
      }
    } catch (e) {
      if (e is SocketException) {
        Get.toNamed(
          AppRoutes.apiError,
          arguments: {
            'title': 'Une erreur s\'est produite',
            'message':
                'Impossible de se connecter au serveur. Vérifiez votre connexion.',
            'status_code': -1,
          },
        );
      }
      logger.d('Une erreur catch de type $e ');
      errorMessage.value = 'Une erreur est survenue';
      CustomSnackBar().showError('Erreur', errorMessage.value);

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Reset Password
  Future<void> initPasswordReset(Map<String, dynamic> payload) async {
    logger.d('Phone passed ${payload['phone']}');
    try {
      isLoading.value = true;
      final response = await _apiProvider.initPasswordReset(payload);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final PasswordManageOtpModel otp = PasswordManageOtpModel.fromJson(
          data,
        );
        logger.d('Password changed successfully: $data');
        Get.toNamed(
          AppRoutes.otpVerifyForPassword,
          arguments: {
            'time': otp.otpDuration,
            'phone': payload['phone'],
            'operationType': 'reset',
          },
        );
      } else {
        final data = jsonDecode(response.body);
        errorMessage.value = data['detail'];
        logger.i('Message :${errorMessage.value}');
        // CustomDialog.showError('Erreur', errorMessage.value);
        CustomSnackBar().showError('Erreur', errorMessage.value);
      }
    } catch (e) {
      if (e is SocketException) {
        Get.toNamed(
          AppRoutes.apiError,
          arguments: {
            'title': 'Une erreur s\'est produite',
            'message':
                'Impossible de se connecter au serveur. Vérifiez votre connexion.',
            'status_code': -1,
          },
        );
      }
      logger.d('Une erreur catch de type $e ');
      errorMessage.value = 'Change password failed: $e';
      CustomSnackBar().showError('Erreur', "Une erreur inconnue est survenue");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> resumePasswordReset(Map<String, dynamic> payload) async {
    logger.d('Resume reset data $payload');
    try {
      isLoading.value = true;
      final response = await _apiProvider.resumePasswordReset(payload);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        logger.d('Success otp password reset: $data');
        final token = data['reset_token'];
        GetStorage().write('reset_token', token);
        Get.toNamed(
          AppRoutes.changePassword,
          arguments: {'operationType': 'reset'},
        );
        logger.d('Password changed successfully: $data');
        return true;
      } else {
        final data = jsonDecode(response.body);
        if (data['non_field_errors'] != null &&
            data['non_field_errors'] is List) {
          errorMessage.value = data['non_field_errors'][0];
        }
        if (data['detail'] != null) {
          errorMessage.value = data['detail'];
        }

        logger.d('Erreur confirm otp password reset: $data');

        CustomSnackBar().showError('Erreur', errorMessage.value);
        return false;
      }
    } catch (e) {
      if (e is SocketException) {
        Get.toNamed(
          AppRoutes.apiError,
          arguments: {
            'title': 'Une erreur s\'est produite',
            'message':
                'Impossible de se connecter au serveur. Vérifiez votre connexion.',
            'status_code': -1,
          },
        );
      }
      logger.d('Une erreur catch de type $e ');
      errorMessage.value = 'Change password failed: $e';
      CustomSnackBar().showError('Erreur', "Une erreur inconnue est survenue");
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
        GetStorage().remove('reset_token');
        Get.offAllNamed(
          AppRoutes.successPage,
          arguments: {
            'title': 'Gestion de mot de passe',
            'message': 'Mot de passe réinitialisé avec succès!',
            'nextRoute': AppRoutes.login,
            'logoutRequired': false, // <-- On ne logout pas
          },
        );

        logger.d('Password changed successfully: ${response.body}');
      } else {
        final data = jsonDecode(response.body);
        errorMessage.value = data['detail'];
        CustomSnackBar().showError('Erreur', errorMessage.value);
      }
    } catch (e) {
      if (e is SocketException) {
        Get.toNamed(
          AppRoutes.apiError,
          arguments: {
            'title': 'Une erreur s\'est produite',
            'message':
                'Impossible de se connecter au serveur. Vérifiez votre connexion.',
            'status_code': -1,
          },
        );
      }
      logger.d('Une erreur catch de type $e ');
      errorMessage.value = 'Change password failed: $e';

      CustomSnackBar().showError('Erreur', "Une erreur inconnue est survenue");
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

  Future<bool> getPdiProfile(String idPdi) async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.getPdiProfile(idPdi);
      logger.d('API REQUESTED SUCCESSFULLY');

      if (response.statusCode == 200) {
        logger.d('Status code 200');
        final data = jsonDecode(response.body);
        final profile = PdiModel.fromJson(data);

        // Stocker dans la variable observable
        pdiProfile.value = profile;

        logger.d('PDI profile fetched successfully: ${response.body}');
        return true;
      } else {
        final data = jsonDecode(response.body);
        logger.d('message $data');

        // Cas 1 : message d'erreur simple
        if (data is Map && data.containsKey('detail')) {
          errorMessage.value = data['detail'];
        }
        // Cas 2 : erreur du type {identifier: [message]}
        else if (data is Map && data.entries.isNotEmpty) {
          final firstKey = data.keys.first;
          final firstValue = data[firstKey];

          if (firstValue is List && firstValue.isNotEmpty) {
            errorMessage.value = firstValue.first.toString();
          } else {
            errorMessage.value = 'Une erreur est survenue';
          }
        }

        CustomSnackBar().showError('Erreur', errorMessage.value);

        return false;
      }
    } catch (e) {
      if (e is SocketException) {
        CustomSnackBar().showError('Erreur', "Erreur de connexion internet");
        return false;
      }

      logger.d('Une erreur catch de type $e ');
      errorMessage.value = e.toString();

      CustomSnackBar().showError('Erreur', "Une erreur s'est produite");

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> initWithdraw(Map<String, dynamic> payload) async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.initWithdraw(payload);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        logger.d('Withdrawal initiated successfully: ${response.body}');
        Get.offNamedUntil(
          AppRoutes.otpVerify,
          ModalRoute.withName(AppRoutes.panier),
          arguments: {
            'time': data['otp_valid_duration'],
            'retraitId': data['retrait_id'] as String,
          },
        );
      } else {
        final data = jsonDecode(response.body);
        logger.d('Message erreur  : ${response.body}');
        errorMessage.value = data['detail'];
        CustomSnackBar().showError('Erreur', errorMessage.value);
      }
    } catch (e) {
      if (e is SocketException) {
        Get.toNamed(
          AppRoutes.apiError,
          arguments: {
            'title': 'Une erreur s\'est produite',
            'message':
                'Impossible de se connecter au serveur. Vérifiez votre connexion.',
            'status_code': -1,
          },
        );
      }
      logger.d('Une erreur catch de type $e ');
      errorMessage.value = 'Initiate withdrawal failed: $e';

      CustomSnackBar().showError('Erreur', "Une erreur inconnue est survenue");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> withdrawValidation(Map<String, dynamic> payload) async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.withdrawValidation(payload);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        logger.d('Withdrawal validated successfully: ${response.body}');
        Get.offAllNamed(AppRoutes.retraitSuccess, arguments: data['message']);
        return true;
      } else {
        final data = jsonDecode(response.body);
        errorMessage.value = data['message'];
        logger.d('Erreur validation $data');
        CustomSnackBar().showError('Erreur', errorMessage.value);
        return false;
      }
    } catch (e) {
      if (e is SocketException) {
        Get.toNamed(
          AppRoutes.apiError,
          arguments: {
            'title': 'Une erreur s\'est produite',
            'message':
                'Impossible de se connecter au serveur. Vérifiez votre connexion.',
            'status_code': -1,
          },
        );
      } else {
        logger.d('Exception de type $e');
        CustomSnackBar().showError(
          'Erreur',
          "Une erreur inconnue est survenue",
        );
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<RetraitOtpModel> refreshWithdrawOtp(
    Map<String, dynamic> payload,
  ) async {
    logger.d('retrait ID : ${payload['retrait_id']}');
    try {
      isLoading.value = true;
      final response = await _apiProvider.refreshWithdrawOtp(payload);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final RetraitOtpModel retraitOtpModel = RetraitOtpModel.fromJson(data);
        CustomSnackBar().showSuccess('Renvoie OTP', retraitOtpModel.message);
        logger.d('Nouveau otp : ${retraitOtpModel.otp}');
        return retraitOtpModel;
      } else {
        final data = jsonDecode(response.body);
        logger.d('Erreur lors du refresh otp : $data');
        errorMessage = data['message'];
        CustomSnackBar().showError('Erreur', errorMessage.value);
        return RetraitOtpModel(
          message: 'message',
          retraitId: '0',
          otp: 'otp',
          otpDuration: 1,
        );
      }
    } catch (e) {
      logger.d('Erreur caatch lors du refresh otp : $e');
      CustomSnackBar().showError('Erreur', "Une erreur est survenue");

      return RetraitOtpModel(
        message: 'message',
        retraitId: '0',
        otp: 'otp',
        otpDuration: 1,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> retraitHistory() async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.getHistory();

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        retraitHistoryData.assignAll(
          data.map(
            (retrait) =>
                RetraitHistoryModel.fromJson(retrait as Map<String, dynamic>),
          ),
        );
        filteredRetraitHistoryData.assignAll(
          data.map(
            (retrait) =>
                RetraitHistoryModel.fromJson(retrait as Map<String, dynamic>),
          ),
        );
      } else {
        logger.d('Échec du chargement: ${response.statusCode}');
      }
    } catch (e) {
      if (e is SocketException) {
        Get.toNamed(
          AppRoutes.apiError,
          arguments: {
            'title': 'Une erreur s\'est produite',
            'message':
                'Impossible de se connecter au serveur. Vérifiez votre connexion.',
            'status_code': -1,
          },
        );
      }
      logger.d(
        'Une erreur catch de type $e lors de la récupération des historiques',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMarchandStock() async {
    logger.d('Stock appelé');
    try {
      isLoading.value = true;
      final response = await _apiProvider.getMarchandStock();

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        logger.d('Données Stock : $data');
        marchandStocks.assignAll(
          data.map(
            (retrait) =>
                StockProductModel.fromJson(retrait as Map<String, dynamic>),
          ),
        );
        logger.d('Stock convertie $marchandStocks');
      } else {
        logger.d('Échec du chargement du sotck: ${response.statusCode}');
      }
    } catch (e) {
      if (e is SocketException) {
        Get.toNamed(
          AppRoutes.apiError,
          arguments: {
            'title': 'Une erreur s\'est produite',
            'message':
                'Impossible de se connecter au serveur. Vérifiez votre connexion.',
            'status_code': -1,
          },
        );
      }
      logger.d('Une erreur catch de type $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMarchandAppro() async {
    logger.d('Appro appelé');
    try {
      isLoading.value = true;
      final response = await _apiProvider.getMarchandAppro();

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        logger.d('Données Appro : $data');
        marchandAppro.assignAll(
          data.map(
            (retrait) => ApproModel.fromJson(retrait as Map<String, dynamic>),
          ),
        );
        logger.d('Appro convertie $marchandAppro');
      } else {
        logger.d('Échec du chargement Appro: ${response.statusCode}');
      }
    } catch (e) {
      if (e is SocketException) {
        Get.toNamed(
          AppRoutes.apiError,
          arguments: {
            'title': 'Une erreur s\'est produite',
            'message':
                'Impossible de se connecter au serveur. Vérifiez votre connexion.',
            'status_code': -1,
          },
        );
      }
      logger.d(
        'Une erreur catch de type $e lors de la récupération des historiques',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMarchandStat() async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.getMarchandStat();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        logger.d('Je convertie');
        final MerchantStatModel merchantStatModel = MerchantStatModel.fromJson(
          data,
        );
        logger.d('Conversion terminée');
        merchantStat.value = merchantStatModel;
      } else {
        final data = jsonDecode(response.body);
        logger.d('Erreur lors du chargement des stats : $data');
      }
    } catch (e) {
      logger.d('Erreur catch lors du chargement des stats : $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getContatInfos() async {
    try {
      isLoading.value = true;
      final response = await _apiProvider.getCallCenterInfos();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        logger.d('Je convertie');
        final ContactInfoModel contact = ContactInfoModel.fromJson(data);
        logger.d('Conversion terminée');
        contactInfoModel.value = contact;
      } else {
        final data = jsonDecode(response.body);
        logger.d('Erreur lors du chargement des infos contact : $data');
      }
    } catch (e) {
      logger.d('Erreur catch lors du chargement des infos contact : $e');
    } finally {
      isLoading.value = false;
    }
  }
}
