import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const primary = Color(0xFF00C9A7);
  static const secondary = Color(0xFF1E1E2F);
  static const surface = Color(0xFFF9FAFB);
  static const textPrimary = Color(0xFF1E1E1E);
  static const textSecondary = Color(0xFF6B7280);
  
  // Spacing
  static const double spacingXs = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXl = 32.0;
  
  // Border Radius
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 16.0;
  static const double radiusXl = 24.0;

  // Status Colors
  static const success = Color(0xFF43A047);
  static const error = Color(0xFFE53935);
  static const warning = Color(0xFFFB8C00);

  // Helper method to replace withOpacity
  static Color withAlpha(Color color, double opacity) =>
      color.withAlpha((opacity * 255).round());
    
  static ColorScheme get colorScheme => const ColorScheme.light(
    primary: primary,
    secondary: secondary,
    surface: surface,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: textPrimary,
  );

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: GoogleFonts.lexendDecaTextTheme(),
    scaffoldBackgroundColor: surface,
  );
}
