import 'package:flutter/animation.dart';

/// Animation constants for consistent motion design
/// Following Material Design 3 motion principles
class AnimationConstants {
  AnimationConstants._();

  // Durations
  static const Duration durationShort = Duration(milliseconds: 150);
  static const Duration durationMedium = Duration(milliseconds: 300);
  static const Duration durationLong = Duration(milliseconds: 500);
  static const Duration durationSplash = Duration(milliseconds: 2000);

  // Curves (M3 Emphasized)
  static const Curve curveStandard = Curves.easeInOut;
  static const Curve curveEmphasized = Curves.easeOutCubic;
  static const Curve curveDecelerate = Curves.decelerate;
  static const Curve curveSpring = Curves.elasticOut;
}
