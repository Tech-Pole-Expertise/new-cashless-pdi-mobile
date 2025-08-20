import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pv_deme/api/controllers/network_controller.dart';

class CustomElevatedButonWithIcons extends StatelessWidget {
  final Color backgroundColor;
  final String label;
  final Color? labelColor;
  final Color? iconColor;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? loadingIndicator;

  const CustomElevatedButonWithIcons({
    super.key,
    required this.backgroundColor,
    required this.label,
    this.labelColor,
    this.iconColor,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.loadingIndicator,
  });

  @override
  Widget build(BuildContext context) {
    final networkController = Get.find<NetworkController>();

    return Obx(() {

      return ElevatedButton.icon(
       onPressed: (isLoading || !networkController.isConnected.value) ? null : onPressed,
        icon: isLoading
            ? SizedBox(
                width: 18.w,
                height: 18.h,
                child: loadingIndicator ??
                    CircularProgressIndicator(
                      strokeWidth: 2.w,
                      color: labelColor ?? Colors.white,
                    ),
              )
            : Icon(icon, color: iconColor ?? Colors.white, size: 20.sp),
        label: Text(
          isLoading ? "Chargement..." : label,
          style: TextStyle(
            color: labelColor ?? Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: backgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1000.r),
          ),
          elevation: 0,
        ),
      );
    });
  }
}
