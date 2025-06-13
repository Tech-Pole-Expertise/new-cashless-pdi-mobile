import 'package:flutter/material.dart';

class CustomCircleProgressBar extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color color;
  final Color backgroundColor;

  const CustomCircleProgressBar({
    super.key,
    this.size = 80.0,
    
     required this.color, required this.backgroundColor, required this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            backgroundColor: backgroundColor,
          ),
        
        ],
      ),
    );
  }
}
