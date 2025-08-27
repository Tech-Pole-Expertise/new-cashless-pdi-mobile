import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pv_deme/constant/app_color.dart';

class CreatedElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final String imagePath;
  const CreatedElevatedButton({
    super.key,
    this.onPressed,
    required this.text,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 160.w,
        height: 45.h,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(1000.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 24.w,
              height: 24.h,
              color: Colors.yellow,
            ),
            SizedBox(width: 8.w),
            Text(
              text,
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
