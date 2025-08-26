import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pv_deme/api/models/merchant_stat_model.dart';

class UserAccountDataWidget extends StatelessWidget {
  final MerchantStatModel? merchantStat;
  const UserAccountDataWidget({super.key, required this.merchantStat});

  @override
  Widget build(BuildContext context) {
      String toCapitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
    return Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/img/profil.png', // Chemin de l'image de l'utilisateur
                fit: BoxFit.contain,
                width: 55.w,
                height: 55.h,
              ),
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  children: [
                    TextSpan(
                      text:
                          merchantStat != null
                              ? '${toCapitalize(merchantStat!.lastname)} ${merchantStat!.firstname.toUpperCase()}\n'
                              : 'Données indisponible\n',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: merchantStat?.phone ?? 'Téléphone indisponible',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
  }
}