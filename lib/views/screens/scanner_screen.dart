import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pv_deme/api/controllers/api_controller.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/routes/app_routes.dart';
import 'package:pv_deme/views/widget/custom_app_bar.dart';
import 'package:pv_deme/views/widget/custom_circle_progress_bar.dart';
import 'package:pv_deme/views/widget/custom_snack_bar.dart';
import 'package:pv_deme/views/widget/elevated_button.dart';
import 'package:pv_deme/views/widget/elevated_button_with_icons.dart';
import 'package:pv_deme/views/widget/phone_entry_bottom_sheet.dart';
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
            onPressed: () => Get.back(),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  // @override
  // void dispose() {
  //   controller?.dispose();
  //   super.dispose();
  // }

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
          controller?.resumeCamera();
        });
        return;
      }

      if (data.containsKey('phone')) {
        final success = await apiController.getPdiProfile(
          '${data['phone'].replaceAll(' ', '')}',
        );

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
            if (Get.isDialogOpen ?? false) Get.back();
            controller?.stopCamera();
            Get.toNamed(
              AppRoutes.panier,
              arguments: {'pdi': apiController.pdiProfile.value},
            );
          });
        }
        Future.delayed(const Duration(seconds: 5), () {
          controller?.resumeCamera();
        });
      }
    } catch (e) {
      Logger().e('Erreur lors du scan : $e');

      CustomSnackBar().showError('Erreur', "Une erreur inconnue est survenue");

      Future.delayed(const Duration(seconds: 5), () {
        controller?.resumeCamera();
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

  void _toggleFlash() async {
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
    final screenHeight = MediaQuery.of(context).size.height;
    final spacingHeight = screenHeight * 0.03;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Scanner le qr code'),
      body: Padding(
        padding: EdgeInsets.all(8.w), // Responsive padding
        child: SingleChildScrollView(
          // <-- Ajouté ici
          child: Column(
            children: [
              SizedBox(height: spacingHeight.clamp(10.0, 30.0)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'Placer le QRCODE dans le cadre ci-dessous pour une lecture automatique.',
                  style: TextStyle(fontSize: 16.sp),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.w),
                child: Container(
                  width: 280.w,
                  height: 280.w,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: QRView(
                      overlay: QrScannerOverlayShape(
                        borderColor: AppColors.primary,
                        borderWidth: 5.w,
                        borderRadius: 12.r,
                      ),
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              Padding(
                padding: EdgeInsets.all(20.w),
                child: SizedBox(
                  width: Get.width,
                  child: CustomElevatedButonWithIcons(
                    labelColor: Colors.yellow,
                    iconColor: Colors.yellow,
                    backgroundColor: AppColors.primary,
                    label:
                        isFlashOn ? 'Désactiver le Flash' : 'Activer le Flash',
                    icon: isFlashOn ? Icons.flash_on : Icons.flash_off,
                    onPressed: _toggleFlash,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.r),
                      ),
                    ),
                    builder:
                        (_) =>
                            PhoneEntryBottomSheet(showLoadingIndicator: true),
                  ).then((_) {
                    // Le bottom sheet est fermé → on relance la caméra
                    controller?.resumeCamera();
                  });

                  // Juste avant de l'ouvrir, on met la caméra en pause :
                  controller?.pauseCamera();
                },
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: RichText(
                    text: TextSpan(
                      text: 'Des problèmes avec le scan? ',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14.sp,
                      ),
                      children: [
                        TextSpan(
                          text: 'Saisir manuellement',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
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
