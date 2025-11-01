import 'package:flutter/material.dart';

/// Centralized color management based on Figma design system
/// All colors match the exact hex values from the Figma export
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // ============================================
  // PRIMARY COLORS (Light Mode)
  // ============================================

  /// Primary brand color - #0A2647 (Navy Blue)
  /// Used for: Main CTA buttons, headers, navigation active states
  static const Color primary = Color(0xFF0A2647);

  /// Dark variant of primary - #081d36
  /// Used for: Hover states for primary buttons
  static const Color primaryDark = Color(0xFF081d36);

  /// Primary foreground (text on primary background)
  static const Color primaryForeground = Color(0xFFFFFFFF);

  // ============================================
  // SECONDARY COLORS
  // ============================================

  /// Secondary color - #111111 (Almost Black)
  /// Used for: Secondary buttons, dark text
  static const Color secondary = Color(0xFF111111);

  /// Secondary foreground (text on secondary background)
  static const Color secondaryForeground = Color(0xFFFFFFFF);

  // ============================================
  // SEMANTIC COLORS
  // ============================================

  /// Success color - #00C853 (Green)
  /// Used for: Positive actions, completed transactions
  static const Color success = Color(0xFF00C853);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color successDark = Color(0xFF00A843);

  /// Warning color - #FF9800 (Orange)
  /// Used for: Alerts, pending states
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color warningDark = Color(0xFFE68900);

  /// Error/Destructive color - #E53935 (Red)
  /// Used for: Errors, disputes, negative actions
  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color errorDark = Color(0xFFB91C1C);

  /// Alternative error color - #EF4444
  static const Color errorAlt = Color(0xFFEF4444);

  /// Purple accent - #8B5CF6
  /// Used for: Secondary features, analytics
  static const Color purple = Color(0xFF8B5CF6);
  static const Color purpleLight = Color(0xFFEDE9FE);
  static const Color purpleDark = Color(0xFF7C3AED);

  // ============================================
  // BACKGROUND COLORS
  // ============================================

  /// Main background - #F9FAFB (Light Gray)
  /// Used for: App background, muted surfaces
  static const Color background = Color(0xFFF9FAFB);

  /// Card background - #FFFFFF (White)
  static const Color card = Color(0xFFFFFFFF);

  /// Input background - #F9FAFB
  static const Color inputBackground = Color(0xFFF9FAFB);

  /// Accent background - #E8F0FE (Light Blue)
  /// Used for: Background for accented content
  static const Color accentBackground = Color(0xFFE8F0FE);
  static const Color accentForeground = Color(0xFF0A2647);

  /// Onboarding illustration background - #CED9E5 (Light Gray-Blue)
  /// Used for: Onboarding screen illustration containers
  static const Color onboardingIllustrationBg = Color(0xFFCED9E5);

  // ============================================
  // TEXT COLORS
  // ============================================

  /// Primary text - #1E1E1E (Dark Gray/Black)
  static const Color textPrimary = Color(0xFF1E1E1E);

  /// Secondary/muted text - #6B7280 (Medium Gray)
  static const Color textSecondary = Color(0xFF6B7280);

  /// Muted foreground (same as textSecondary)
  static const Color textMuted = Color(0xFF6B7280);

  // ============================================
  // BORDER & DIVIDER COLORS
  // ============================================

  /// Border color - rgba(0, 0, 0, 0.1)
  static const Color border = Color(0x1A000000);

  /// Ring/focus indicator color (same as primary)
  static const Color ring = Color(0xFF0A2647);

  // ============================================
  // STATUS COLORS FOR TRANSACTIONS
  // ============================================

  /// Completed status
  static const Color statusCompletedBg = Color(0xFFD1FAE5);
  static const Color statusCompletedText = Color(0xFF047857);
  static const Color statusCompletedBorder = Color(0xFFA7F3D0);

  /// In Escrow status
  static const Color statusEscrowBg = Color(0xFFDBEAFE);
  static const Color statusEscrowText = Color(0xFF1D4ED8);
  static const Color statusEscrowBorder = Color(0xFFBFDBFE);

  /// In Progress status
  static const Color statusProgressBg = Color(0xFFFEF3C7);
  static const Color statusProgressText = Color(0xFFB45309);
  static const Color statusProgressBorder = Color(0xFFFDE68A);

  /// Disputed status
  static const Color statusDisputedBg = Color(0xFFFEE2E2);
  static const Color statusDisputedText = Color(0xFFB91C1C);
  static const Color statusDisputedBorder = Color(0xFFFECACA);

  /// Pending status
  static const Color statusPendingBg = Color(0xFFF3F4F6);
  static const Color statusPendingText = Color(0xFF4B5563);
  static const Color statusPendingBorder = Color(0xFFE5E7EB);

  // ============================================
  // CHART/ANALYTICS COLORS
  // ============================================

  static const Color chart1 = Color(0xFF0A2647); // Primary blue
  static const Color chart2 = Color(0xFF00C853); // Green
  static const Color chart3 = Color(0xFFFF9800); // Orange
  static const Color chart4 = Color(0xFFE53935); // Red
  static const Color chart5 = Color(0xFF8B5CF6); // Purple

  // ============================================
  // STATS CARD COLORS
  // ============================================

  /// Active transactions
  static const Color statsActiveBg = Color(0xFFEFF6FF);
  static const Color statsActiveText = Color(0xFF2563EB);

  /// Completed transactions
  static const Color statsCompletedBg = Color(0xFFD1FAE5);
  static const Color statsCompletedText = Color(0xFF059669);

  /// Dispute
  static const Color statsDisputeBg = Color(0xFFFED7AA);
  static const Color statsDisputeText = Color(0xFFEA580C);

  /// Total
  static const Color statsTotalBg = Color(0xFFEDE9FE);
  static const Color statsTotalText = Color(0xFF7C3AED);

  // ============================================
  // DARK MODE COLORS
  // ============================================

  static const Color darkBackground = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkForeground = Color(0xFFFAFAFA);
  static const Color darkTextPrimary = Color(0xFFFAFAFA);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkBorder = Color(0xFF404040);
  static const Color darkInput = Color(0xFF404040);

  // Gradient colors for dark mode
  static const Color darkGradientStart = Color(0xFF374151);
  static const Color darkGradientEnd = Color(0xFF1F2937);

  // ============================================
  // UTILITY COLORS
  // ============================================

  /// Switch background (inactive)
  static const Color switchBackground = Color(0xFFCBCED4);

  /// Overlay/modal backdrop
  static const Color overlay = Color(0x80000000); // Black 50% opacity

  /// Transparent
  static const Color transparent = Color(0x00000000);

  // ============================================
  // HELPER METHODS
  // ============================================

  /// Get status color based on status string
  static StatusColors getStatusColors(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const StatusColors(
          background: statusCompletedBg,
          text: statusCompletedText,
          border: statusCompletedBorder,
        );
      case 'in escrow':
      case 'escrow':
        return const StatusColors(
          background: statusEscrowBg,
          text: statusEscrowText,
          border: statusEscrowBorder,
        );
      case 'in progress':
      case 'progress':
        return const StatusColors(
          background: statusProgressBg,
          text: statusProgressText,
          border: statusProgressBorder,
        );
      case 'disputed':
      case 'dispute':
        return const StatusColors(
          background: statusDisputedBg,
          text: statusDisputedText,
          border: statusDisputedBorder,
        );
      case 'pending':
      default:
        return const StatusColors(
          background: statusPendingBg,
          text: statusPendingText,
          border: statusPendingBorder,
        );
    }
  }

  /// Create gradient for primary header
  static LinearGradient get primaryGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primary, primaryDark],
      );

  /// Create gradient for dark mode header
  static LinearGradient get darkGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [darkGradientStart, darkGradientEnd],
      );
}

/// Helper class for status colors
class StatusColors {
  final Color background;
  final Color text;
  final Color border;

  const StatusColors({
    required this.background,
    required this.text,
    required this.border,
  });
}
