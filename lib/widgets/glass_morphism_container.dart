import 'package:flutter/material.dart';


class GlassMorphismContainer extends StatelessWidget {
  final double height;
  final double width;
  final double blur;
  final double opacity;
  final Color color;
  final BorderRadius borderRadius;
  final Widget child;

  const GlassMorphismContainer({
    required this.height,
    required this.width,
    required this.blur,
    required this.opacity,
    required this.color,
    required this.borderRadius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: color.withOpacity(opacity),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(opacity / 2),
            blurRadius: blur,
            spreadRadius: blur,
          ),
        ],
      ),
      child: child,
    );
  }
}