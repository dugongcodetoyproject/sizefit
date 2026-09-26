import 'package:flutter/material.dart';

abstract final class AppColors {
  // Neutral dark / light
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardBorderLight = Color(0xFFE9ECEF);
  
  static const Color backgroundDark = Color(0xFF121417);
  static const Color surfaceDark = Color(0xFF1A1D21);
  static const Color cardBorderDark = Color(0xFF2C3036);

  // Brand / Action
  static const Color primary = Color(0xFF2563EB); // Vibrant Royal Blue
  static const Color primaryHover = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFFEFF6FF);

  // Status & Accents
  static const Color success = Color(0xFF10B981); // Emerald Green
  static const Color successLight = Color(0xFFECFDF5);
  static const Color warning = Color(0xFFF59E0B); // Amber Warning
  static const Color warningLight = Color(0xFFFFFBEB);
  static const Color error = Color(0xFFEF4444);

  // Text colors
  static const Color textPrimaryLight = Color(0xFF111827);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
}
