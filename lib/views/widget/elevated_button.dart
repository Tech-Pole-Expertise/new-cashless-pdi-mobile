import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color? labelColor;
  final bool isLoading;
  final Widget? loadingIndicator;

  const CustomElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
    this.labelColor,
    this.isLoading = false,
    this.loadingIndicator,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1000), // 👈 Full border radius
        ),
        minimumSize: const Size(double.infinity, 45),
        elevation: 0,
      ),
      child:
          isLoading
              ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child:
                        loadingIndicator ??
                        const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                  ),
                  const SizedBox(width: 10),
                  const Text("Chargement..."),
                ],
              )
              : Text(
                label,
                style: TextStyle(color: labelColor ?? Colors.black),
              ),
    );
  }
}
