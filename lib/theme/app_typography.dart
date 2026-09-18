import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Display: Outfit (light geometric sans).
/// Body/UI + Arabic fallback: Readex Pro.
class AppTypography {
  AppTypography._();

  static TextStyle display(
    ColorScheme scheme, {
    double size = 28,
    FontWeight weight = FontWeight.w600,
    Color? color,
    double letterSpacing = -0.3,
    double height = 1.15,
  }) {
    return GoogleFonts.outfit(
      fontSize: size,
      fontWeight: weight,
      letterSpacing: letterSpacing,
      height: height,
      color: color ?? scheme.onSurface,
    ).copyWith(
      fontFamilyFallback: [
        GoogleFonts.readexPro().fontFamily ?? 'Readex Pro',
      ],
    );
  }

  static TextStyle body(
    ColorScheme scheme, {
    double size = 15,
    FontWeight weight = FontWeight.w400,
    Color? color,
    double letterSpacing = 0,
    double height = 1.45,
  }) {
    return GoogleFonts.readexPro(
      fontSize: size,
      fontWeight: weight,
      letterSpacing: letterSpacing,
      height: height,
      color: color ?? scheme.onSurface,
    );
  }

  static TextTheme textTheme(ColorScheme scheme) {
    final base = scheme.brightness == Brightness.dark
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme;
    final bodyTheme = GoogleFonts.readexProTextTheme(base);

    return bodyTheme.copyWith(
      displaySmall: display(scheme, size: 34, letterSpacing: -0.5),
      headlineMedium: display(scheme, size: 28, letterSpacing: -0.35),
      headlineSmall: display(scheme, size: 24, letterSpacing: -0.25),
      titleLarge: display(scheme, size: 20, weight: FontWeight.w600),
      titleMedium: display(
        scheme,
        size: 16,
        weight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.25,
      ),
      titleSmall: body(
        scheme,
        size: 12,
        weight: FontWeight.w600,
        color: scheme.primary,
        letterSpacing: 1.4,
        height: 1.2,
      ),
      bodyLarge: body(scheme, size: 16, weight: FontWeight.w400),
      bodyMedium: body(scheme, size: 14.5, color: scheme.onSurface),
      bodySmall: body(
        scheme,
        size: 12.5,
        weight: FontWeight.w400,
        color: scheme.onSurfaceVariant,
        height: 1.35,
      ),
      labelLarge: body(scheme, size: 14, weight: FontWeight.w600, letterSpacing: 0.1),
      labelMedium: body(scheme, size: 12, weight: FontWeight.w500),
      labelSmall: body(
        scheme,
        size: 11,
        weight: FontWeight.w600,
        color: scheme.primary,
        letterSpacing: 1.2,
      ),
    );
  }
}
