import 'package:flutter/material.dart';

class AppGradientOverlay extends StatelessWidget {
  final List<double>? stops;
  final List<Color>? colors;
  final BorderRadiusGeometry? borderRadius;

  const AppGradientOverlay({
    super.key,
    this.stops,
    this.colors,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius:
            borderRadius, // لدعم الحواف الدائرية إذا استخدمته منفرداً
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          // القيم الافتراضية كما في التصميم
          stops: stops ?? const [0.4, 1.0],
          colors:
              colors ??
              [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.8), // التحديث الجديد
              ],
        ),
      ),
    );
  }
}
