import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:pdi_deme/constant/app_color.dart';
import 'package:pdi_deme/routes/app_routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulate a delay for loading resources
    Future.delayed(const Duration(seconds: 3), () {
      // Navigate to the next screen after the delay
      Get.offAllNamed(
        AppRoutes.login,
      ); // Replace '/home' with your actual home route
    });
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.primary, elevation: 0),
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 175,
                decoration: BoxDecoration(),
                child: Image.asset('assets/img/phone.png', fit: BoxFit.cover),
              ),
            ),
            Column(
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Pdi ',
                    style: TextStyle(
                      fontSize: 35,

                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Deme',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: AppColors.secondary,
                      strokeWidth: 5,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                // Container(
                //   child: Lottie.asset(
                //     'assets/animations/loader.json',
                //     height: 130,
                //     width: 150,
                //     fit: BoxFit.fill,
                //     repeat: true,
                //     animate: true,
                //   ),
                // ),
              ],
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: 125,
                decoration: BoxDecoration(),
                child: Image.asset('assets/img/panier.png', fit: BoxFit.cover),
              ),
            ),

            Text(
              'Copyright ©  Tech Pôle Expertise 2025. All Rights Reserved',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
