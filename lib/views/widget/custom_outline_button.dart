import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pv_deme/api/controllers/network_controller.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color borderColor;
  final Color? labelColor;
  final Color? backgroundColor;
  final bool isLoading;
  final Widget? loadingIndicator;
  final bool? networkStatus;

  const CustomOutlinedButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.borderColor,
    this.labelColor,
    this.backgroundColor,
    this.isLoading = false,
    this.loadingIndicator,
    this.networkStatus,
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
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1000.r),
        ),
        minimumSize: Size(double.infinity, 45.h),
        padding: EdgeInsets.zero,
      ),
      child: isLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 18.w,
                  height: 18.w,
                  child: loadingIndicator ??
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
          : Text(
              label,
              style: TextStyle(fontSize: 16.sp, color: effectiveLabelColor),
            ),
    );
  });
  }
}
