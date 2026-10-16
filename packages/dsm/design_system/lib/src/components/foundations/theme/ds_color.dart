import 'package:flutter/material.dart';

/// Brand colors (tokens).
///
/// [primary] is the logo's ground: the launch screen, the in-app splash and the
/// launcher icon are painted with it. [primaryDark] and [primaryLight] are its
/// lightness steps either side.
class DSColor {
  static const accent = Color(0xFFFFB547); // the logo's accent — links on dark
  static const charcoal = Color(0xFF222D32); // dark surface
  static const charcoalLight = Color(0xFF2F353B); // dark surfaceVariant
  static const cloud = Color(0xFFEFF3F4); // light surfaceVariant
  static const error = Color(0xFFE7505A);
  static const mist = Color(0xFFCFD8DC); // subtle borders / outlines
  static const primary = Color(0xFF14172B); // brand
  static const primaryDark = Color(0xFF0F1221); // hover / active
  static const primaryLight = Color(0xFF1C203D); // primary variant (grad stop)
  static const slateGray = Color(0xFF8A9BA8); // onSurfaceVariant
  static const success = Color(0xFF26C281);
  static const warning = Color(0xFFF3C200);
  static const white = Color(0xFFFFFFFF);
}
