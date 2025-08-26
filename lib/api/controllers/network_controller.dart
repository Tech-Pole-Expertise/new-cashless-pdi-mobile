import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  RxBool isConnected = true.obs; // valeur réactive
  bool _isSnackbarOpen = false;

  VoidCallback? onReconnect;

  @override
  void onInit() {
    super.onInit();

    // Vérifie l'état initial
    _connectivity.checkConnectivity().then((status) {
      _updateConnexionStatus(status);
    });

    // Écoute les changements
    _connectivity.onConnectivityChanged.listen((status) {
      _updateConnexionStatus(status);
    });
  }

  Future<void> _updateConnexionStatus(List<ConnectivityResult> result) async {
    bool connected = !result.contains(ConnectivityResult.none);

    // 🔥 Vérification réelle de la connexion Internet
    if (connected) {
      connected = await _hasInternet();
    }

    bool wasConnected = isConnected.value;
    isConnected.value = connected;

    if (!connected) {
      _showSnackbar();
    } else {
      if (_isSnackbarOpen) {
        _isSnackbarOpen = false;
        if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
      }

      // Actualiser les données si on vient de se reconnecter
      if (!wasConnected && connected && onReconnect != null) {
        onReconnect!();
      }
    }
  }

  Future<bool> _hasInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void _showSnackbar() {
    if (_isSnackbarOpen) return;
    _isSnackbarOpen = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.overlayContext == null) return;

      Get.rawSnackbar(
        title: "Connexion perdue",
        messageText: const Text(
          "Vous êtes hors ligne. Veuillez vérifier votre connexion.",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        icon: const Icon(Icons.wifi_off, color: Colors.white),
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.TOP,
        borderRadius: 8,
        margin: const EdgeInsets.all(12),
        isDismissible: false,
        shouldIconPulse: true,
        duration: const Duration(days: 1),
      );
    });
  }
}
