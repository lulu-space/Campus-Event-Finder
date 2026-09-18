import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Display: Changa (bold, Latin + Arabic).
/// UI/body: Readex Pro (readable, Latin + Arabic).
class AppTypography {
  AppTypography._();

  static TextStyle display(
    ColorScheme scheme, {
    double size = 34,
    FontWeight weight = FontWeight.w800,
    Color? color,
    double letterSpacing = -1.0,
    double height = 1.08,
  }) {
    return GoogleFonts.changa(
      fontSize: size,
      fontWeight: weight,
      letterSpacing: letterSpacing,
      height: height,
      color: color ?? scheme.onSurface,
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
      displaySmall: display(scheme, size: 40, letterSpacing: -1.4),
      headlineMedium: display(scheme, size: 34, letterSpacing: -1.2),
      headlineSmall: display(scheme, size: 28, letterSpacing: -0.9),
      titleLarge: display(scheme, size: 22, weight: FontWeight.w700, letterSpacing: -0.5),
      titleMedium: display(scheme, size: 17, weight: FontWeight.w700, letterSpacing: -0.2, height: 1.2),
      titleSmall: body(
        scheme,
        size: 12,
        weight: FontWeight.w700,
        color: scheme.primary,
        letterSpacing: 1.8,
        height: 1.2,
      ),
      bodyLarge: body(scheme, size: 16, weight: FontWeight.w500),
      bodyMedium: body(scheme, size: 14.5, color: scheme.onSurface),
      bodySmall: body(
        scheme,
        size: 12.5,
        weight: FontWeight.w500,
        color: scheme.onSurfaceVariant,
        height: 1.35,
      ),
      labelLarge: body(scheme, size: 14, weight: FontWeight.w700, letterSpacing: 0.2),
      labelMedium: body(scheme, size: 12, weight: FontWeight.w600),
      labelSmall: body(
        scheme,
        size: 11,
        weight: FontWeight.w700,
        color: scheme.primary,
        letterSpacing: 1.4,
      ),
    );
  }
}
