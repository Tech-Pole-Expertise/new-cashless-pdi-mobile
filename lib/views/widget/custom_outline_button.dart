import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color borderColor;
  final Color? labelColor;
  final Color? backgroundColor;
  final bool isLoading;
  final Widget? loadingIndicator;

  const CustomOutlinedButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.borderColor,
    this.labelColor,
    this.backgroundColor,
    this.isLoading = false,
    this.loadingIndicator,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveLabelColor = labelColor ?? borderColor;

    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: borderColor, width: 1.5.w),
        foregroundColor: effectiveLabelColor,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1000.r),
        ),
        minimumSize: Size(double.infinity, 45.h),
        padding: EdgeInsets.zero, // Aligné avec ElevatedButton
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
              : Text(
                label,
                style: TextStyle(fontSize: 16.sp, color: effectiveLabelColor),
              ),
    );
  }
}
