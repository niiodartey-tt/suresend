import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_colors.dart';

/// App theme based on exact specifications from claude_code_prompt.md
class AppTheme {
  // Private constructor
  AppTheme._();

  // ============================================
  // TYPOGRAPHY - From claude_code_prompt.md
  // ============================================
  // Font Family: Inter, SF Pro Display, or Roboto
  // Font Sizes:
  //   - Large headings: 24px-28px
  //   - Page titles: 20px-22px
  //   - Section headers: 16px-18px
  //   - Body text: 14px-15px
  //   - Small text: 12px-13px
  //   - Tiny text: 10px-11px

  static const double fontSizeLargeHeading = 26.0;  // 24-28px
  static const double fontSizePageTitle = 21.0;      // 20-22px
  static const double fontSizeSectionHeader = 17.0;  // 16-18px
  static const double fontSizeBody = 14.5;           // 14-15px
  static const double fontSizeSmall = 12.5;          // 12-13px
  static const double fontSizeTiny = 10.5;           // 10-11px

  // Font Weights
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemibold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;

  // ============================================
  // SPACING & LAYOUT - From claude_code_prompt.md
  // ============================================

  // Screen padding: 16px-20px horizontal
  static const double screenPaddingHorizontal = 18.0;

  // Card padding: 16px-20px all sides
  static const double cardPadding = 18.0;

  // Section spacing: 20px-24px between sections
  static const double sectionSpacing = 22.0;

  // Element spacing: 12px-16px between related elements
  static const double elementSpacing = 14.0;

  // General spacing values
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing48 = 48.0;

  // ============================================
  // BORDER RADIUS - From claude_code_prompt.md
  // ============================================

  // Small elements (buttons, badges): 6px-8px
  static const double radiusSmall = 7.0;

  // Cards: 12px-16px
  static const double radiusCard = 14.0;

  // Modals: 16px-20px
  static const double radiusModal = 18.0;

  // ============================================
  // BUTTON HEIGHTS & SIZES
  // ============================================

  // Button height: 48px (from spec)
  static const double buttonHeight = 48.0;

  // Icon sizes: 20px-24px for regular, 16px-18px for small
  static const double iconSizeRegular = 22.0;
  static const double iconSizeSmall = 17.0;

