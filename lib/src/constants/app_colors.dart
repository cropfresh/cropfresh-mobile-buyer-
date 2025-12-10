import 'package:flutter/material.dart';

/// CropFresh Buyers App Design System Colors
/// Theme: "Clean Marketplace" (Material Design 3)
/// Color Rule: 60% White, 30% Orange, 10% Green
class AppColors {
  AppColors._();

  // ============================================
  // PRIMARY PALETTE (30% - Orange - Commerce, Action)
  // ============================================
  static const Color primary = Color(0xFFF57C00);
  static const Color onPrimary = Colors.white;
  static const Color primaryContainer = Color(0xFFFFE0B2);
  static const Color onPrimaryContainer = Color(0xFFE65100);

  // ============================================
  // SECONDARY PALETTE (10% - Green - Trust, Success)
  // ============================================
  static const Color secondary = Color(0xFF2E7D32);
  static const Color onSecondary = Colors.white;
  static const Color secondaryContainer = Color(0xFFC8E6C9);
  static const Color onSecondaryContainer = Color(0xFF002105);

  // ============================================
  // SURFACE PALETTE (60% - White/Light Grey)
  // ============================================
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8FAFC);
  static const Color surfaceContainer = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF0F172A);
  static const Color onSurfaceVariant = Color(0xFF64748B);
  static const Color outline = Color(0xFFE2E8F0);
  static const Color outlineVariant = Color(0xFFF1F5F9);

  // ============================================
  // ERROR PALETTE
  // ============================================
  static const Color error = Color(0xFFB3261E);
  static const Color onError = Colors.white;
  static const Color errorContainer = Color(0xFFF9DEDC);
  static const Color onErrorContainer = Color(0xFF410E0B);

  // ============================================
  // STATUS COLORS
  // ============================================
  static const Color success = Color(0xFF16A34A);
  static const Color successBg = Color(0xFFF0FDF4);
  static const Color warning = Color(0xFFEA580C);
  static const Color warningBg = Color(0xFFFFF7ED);
  static const Color info = Color(0xFF0284C7);
  static const Color infoBg = Color(0xFFF0F9FF);

  // ============================================
  // STATE COLORS
  // ============================================
  static Color primaryHover = primary.withValues(alpha: 0.9);
  static Color primaryPressed = primary.withValues(alpha: 0.8);
  static Color disabled = const Color(0xFFE2E8F0);
  static Color disabledText = const Color(0xFF94A3B8);

  // ============================================
  // GRADIENTS
  // ============================================
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFF57C00), Color(0xFFFF9800)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
