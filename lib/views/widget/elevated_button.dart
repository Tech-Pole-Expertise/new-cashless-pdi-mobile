import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pv_deme/api/controllers/network_controller.dart';

class CustomElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color? labelColor;
  final bool isLoading;
  final bool showLoadingIndicator;
  final Widget? loadingIndicator;

  const CustomElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
    this.labelColor,
    this.isLoading = false,
    this.showLoadingIndicator = true,
    this.loadingIndicator,
  });

  @override
  Widget build(BuildContext context) {
    final networkController = Get.find<NetworkController>();

    return Obx(() {
      final bool isEnabled = !isLoading && networkController.isConnected.value;

      return ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1000.r),
          ),
          minimumSize: Size(double.infinity, 45.h),
          elevation: 0,
        ),
        child: isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showLoadingIndicator)
                    SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: loadingIndicator ??
                          const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                    ),
                  SizedBox(width: 10.w),
                  Text(
                    "Chargement...",
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ],
              )
            : Text(
                label,
                style: TextStyle(
                  color: labelColor ?? Colors.black,
                  fontSize: 16.sp,
                ),
              ),
      );
    });
  }
}