  // ============================================
  // LIGHT THEME
  // ============================================

  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.interTextTheme().copyWith(
      // Large headings (24-28px, Bold)
      displayLarge: GoogleFonts.inter(
        fontSize: fontSizeLargeHeading,
        fontWeight: fontWeightBold,
        color: AppColors.textPrimary,
      ),

      // Page titles (20-22px, Semibold)
      headlineMedium: GoogleFonts.inter(
        fontSize: fontSizePageTitle,
        fontWeight: fontWeightSemibold,
        color: AppColors.textPrimary,
      ),

      // Section headers (16-18px, Semibold)
      titleLarge: GoogleFonts.inter(
        fontSize: fontSizeSectionHeader,
        fontWeight: fontWeightSemibold,
        color: AppColors.textPrimary,
      ),

      // Body text (14-15px, Regular)
      bodyLarge: GoogleFonts.inter(
        fontSize: fontSizeBody,
        fontWeight: fontWeightRegular,
        color: AppColors.textPrimary,
      ),

      // Body text medium
      bodyMedium: GoogleFonts.inter(
        fontSize: fontSizeBody,
        fontWeight: fontWeightRegular,
        color: AppColors.textPrimary,
      ),

      // Small text (12-13px, Regular)
      bodySmall: GoogleFonts.inter(
        fontSize: fontSizeSmall,
        fontWeight: fontWeightRegular,
        color: AppColors.textSecondary,
      ),

      // Labels (14-15px, Medium)
      labelLarge: GoogleFonts.inter(
        fontSize: fontSizeBody,
        fontWeight: fontWeightMedium,
        color: AppColors.textPrimary,
      ),

      // Small labels (12-13px, Medium)
      labelMedium: GoogleFonts.inter(
        fontSize: fontSizeSmall,
        fontWeight: fontWeightMedium,
        color: AppColors.textSecondary,
      ),

      // Tiny text (10-11px, Regular)
      labelSmall: GoogleFonts.inter(
        fontSize: fontSizeTiny,
        fontWeight: fontWeightRegular,
        color: AppColors.textSecondary,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.inter().fontFamily,

      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.card,
        error: AppColors.error,
        onPrimary: AppColors.primaryForeground,
        onSecondary: AppColors.secondaryForeground,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      ),

      scaffoldBackgroundColor: AppColors.background,
      textTheme: textTheme,

      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: fontSizePageTitle,
          fontWeight: fontWeightSemibold,
          color: Colors.white,
        ),
      ),

      // Card theme
      cardTheme: CardTheme(
        color: AppColors.card,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCard),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: const BorderSide(color: AppColors.mutedBlue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: const BorderSide(color: AppColors.mutedBlue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacing16,
          vertical: spacing12,
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: fontSizeBody,
          fontWeight: fontWeightMedium,
          color: AppColors.textSecondary,
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: fontSizeBody,
          fontWeight: fontWeightRegular,
          color: AppColors.textSecondary,
        ),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSmall),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: fontSizeBody,
            fontWeight: fontWeightSemibold,
          ),
          elevation: 0,
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, buttonHeight),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSmall),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: fontSizeBody,
            fontWeight: fontWeightSemibold,
          ),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: GoogleFonts.inter(
            fontSize: fontSizeBody,
            fontWeight: fontWeightMedium,
          ),
        ),
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.card,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  // ============================================
  // DARK THEME (from dark_mode_eneabled.png spec)
  // ============================================

  static ThemeData get darkTheme {
    final textTheme = GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.inter(
        fontSize: fontSizeLargeHeading,
        fontWeight: fontWeightBold,
        color: AppColors.darkTextPrimary,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: fontSizePageTitle,
        fontWeight: fontWeightSemibold,
        color: AppColors.darkTextPrimary,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: fontSizeSectionHeader,
        fontWeight: fontWeightSemibold,
        color: AppColors.darkTextPrimary,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: fontSizeBody,
        fontWeight: fontWeightRegular,
        color: AppColors.darkTextPrimary,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: fontSizeBody,
        fontWeight: fontWeightRegular,
        color: AppColors.darkTextPrimary,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: fontSizeSmall,
        fontWeight: fontWeightRegular,
        color: AppColors.darkTextSecondary,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: fontSizeBody,
        fontWeight: fontWeightMedium,
        color: AppColors.darkTextPrimary,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: fontSizeSmall,
        fontWeight: fontWeightMedium,
        color: AppColors.darkTextSecondary,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: fontSizeTiny,
        fontWeight: fontWeightRegular,
        color: AppColors.darkTextSecondary,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.inter().fontFamily,
      brightness: Brightness.dark,

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.darkCard,
        error: AppColors.error,
        onPrimary: AppColors.primaryForeground,
        onSecondary: AppColors.secondaryForeground,
        onSurface: AppColors.darkTextPrimary,
        onError: Colors.white,
      ),

      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: textTheme,

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkCard,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: fontSizePageTitle,
          fontWeight: fontWeightSemibold,
          color: AppColors.darkTextPrimary,
        ),
      ),

      cardTheme: CardTheme(
        color: AppColors.darkCard,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCard),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkInput,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacing16,
          vertical: spacing12,
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: fontSizeBody,
          fontWeight: fontWeightMedium,
          color: AppColors.darkTextSecondary,
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: fontSizeBody,
          fontWeight: fontWeightRegular,
          color: AppColors.darkTextSecondary,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSmall),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: fontSizeBody,
            fontWeight: fontWeightSemibold,
          ),
          elevation: 0,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, buttonHeight),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSmall),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: fontSizeBody,
            fontWeight: fontWeightSemibold,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: GoogleFonts.inter(
            fontSize: fontSizeBody,
            fontWeight: fontWeightMedium,
          ),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkCard,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
