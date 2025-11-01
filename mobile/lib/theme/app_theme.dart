import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// SureSend App Theme - Based on Figma Design System
/// Primary Font: Lexend Deca
/// Primary Color: #043b69 (Dark Blue)
/// Design System Version: 1.0
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // ============================================
  // SPACING CONSTANTS (Based on 4px base unit)
  // ============================================
  static const double spacing2 = 2.0;
  static const double spacing4 = 4.0;
  static const double spacing6 = 6.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing48 = 48.0;

  // Aliases for backwards compatibility
  static const double spacingXs = spacing4;
  static const double spacingS = spacing8;
  static const double spacingM = spacing16;
  static const double spacingL = spacing24;
  static const double spacingXl = spacing32;

  // ============================================
  // BORDER RADIUS CONSTANTS (All 0px - fully square per requirements)
  // ============================================
  static const double radiusBase = 0.0; // No rounded corners
  static const double radiusXs = 0.0;
  static const double radiusSm = 0.0;
  static const double radiusMd = 0.0;
  static const double radiusLg = 0.0;
  static const double radiusXl = 0.0;
  static const double radius2xl = 0.0;
  static const double radiusFull = 0.0; // Even circular elements are square

  // Border radius for specific components (all 0px - fully square)
  static const double cardBorderRadius = 0.0;
  static const double buttonBorderRadius = 0.0;
  static const double inputBorderRadius = 0.0;
  static const double badgeBorderRadius = 0.0;

  // ============================================
  // ELEVATION/SHADOW CONSTANTS
  // ============================================
  static const double elevationNone = 0.0;
  static const double elevationSm = 1.0;
  static const double elevationMd = 2.0;
  static const double elevationLg = 4.0;
  static const double elevationXl = 8.0;

  // ============================================
  // TEXT THEME (Lexend Deca)
  // ============================================
  static TextTheme _buildTextTheme(Color textColor, Color secondaryColor) {
    return GoogleFonts.lexendDecaTextTheme(
      TextTheme(
        // Display styles (large headings)
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: textColor,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: textColor,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: textColor,
        ),

        // Headline styles (screen titles)
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: textColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: textColor,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: textColor,
        ),

        // Title styles (section headers)
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: textColor,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: textColor,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: textColor,
        ),

        // Body styles (regular text)
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: textColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: textColor,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: secondaryColor,
        ),

        // Label styles (form labels, buttons)
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: textColor,
        ),
        labelMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: textColor,
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: secondaryColor,
        ),
      ),
    );
  }

  // ============================================
  // LIGHT THEME
  // ============================================
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Color scheme
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.primaryForeground,
      primaryContainer: AppColors.accentBackground,
      onPrimaryContainer: AppColors.accentForeground,
      secondary: AppColors.secondary,
      onSecondary: AppColors.secondaryForeground,
      error: AppColors.error,
      onError: AppColors.primaryForeground,
      errorContainer: AppColors.errorLight,
      onErrorContainer: AppColors.errorDark,
      surface: AppColors.card,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.background,
      outline: AppColors.border,
      outlineVariant: AppColors.border,
      shadow: Colors.black12,
      scrim: AppColors.overlay,
    ),

    // Scaffold
    scaffoldBackgroundColor: AppColors.background,

    // App bar
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.primaryForeground,
      elevation: elevationNone,
      centerTitle: true,
      titleTextStyle: GoogleFonts.lexendDeca(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppColors.primaryForeground,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.primaryForeground,
        size: 24,
      ),
    ),

    // Card
    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: elevationSm,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardBorderRadius),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: spacing16,
        vertical: spacing8,
      ),
    ),

    // Elevated button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.primaryForeground,
        elevation: elevationMd,
        shadowColor: Colors.black.withValues(alpha: 0.2),
        padding: const EdgeInsets.symmetric(
          horizontal: spacing16,
          vertical: spacing12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonBorderRadius),
        ),
        textStyle: GoogleFonts.lexendDeca(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        minimumSize: const Size(88, 36),
      ),
    ),

    // Outlined button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        padding: const EdgeInsets.symmetric(
          horizontal: spacing16,
          vertical: spacing12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonBorderRadius),
        ),
        textStyle: GoogleFonts.lexendDeca(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        minimumSize: const Size(88, 36),
      ),
    ),

    // Text button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: spacing16,
          vertical: spacing12,
        ),
        textStyle: GoogleFonts.lexendDeca(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        minimumSize: const Size(88, 36),
      ),
    ),

    // Input decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBackground,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacing16,
        vertical: spacing12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderRadius),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderRadius),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderRadius),
        borderSide: const BorderSide(color: AppColors.ring, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderRadius),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderRadius),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderRadius),
        borderSide: BorderSide(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      hintStyle: const TextStyle(
        color: AppColors.textMuted,
        fontWeight: FontWeight.w400,
      ),
      labelStyle: const TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      errorStyle: const TextStyle(
        color: AppColors.error,
        fontSize: 12,
      ),
    ),

    // Floating action button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.primaryForeground,
      elevation: elevationLg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusFull),
      ),
    ),

    // Bottom navigation bar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.card,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textMuted,
      selectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: elevationMd,
    ),

    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.background,
      deleteIconColor: AppColors.textSecondary,
      disabledColor: AppColors.background.withValues(alpha: 0.5),
      labelStyle: GoogleFonts.lexendDeca(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: spacing12,
        vertical: spacing8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(badgeBorderRadius),
        side: const BorderSide(color: AppColors.border),
      ),
    ),

    // Dialog
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.card,
      elevation: elevationXl,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLg),
      ),
      titleTextStyle: GoogleFonts.lexendDeca(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      contentTextStyle: GoogleFonts.lexendDeca(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
    ),

    // Bottom sheet
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.card,
      elevation: elevationXl,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(radiusXl),
        ),
      ),
    ),

    // Snackbar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.secondary,
      contentTextStyle: GoogleFonts.lexendDeca(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.secondaryForeground,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMd),
      ),
      behavior: SnackBarBehavior.floating,
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
      space: 1,
    ),

    // Switch
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryForeground;
        }
        return AppColors.textMuted;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColors.switchBackground;
      }),
    ),

    // Checkbox
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AppColors.primaryForeground),
      side: const BorderSide(color: AppColors.border, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusSm),
      ),
    ),

    // Radio
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColors.textMuted;
      }),
    ),

    // Progress indicator
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.background,
      circularTrackColor: AppColors.background,
    ),

    // Text theme
    textTheme: _buildTextTheme(AppColors.textPrimary, AppColors.textSecondary),

    // Icon theme
    iconTheme: const IconThemeData(
      color: AppColors.textPrimary,
      size: 24,
    ),
  );

  // ============================================
  // DARK THEME
  // ============================================
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Color scheme
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.primaryForeground,
      primaryContainer: AppColors.accentBackground,
      onPrimaryContainer: AppColors.accentForeground,
      secondary: AppColors.secondary,
      onSecondary: AppColors.secondaryForeground,
      error: AppColors.error,
      onError: AppColors.primaryForeground,
      errorContainer: AppColors.errorDark,
      onErrorContainer: AppColors.errorLight,
      surface: AppColors.darkCard,
      onSurface: AppColors.darkTextPrimary,
      surfaceContainerHighest: AppColors.darkBackground,
      outline: AppColors.darkBorder,
      outlineVariant: AppColors.darkBorder,
      shadow: Colors.black26,
      scrim: AppColors.overlay,
    ),

    // Scaffold
    scaffoldBackgroundColor: AppColors.darkBackground,

    // App bar
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.darkTextPrimary,
      elevation: elevationNone,
      centerTitle: true,
      titleTextStyle: GoogleFonts.lexendDeca(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppColors.darkTextPrimary,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.darkTextPrimary,
        size: 24,
      ),
    ),

    // Card
    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      elevation: elevationSm,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardBorderRadius),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: spacing16,
        vertical: spacing8,
      ),
    ),

    // Text theme
    textTheme:
        _buildTextTheme(AppColors.darkTextPrimary, AppColors.darkTextSecondary),

    // Icon theme
    iconTheme: const IconThemeData(
      color: AppColors.darkTextPrimary,
      size: 24,
    ),

    // (Rest of dark theme configuration follows light theme pattern)
    // Input, buttons, etc. inherit from light theme with dark color adjustments
  );

  // ============================================
  // BACKWARDS COMPATIBILITY GETTERS
  // For legacy code that references AppTheme.colorName
  // ============================================

  /// @deprecated Use AppColors.primary instead
  static Color get primaryColor => AppColors.primary;

  /// @deprecated Use AppColors.secondary instead
  static Color get secondaryColor => AppColors.secondary;

  /// @deprecated Use AppColors.accentBackground instead
  static Color get accentColor => AppColors.accentBackground;

  /// @deprecated Use AppColors.error instead
  static Color get errorColor => AppColors.error;

  /// @deprecated Use AppColors.success instead
  static Color get successColor => AppColors.success;

  /// @deprecated Use AppColors.warning instead
  static Color get warningColor => AppColors.warning;

  /// @deprecated Use AppColors.card instead
  static Color get surfaceColor => AppColors.card;

  /// @deprecated Use AppColors.textPrimary instead
  static Color get textPrimaryColor => AppColors.textPrimary;

  /// @deprecated Use AppColors.textSecondary instead
  static Color get textSecondaryColor => AppColors.textSecondary;

  /// @deprecated Use AppColors.primaryDark instead
  static Color get darkBlue => AppColors.primaryDark;

  /// Convenience getters for commonly used colors
  static const Color primary = AppColors.primary;
  static const Color textPrimary = AppColors.textPrimary;

  /// Helper method for backwards compatibility with withOpacity
  /// @deprecated Use color.withValues(alpha: opacity) instead
  static Color withAlpha(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  // ============================================
  // THEME HELPERS
  // ============================================

  /// Get the current theme mode colors
  static ColorScheme colorScheme(BuildContext context) {
    return Theme.of(context).colorScheme;
  }

  /// Check if current theme is dark mode
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
