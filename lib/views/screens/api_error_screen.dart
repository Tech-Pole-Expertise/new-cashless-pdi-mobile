import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pv_deme/constant/app_color.dart';
import 'package:pv_deme/views/widget/elevated_button_with_icons.dart';

class ApiErrorScreen extends StatelessWidget {
  const ApiErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;

    final int statusCode = args?['status_code'] ?? 0;
    final VoidCallback? onRetry = args?['onRetry'];

    final errorContent = _getErrorContent(statusCode, args);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(errorContent['icon'], color: AppColors.error, size: 100),
              const SizedBox(height: 20),
              Text(
                errorContent['title'],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                errorContent['message'],
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButonWithIcons(
                  backgroundColor: AppColors.error,
                  label: onRetry != null ? "Réessayer" : "Retour",
                  icon: onRetry != null ? Icons.refresh : Icons.arrow_back,
                  onPressed: () {
                    if (onRetry != null) {
                      onRetry();
                    } else {
                      Get.back();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getErrorContent(
    int statusCode,
    Map<String, dynamic>? args,
  ) {
    switch (statusCode) {
      case 400:
        return {
          'icon': Icons.warning_amber_rounded,
          'title': 'Opération échouée',
          'message':
              args?['message'] ??
              'Veuillez vérifier les informations envoyées.',
        };
      case 401:
        return {
          'icon': Icons.lock_outline,
          'title': 'Non autorisé',
          'message':
              args?['message'] ??
              'Vous devez être connecté pour accéder à cette ressource.',
        };
      case 403:
        return {
          'icon': Icons.block,
          'title': 'Accès refusé',
          'message':
              args?['message'] ??
              'Vous n\'avez pas la permission d\'effectuer cette action.',
        };
      case 404:
        return {
          'icon': Icons.search_off,
          'title': 'Ressource introuvable',
          'message': args?['message'] ?? 'La ressource demandée n\'existe pas.',
        };
      case 500:
        return {
          'icon': Icons.error,
          'title': 'Erreur serveur',
          'message':
              args?['message'] ??
              'Une erreur est survenue sur le serveur. Veuillez réessayer plus tard.',
        };
      case -1: // Cas pour aucune connexion internet
        return {
          'icon': Icons.wifi_off,
          'title': 'Pas de connexion',
          'message':
              args?['message'] ?? 'Veuillez vérifier votre connexion Internet.',
        };
      default:
        return {
          'icon': Icons.warning,
          'title': args?['title'] ?? 'Erreur inconnue',
          'message': args?['message'] ?? 'Une erreur inattendue est survenue.',
        };
    }
  }
}
