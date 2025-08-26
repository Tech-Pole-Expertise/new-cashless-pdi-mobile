import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pv_deme/constant/app_color.dart';

class CurvedContainer extends StatelessWidget {
  final Widget child;

  const CurvedContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BottomCurveClipper(),
      child: Container(height: 225.h, color: AppColors.primary, child: child),
    );
  }
}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Départ coin haut gauche
    path.lineTo(0, size.height - 30);

    // Cuvette symétrique au centre
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height, // point de contrôle gauche
      size.width * 0.5,
      size.height, // point au milieu
    );

    path.quadraticBezierTo(
      size.width * 0.85,
      size.height, // point de contrôle droit
      size.width,
      size.height - 30, // fin à droite
    );

    // Remonte au coin haut droit
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
