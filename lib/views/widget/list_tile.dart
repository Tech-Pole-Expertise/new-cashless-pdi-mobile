import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:pv_deme/constant/app_color.dart';

class CustomLisTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget leadingIcon;
  final VoidCallback? onTap;
  const CustomLisTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.leadingIcon, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        elevation: 2,
        shadowColor: Colors.grey.withAlpha((0.08 * 255).toInt()),
        child: ListTile(
          leading: leadingIcon,
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}
