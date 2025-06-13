
import 'package:flutter/material.dart';

class CustomElevatedButonWithIcons extends StatelessWidget {
  final Color backgroundColor;
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  const CustomElevatedButonWithIcons({super.key, required this.backgroundColor, required this.label, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      label:  Text(label),
      icon:  Icon(icon, color: Colors.white),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }
}
