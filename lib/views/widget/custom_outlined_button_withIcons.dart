import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pv_deme/api/controllers/network_controller.dart';
import 'package:pv_deme/constant/app_color.dart';

class CustomOutlinedButtonWithIcons extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color borderColor;
  final Color? labelColor;
  final Color? backgroundColor;
  final bool isLoading;
  final Widget? loadingIndicator;
  final IconData? icon;

  const CustomOutlinedButtonWithIcons({
    super.key,
    required this.label,
    required this.onPressed,
    required this.borderColor,
    this.labelColor,
    this.backgroundColor,
    this.isLoading = false,
    this.loadingIndicator,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final networkController = Get.find<NetworkController>();
    final Color effectiveLabelColor = labelColor ?? borderColor;

    return Obx(() {
      final bool isEnabled = !isLoading && networkController.isConnected.value;

      return OutlinedButton(
        onPressed: isEnabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor, width: 1.5.w),
          foregroundColor: effectiveLabelColor,
          backgroundColor: isEnabled ? backgroundColor : AppColors.primaryLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1000.r),
          ),
          minimumSize: Size(double.infinity, 45.h),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
        ),
        child:
            isLoading
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child:
                          loadingIndicator ??
                          CircularProgressIndicator(
                            strokeWidth: 2.w,
                            color: effectiveLabelColor,
                          ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      "Chargement...",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: effectiveLabelColor,
                      ),
                    ),
                  ],
                )
                : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 20.sp, color: effectiveLabelColor),
                      SizedBox(width: 8.w),
                    ],
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: effectiveLabelColor,
                      ),
                    ),
                  ],
                ),
      );
    });
  }
}
