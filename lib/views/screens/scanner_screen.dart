import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pdi_deme/constant/app_color.dart';
import 'package:pdi_deme/routes/app_routes.dart';
import 'package:pdi_deme/views/widget/custom_circle_progress_bar.dart';
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
  bool isProcessing = false;
  QRViewController? controller;
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
    controller?.resumeCamera();
    Logger().d('QR CONTROLLER initiée');
    qrController.scannedDataStream.listen((scanData) async {
      Logger().d('QR DÉTECTÉ : ${scanData.code}');
      if (isProcessing) return;
      isProcessing = true;
      _handleScan(scanData.code);
    });
    controller?.getFlashStatus().then((status) {
      setState(() {
        isFlashOn = status ?? false;
      });
    });
  }

  void _handleScan(String? rawData) async {
    Logger().d('_handle call');
    if (rawData == null) {
      return;
    }
    try {
      final data = jsonDecode(rawData);
      if (data is Map<String, dynamic> && data.containsKey('email')) {
        showDialog(
          context: context,
          builder:
              (_) => CustomCircleProgressBar(
                color: AppColors.primary,
                backgroundColor: Colors.white,
                strokeWidth: 3,
              ),
        );
        await Future.delayed(Duration(seconds: 2)); // simulation de chargement

        Get.back(); // ferme le loading
        Get.toNamed(AppRoutes.pdiProfile, arguments: data);
      } else {
        Get.toNamed(
          AppRoutes.errorScan,
          arguments: {'message': 'Format invalide : email non trouvé'},
        );
      }
    } catch (e) {
      Get.toNamed(
        AppRoutes.errorScan,
        arguments: {'message': 'Erreur de décodage JSON : ${e.toString()}'},
      );
    } finally {
      isProcessing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scanner'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Placer le QRCODE dans le cadre ci-dessous pour une lecture automatique.',
                style: TextStyle(fontSize: 16),
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

            Padding(
              padding: const EdgeInsets.all(14),
              child: SizedBox(
                width: Get.width,
                child: CustomElevatedButonWithIcons(
                  backgroundColor: AppColors.primary,
                  label: isFlashOn ? 'Désactiver le Flash' : 'Activer le Flash',
                  icon: isFlashOn ? Icons.flash_on : Icons.flash_off,
                  onPressed: () async {
                    await controller?.toggleFlash();
                    bool? status = await controller?.getFlashStatus();
                    setState(() {
                      isFlashOn = status ?? false;
                    });
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
    );
  }
}
