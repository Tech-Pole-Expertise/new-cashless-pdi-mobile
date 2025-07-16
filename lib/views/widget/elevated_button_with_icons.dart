import 'package:flutter/material.dart';

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
    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon:
          isLoading
              ? SizedBox(
                width: 18,
                height: 18,
                child:
                    loadingIndicator ??
                    const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
              )
              : Icon(icon, color: iconColor?? Colors.white),
      label: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          isLoading ? "Chargement..." : label,
          style: TextStyle(color: labelColor ?? Colors.white),
        ),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // 👈 Arrondi ici
        ),
        elevation: 0,
      ),
    );
  }
}
