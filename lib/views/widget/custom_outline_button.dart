import 'package:flutter/material.dart';

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
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: borderColor, width: 1.5),
        foregroundColor: labelColor ?? borderColor,
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        minimumSize: const Size(double.infinity, 0),
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
                style: TextStyle(
                  
                  color: labelColor ?? borderColor,
                ),
              ),
    );
  }
}
