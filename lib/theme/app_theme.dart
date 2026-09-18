import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const _radius = 18.0;

  static ThemeData light() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF5B4BDB),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFE8E0FF),
      onPrimaryContainer: Color(0xFF24155A),
      secondary: Color(0xFF0F766E),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFCCFBF1),
      onSecondaryContainer: Color(0xFF042F2E),
      tertiary: Color(0xFFC2410C),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFFFEDD5),
      onTertiaryContainer: Color(0xFF431407),
      error: Color(0xFFB42318),
      onError: Color(0xFFFFFFFF),
      surface: Color(0xFFF6F3FF),
      onSurface: Color(0xFF1A1528),
      onSurfaceVariant: Color(0xFF5B5670),
      outline: Color(0xFFC9C0E0),
      outlineVariant: Color(0xFFE6E0F5),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFFBF8FF),
      surfaceContainer: Color(0xFFF3EEFF),
      surfaceContainerHigh: Color(0xFFECE6FF),
      surfaceContainerHighest: Color(0xFFE4DCF8),
      inverseSurface: Color(0xFF1A1528),
      onInverseSurface: Color(0xFFF6F3FF),
      inversePrimary: Color(0xFFC4B5FD),
      shadow: Color(0xFF5B4BDB),
    );
    return _build(scheme, const Color(0xFFF6F3FF));
  }

  static ThemeData dark() {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFC4B5FD),
      onPrimary: Color(0xFF1E1145),
      primaryContainer: Color(0xFF3D2E7C),
      onPrimaryContainer: Color(0xFFEDE9FE),
      secondary: Color(0xFF5EEAD4),
      onSecondary: Color(0xFF042F2E),
      secondaryContainer: Color(0xFF134E4A),
      onSecondaryContainer: Color(0xFFCCFBF1),
      tertiary: Color(0xFFFFB38A),
      onTertiary: Color(0xFF3B1A0B),
      tertiaryContainer: Color(0xFF7C2D12),
      onTertiaryContainer: Color(0xFFFFEDD5),
      error: Color(0xFFFF8A9B),
      onError: Color(0xFF3F0410),
      surface: Color(0xFF12121C),
      onSurface: Color(0xFFF5F3FF),
      onSurfaceVariant: Color(0xFFB4B0C7),
      outline: Color(0xFF4B4763),
      outlineVariant: Color(0xFF2E2A40),
      surfaceContainerLowest: Color(0xFF0B0B14),
      surfaceContainerLow: Color(0xFF151520),
      surfaceContainer: Color(0xFF1A1A28),
      surfaceContainerHigh: Color(0xFF1E1E2E),
      surfaceContainerHighest: Color(0xFF26263A),
      inverseSurface: Color(0xFFEDE9FE),
      onInverseSurface: Color(0xFF1A1528),
      inversePrimary: Color(0xFF5B4BDB),
      shadow: Color(0xFF000000),
    );
    return _build(scheme, const Color(0xFF0B0B14));
  }

  static ThemeData _build(ColorScheme scheme, Color scaffold) {
    final isDark = scheme.brightness == Brightness.dark;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_radius),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: Colors.transparent,
      canvasColor: scaffold,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
        ),
      ),
      cardTheme: CardThemeData(
        color: isDark
            ? scheme.surfaceContainerHigh.withValues(alpha: 0.88)
            : scheme.surfaceContainerLowest.withValues(alpha: 0.92),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        shadowColor: scheme.primary.withValues(alpha: 0.18),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark
            ? const Color(0xCC0F0F1A)
            : const Color(0xF2FFFFFF),
        elevation: 0,
        height: 72,
        indicatorColor: scheme.primary.withValues(alpha: isDark ? 0.22 : 0.16),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
          );
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHighest,
        selectedColor: scheme.primary,
        disabledColor: scheme.surfaceContainer,
        labelStyle: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        secondaryLabelStyle: TextStyle(
          color: scheme.onPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        shape: StadiumBorder(
          side: BorderSide(color: scheme.outlineVariant),
        ),
        side: BorderSide.none,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? scheme.surfaceContainerHigh.withValues(alpha: 0.9)
            : scheme.surfaceContainerLowest,
        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: scheme.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: scheme.error),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: const StadiumBorder(),
          side: BorderSide(color: scheme.outline),
          foregroundColor: scheme.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        space: 1,
      ),
      textTheme: _textTheme(scheme),
    );
  }

  static TextTheme _textTheme(ColorScheme scheme) {
    final base = scheme.brightness == Brightness.dark
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme;
    return base.copyWith(
      headlineSmall: base.headlineSmall?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.6,
        color: scheme.onSurface,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        color: scheme.onSurface,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: scheme.onSurface,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
        color: scheme.onSurfaceVariant,
      ),
      bodyLarge: base.bodyLarge?.copyWith(color: scheme.onSurface),
      bodyMedium: base.bodyMedium?.copyWith(color: scheme.onSurface),
      bodySmall: base.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
    );
  }
}
