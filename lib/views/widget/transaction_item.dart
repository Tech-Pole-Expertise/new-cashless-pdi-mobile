import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pv_deme/api/models/retrait_history_model.dart';
import 'package:pv_deme/constant/app_color.dart';

class TransactionItemWidget extends StatelessWidget {
  final RetraitHistoryModel retrait;
  final int totalProduits;
   final VoidCallback? onPressed;
  const TransactionItemWidget({super.key, required this.retrait, required this.totalProduits, this.onPressed});

  @override
  Widget build(BuildContext context) {
      String formatPdiNumber(String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      if (i != 0 && i % 3 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryLight,
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: Icon(
                    Icons.shopping_cart,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        retrait.clientName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'N° ${formatPdiNumber(retrait.pdi.identifier)}',
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      // Text(
                      //   'Qté produits : $totalProduits',
                      //   style: TextStyle(fontSize: 12.sp),
                      // ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Date du retrait',
                      style: TextStyle(fontSize: 15.sp, color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      DateFormat('dd/MM/yyyy').format(retrait.date),
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Divider(color: Colors.black12, height: 1.h),
      ],
    );
    
  }
}
