import 'package:flutter/material.dart';

class CustomElevatedButonWithIcons extends StatelessWidget {
  final Color backgroundColor;
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? loadingIndicator;

  const CustomElevatedButonWithIcons({
    super.key,
    required this.backgroundColor,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.loadingIndicator,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? SizedBox(
              width: 18,
              height: 18,
              child: loadingIndicator ??
                  const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
            )
          : Icon(icon, color: Colors.white),
      label: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(isLoading ? "Chargement..." : label),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }
}
