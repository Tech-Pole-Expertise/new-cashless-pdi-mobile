import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatCardWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String total;
  final String subtitle;
  final Color iconColor;
  const StatCardWidget({super.key, required this.icon, required this.title, required this.total, required this.subtitle, this.iconColor = Colors.blue});

  @override
  Widget build(BuildContext context) {
     return Container(
    margin: EdgeInsets.only(bottom: 12.h),
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        // Icône dans un cercle
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: iconColor.withAlpha((255*0.1).toInt()),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 24.sp),
        ),
        SizedBox(width: 16.w),

        // Texte
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  )),
              SizedBox(height: 4.h),
              Text("Total : $total",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
              SizedBox(height: 2.h),
              Text(subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  )),
            ],
          ),
        ),

        // Graphique (image temporaire ici)
        Image.asset(
          'assets/img/stat_graph.png',
          width: 30.w,
          height: 40.h,
        ),
      ],
    ),
  );
  }
}