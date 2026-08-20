import 'package:flutter/material.dart';

/// "Obsidian & Copper" — MoRmdn design system v1.0.
/// Dark-first palette built from stacked planes and hairlines, not blur.
class AppColors {
  // Ink scale (backgrounds & surfaces)
  static const Color ink900 = Color(0xFF0A0A0C); // page background
  static const Color ink800 = Color(0xFF101013); // alternate section bg
  static const Color ink700 = Color(0xFF16161B); // surface / card
  static const Color ink600 = Color(0xFF1E1E24); // raised surface, input fill

  // Bone (text) scale — warm off-white, never pure white
  static const Color bone = Color(0xFFF2EEE7);
  static Color bone70 = bone.withValues(alpha: 0.70);
  static Color bone62 = bone.withValues(alpha: 0.62);
  static Color bone45 = bone.withValues(alpha: 0.45);
  static Color bone38 = bone.withValues(alpha: 0.38);
  static Color bone28 = bone.withValues(alpha: 0.28);
  static Color bone10 = bone.withValues(alpha: 0.10);
  static Color bone06 = bone.withValues(alpha: 0.06);

  // Hairlines
  static Color line = bone.withValues(alpha: 0.10);
  static Color lineStrong = bone.withValues(alpha: 0.20);
  static Color bone18 = bone.withValues(alpha: 0.18);

  // Accent — copper. One accent per viewport.
  static const Color copper = Color(0xFFF2762E);
  static const Color copperBright = Color(0xFFFF8A45);
  static const Color copperDim = Color(0xFFC25A1E);
  static Color copperWash = copper.withValues(alpha: 0.12);

  // Status-only colors
  static const Color jade = Color(0xFF3FD8C0); // available / success / live
  static const Color rose = Color(0xFFFF6B6B); // error / destructive

  // ---- Legacy aliases ----
  // Kept so admin_page.dart / older call sites keep compiling under the
  // new palette without a line-by-line rewrite.
  static const Color primaryBlue = copper;
  static const Color primaryDark = copperDim;
  static const Color primaryLight = copperBright;

  static const Color accentCyan = jade;
  static const Color accentGreen = jade;
  static const Color accentPurple = Color(0xFF8A8A94);
  static const Color accentPink = rose;
  static const Color accentOrange = copper;

  static const Color darkBackground = ink900;
  static const Color cardBackground = ink700;
  static const Color surfaceColor = ink600;
  static Color textPrimary = bone;
  static Color textSecondary = bone70;
  static Color textMuted = bone45;

  static Color glassBackground = bone.withValues(alpha: 0.04);
  static Color glassBorder = bone.withValues(alpha: 0.10);
  static Color glassHighlight = bone.withValues(alpha: 0.03);

  static Color primaryGlow = copper.withValues(alpha: 0.4);
  static Color cyanGlow = jade.withValues(alpha: 0.4);
  static Color purpleGlow = accentPurple.withValues(alpha: 0.4);
  static Color greenGlow = jade.withValues(alpha: 0.4);

  static Color hoverOverlay = bone.withValues(alpha: 0.05);
  static Color activeOverlay = bone.withValues(alpha: 0.1);

  static const Color success = jade;
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = rose;

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [copper, copperDim],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [ink700, ink600],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [ink900, ink800],
  );

  static const LinearGradient vibrantGradient = primaryGradient;
  static const LinearGradient sunsetGradient = primaryGradient;
  static const LinearGradient oceanGradient = primaryGradient;
  static const LinearGradient purpleHazeGradient = primaryGradient;

  static RadialGradient glowGradient(Color color) => RadialGradient(
    colors: [
      color.withValues(alpha: 0.3),
      color.withValues(alpha: 0.1),
      Colors.transparent,
    ],
  );
}
