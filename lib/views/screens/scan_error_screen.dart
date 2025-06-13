import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorScanScreen extends StatelessWidget {
  const ErrorScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(title: Text('Erreur')),
      body: Center(
        child: Text(
          args['message'] ?? 'Erreur inconnue',
          style: TextStyle(color: Colors.red, fontSize: 18),
        ),
      ),
    );
  }
}
