import 'package:design_system/src/components/foundations/theme/ds_color.dart';
import 'package:design_system/src/components/foundations/theme/ds_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

final class DSTheme {
  // Singleton instance
  static const _appBarTheme = AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );
  late final _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: DSColor.primaryLight,
    onPrimary: DSColor.white,
    primaryContainer: DSColor.primary,
    onPrimaryContainer: DSColor.white,
    secondary: DSColor.warning,
    onSecondary: DSColor.charcoal,
    secondaryContainer: DSColor.warning.withValues(alpha: 0.2),
    onSecondaryContainer: DSColor.white,
    tertiary: DSColor.success,
    onTertiary: DSColor.white,
    tertiaryContainer: DSColor.success.withValues(alpha: 0.2),
    onTertiaryContainer: DSColor.white,
    error: DSColor.error,
    onError: DSColor.white,
    errorContainer: DSColor.error.withValues(alpha: 0.2),
    onErrorContainer: DSColor.white,
    surface: DSColor.charcoal,
    onSurface: DSColor.white,
    surfaceDim: DSColor.charcoalLight,
    surfaceBright: DSColor.charcoal.withValues(alpha: 0.8),
    surfaceContainerLowest: DSColor.charcoal,
    surfaceContainerLow: DSColor.charcoalLight,
    surfaceContainer: DSColor.charcoalLight.withValues(alpha: 0.8),
    surfaceContainerHigh: DSColor.charcoalLight.withValues(alpha: 0.9),
    surfaceContainerHighest: DSColor.charcoalLight,
    onSurfaceVariant: DSColor.slateGray,
    outline: DSColor.mist.withValues(alpha: 0.3),
    outlineVariant: DSColor.mist.withValues(alpha: 0.1),
    shadow: Colors.black,
    scrim: Colors.black.withValues(alpha: 0.5),
    inverseSurface: DSColor.white,
    onInverseSurface: DSColor.charcoal,
    inversePrimary: DSColor.mist,
    surfaceTint: DSColor.primaryLight,
  );

  // Constructor
  DSTheme._();

  // Public Properties
  late final _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: DSColor.primary,
    onPrimary: DSColor.white,
    primaryContainer: DSColor.primaryLight,
    onPrimaryContainer: DSColor.white,
    secondary: DSColor.warning,
    onSecondary: DSColor.charcoal,
    secondaryContainer: DSColor.warning.withValues(alpha: 0.2),
    onSecondaryContainer: DSColor.charcoal,
    tertiary: DSColor.success,
    onTertiary: DSColor.white,
    tertiaryContainer: DSColor.success.withValues(alpha: 0.2),
    onTertiaryContainer: DSColor.charcoal,
    error: DSColor.error,
    onError: DSColor.white,
    errorContainer: DSColor.error.withValues(alpha: 0.15),
    onErrorContainer: DSColor.charcoal,
    surface: DSColor.white,
    onSurface: DSColor.charcoal,
    surfaceDim: DSColor.mist,
    surfaceBright: DSColor.white,
    surfaceContainerLowest: DSColor.white,
    surfaceContainerLow: DSColor.cloud,
    surfaceContainer: DSColor.cloud,
    surfaceContainerHigh: DSColor.mist.withValues(alpha: 0.6),
    surfaceContainerHighest: DSColor.mist,
    onSurfaceVariant: DSColor.slateGray,
    outline: DSColor.slateGray.withValues(alpha: 0.5),
    outlineVariant: DSColor.mist,
    shadow: Colors.black,
    scrim: Colors.black.withValues(alpha: 0.4),
    inverseSurface: DSColor.charcoal,
    onInverseSurface: DSColor.white,
    inversePrimary: DSColor.primaryLight,
    surfaceTint: DSColor.primary,
  );
  late final ThemeData darkTheme = _darkTheme();
  static final DSTheme instance = DSTheme._();

  TextTheme _textThemeDark(Color onColor) {
    return _buildTextTheme(
      onColor,
      bodyLargeAlpha: 0.90,
      bodyMediumAlpha: 0.80,
      bodySmallAlpha: 0.75,
    );
  }

  TextTheme _textThemeLight(Color onColor) {
    return _buildTextTheme(
      onColor,
      bodyLargeAlpha: 0.92,
      bodyMediumAlpha: 0.84,
      bodySmallAlpha: 0.78,
    );
  }

  TextTheme _buildTextTheme(
    Color onColor, {
    required double bodyLargeAlpha,
    required double bodyMediumAlpha,
    required double bodySmallAlpha,
  }) {
    return GoogleFonts.getTextTheme(DSFont.family).copyWith(
      // Big splashy titles (marketing, onboarding)
      displayLarge: GoogleFonts.getFont(
        DSFont.family,
        fontSize: 44,
        fontWeight: FontWeight.w700,
        color: onColor,
      ),
      displayMedium: GoogleFonts.getFont(
        DSFont.family,
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: onColor,
      ),
      displaySmall: GoogleFonts.getFont(
        DSFont.family,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: onColor,
      ),

      // Section headers (screens, cards)
      headlineLarge: GoogleFonts.getFont(
        DSFont.family,
        fontSize: 28,
        height: 1.2,
        fontWeight: FontWeight.w700,
        color: onColor,
      ),
      headlineMedium: GoogleFonts.getFont(
        DSFont.family,
        fontSize: 20,
        height: 1.3,
        fontWeight: FontWeight.w600,
        color: onColor,
      ),
      headlineSmall: GoogleFonts.getFont(
        DSFont.family,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: onColor,
      ),

      // Titles (app bars, dialogs, cards, buttons)
      titleLarge: GoogleFonts.getFont(
        DSFont.family,
        fontSize: 18,
        height: 1.3,
        fontWeight: FontWeight.w600,
        color: onColor,
      ),
      titleMedium: GoogleFonts.getFont(
        DSFont.family,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: onColor,
      ),
      titleSmall: GoogleFonts.getFont(
        DSFont.family,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: onColor,
      ),

      // Body text (paragraphs, descriptions)
      bodyLarge: GoogleFonts.getFont(
        DSFont.family,
        fontSize: 16,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: onColor.withValues(alpha: bodyLargeAlpha),
      ),
      bodyMedium: GoogleFonts.getFont(
        DSFont.family,
        fontSize: 14,
        height: 1.45,
        fontWeight: FontWeight.w400,
        color: onColor.withValues(alpha: bodyMediumAlpha),
      ),
      bodySmall: GoogleFonts.getFont(
        DSFont.family,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: onColor.withValues(alpha: bodySmallAlpha),
      ),

      // Labels (buttons, chips, nav items, overlines)
      labelLarge: GoogleFonts.getFont(
        DSFont.family,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: onColor,
      ),
      labelMedium: GoogleFonts.getFont(
        DSFont.family,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: onColor,
      ),
      labelSmall: GoogleFonts.getFont(
        DSFont.family,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
        color: onColor,
      ),
    );
  }

  late final ThemeData lightTheme = _lightTheme();

  ThemeData _darkTheme() {
    return ThemeData.dark().copyWith(
      appBarTheme: _appBarTheme,
      colorScheme: _darkColorScheme,
      textTheme: _textThemeDark(_darkColorScheme.onSurface),
      // Material defaults the caret to `primary`; a dark brand colour barely
      // contrasts with a charcoal surface, so the caret all but disappears. The
      // selection wash keeps the brand tint — it sits behind text rather than
      // being read as text.
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: _darkColorScheme.onSurface,
        selectionColor: _darkColorScheme.primary.withValues(alpha: 0.5),
        selectionHandleColor: _darkColorScheme.onSurface,
      ),
    );
  }

  ThemeData _lightTheme() {
    return ThemeData.light().copyWith(
      appBarTheme: _appBarTheme,
      colorScheme: _lightColorScheme,
      textTheme: _textThemeLight(_lightColorScheme.onSurface),
    );
  }
}
