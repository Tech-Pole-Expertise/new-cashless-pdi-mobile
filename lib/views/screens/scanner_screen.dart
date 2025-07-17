import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pdi_deme/api/controllers/api_controller.dart';
import 'package:pdi_deme/constant/app_color.dart';
import 'package:pdi_deme/routes/app_routes.dart';
import 'package:pdi_deme/views/widget/custom_app_bar.dart';
import 'package:pdi_deme/views/widget/custom_circle_progress_bar.dart';
import 'package:pdi_deme/views/widget/custom_snack_bar.dart';
import 'package:pdi_deme/views/widget/elevated_button.dart';
import 'package:pdi_deme/views/widget/elevated_button_with_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isFlashOn = false;
  bool isFlashAvailable = false;
  bool isProcessing = false;
  QRViewController? controller;
  final ApiController apiController = Get.find<ApiController>();
  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  void _checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
      if (!status.isGranted) {
        // Si refusé, on quitte la page avec une alerte
        Get.defaultDialog(
          title: 'Permission refusée',
          middleText:
              'L\'accès à la caméra est requis pour scanner le QR code.',
          confirm: CustomElevatedButton(
            label: 'Fermer',
            onPressed: () {},
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void stopScannerAndExit() async {
    await controller?.pauseCamera();
    await controller?.stopCamera();
    Get.back(); // Ferme la page scanner
  }

  void _onQRViewCreated(QRViewController qrController) {
    controller = qrController;
    // Attendre un court moment pour laisser le temps au contrôleur de s'initialiser
    // Future.delayed(const Duration(milliseconds: 300), () {
    //   getFlashState();
    // });
    controller?.resumeCamera();
    Logger().d('QR CONTROLLER initiée');

    qrController.scannedDataStream.listen((scanData) async {
      Logger().d('QR DÉTECTÉ : ${scanData.code}');
      if (isProcessing) return;
      isProcessing = true;
      _handleScan(scanData.code);
    });
  }

  void _handleScan(String? rawData) async {
    Logger().d('_handle call');
    if (rawData == null) return;

    try {
      await controller?.pauseCamera();
      final data = _tryParseJson(rawData);
      Logger().d('Données scannées : $data');
      if (data == null ||
          data is! Map<String, dynamic> ||
          !data.containsKey('phone')) {
        CustomSnackBar().showError(
          'Erreur de format',
          "QR Code non pris en charge",
        );
        Future.delayed(const Duration(seconds: 5), () {
          controller?.resumeCamera(); // Reprendre caméra
        }); // Reprendre la caméra
        return;
      }

      if (data.containsKey('phone')) {
        // ✅ Afficher le loader

        final success = await apiController.getPdiProfile(data['identifier']);

        if (success) {
          Get.dialog(
            PopScope(
              canPop: false,
              child: Center(
                child: CustomCircleProgressBar(
                  color: AppColors.primary,
                  backgroundColor: Colors.white,
                  strokeWidth: 3,
                ),
              ),
            ),
            barrierDismissible: false,
          );
          Future.delayed(const Duration(seconds: 3), () {
            (Get.isDialogOpen ?? false);
            Get.back();
            controller?.stopCamera();
            Get.toNamed(
              AppRoutes.panier,
              arguments: {'pdi': apiController.pdiProfile.value},
            ); // Reprendre caméra
          });
        }
        Future.delayed(const Duration(seconds: 5), () {
          controller?.resumeCamera(); // Reprendre caméra
        });
      }
    } catch (e) {
      Logger().e('Erreur lors du scan : $e');

      CustomSnackBar().showError('Erreur', "Une erreur inconnu est survenue");

      //  Reprise après erreur
      Future.delayed(const Duration(seconds: 5), () {
        controller?.resumeCamera(); // Reprendre caméra
      });
    } finally {
      isProcessing = false;
    }
  }

  dynamic _tryParseJson(String input) {
    try {
      return jsonDecode(input);
    } catch (_) {
      return null;
    }
  }

  void _toggleFash() async {
    if (controller == null) return;

    try {
      await controller!.toggleFlash();

      final status = await controller!.getFlashStatus();
      Logger().d('ToggleFlash Status: $status');

      setState(() {
        isFlashOn = status ?? false;
      });
    } on CameraException catch (e) {
      Logger().e('Erreur Flash: ${e.code} - ${e.description}');
      CustomSnackBar().showError(
        'Erreur Flash',
        'Cet appareil ne dispose pas de flash.',
      );
    } catch (e) {
      Logger().e('Erreur inconnue lors du toggle flash: $e');
      CustomSnackBar().showError(
        'Erreur',
        'Une erreur inconnue est survenue lors de l’utilisation du flash.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Scanner le qr code'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Placer le QRCODE dans le cadre ci-dessous pour une lecture automatique.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center, // ✅ Texte centré
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: QRView(
                      overlay: QrScannerOverlayShape(
                        borderColor: AppColors.primary,
                        borderWidth: 5,
                        borderRadius: 12,
                      ),
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.all(14),
                child: SizedBox(
                  width: Get.width,
                  child: CustomElevatedButonWithIcons(
                    backgroundColor: AppColors.primary,
                    label:
                        isFlashOn ? 'Désactiver le Flash' : 'Activer le Flash',
                    icon: isFlashOn ? Icons.flash_on : Icons.flash_off,
                    onPressed: () async {
                      _toggleFash();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: () => Get.back(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Vous avez des problèmes avec le scan? ',
                      style: TextStyle(color: AppColors.textSecondary),
                      children: [
                        TextSpan(
                          text: 'Saisir manuellement',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
