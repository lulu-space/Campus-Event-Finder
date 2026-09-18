import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Soft violet / teal glows behind every screen.
class AuraBackground extends StatelessWidget {
  final Widget child;

  const AuraBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? const [
                      Color(0xFF0B0B14),
                      Color(0xFF14122A),
                      Color(0xFF0C1A1A),
                    ]
                  : const [
                      Color(0xFFF7F3FF),
                      Color(0xFFF3FBFA),
                      Color(0xFFFFF6F0),
                    ],
            ),
          ),
        ),
        Positioned(
          top: -80,
          left: -40,
          child: _Glow(
            size: 280,
            color: isDark
                ? AppColors.violet.withValues(alpha: 0.4)
                : AppColors.violetSoft.withValues(alpha: 0.3),
          ),
        ),
        Positioned(
          right: -60,
          top: 180,
          child: _Glow(
            size: 220,
            color: isDark
                ? AppColors.teal.withValues(alpha: 0.33)
                : AppColors.teal.withValues(alpha: 0.25),
          ),
        ),
        Positioned(
          bottom: -40,
          left: 40,
          child: _Glow(
            size: 200,
            color: isDark
                ? AppColors.sunset.withValues(alpha: 0.27)
                : AppColors.sunset.withValues(alpha: 0.2),
          ),
        ),
        child,
      ],
    );
  }
}

class _Glow extends StatelessWidget {
  final double size;
  final Color color;

  const _Glow({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
