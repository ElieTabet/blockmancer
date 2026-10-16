import 'package:flutter/material.dart';

/// Brand colors (tokens).
///
/// [primary] is the logo's ground: the launch screen, the in-app splash and the
/// launcher icon are painted with it. [primaryDark] and [primaryLight] are its
/// lightness steps either side.
class DSColor {
  static const accent = Color(0xFFFFB547); // the logo's accent — links on dark
  static const card = Color(0xFF1F2440); // raised surface on the brand ground
  static const cardBorder = Color(0xFF2E355F);
  static const charcoal = Color(0xFF222D32); // dark surface
  static const charcoalLight = Color(0xFF2F353B); // dark surfaceVariant
  static const cloud = Color(0xFFEFF3F4); // light surfaceVariant
  static const error = Color(0xFFE7505A);
  static const info = Color(0xFF8FD6FF); // informational text on dark
  static const joker = Color(0xFFA57BFF); // jokers, the third brand colour
  static const jokerInk = Color(0xFFDCCBFF); // text on jokerSurface
  static const jokerSurface = Color(0xFF2A2160); // a joker's card
  static const mist = Color(0xFFCFD8DC); // subtle borders / outlines
  static const negative = Color(0xFFFF8A96); // a loss or collision, on dark
  static const positive = Color(0xFF7FE0A8); // a gain, on dark
  static const primary = Color(0xFF14172B); // brand
  static const primaryDark = Color(0xFF0F1221); // hover / active
  static const primaryLight = Color(0xFF1C203D); // primary variant (grad stop)
  static const scrim = Color(0xE00A0C1A); // behind a sheet
  static const sheet = Color(0xFF232846); // bottom sheets, chips
  static const slateGray = Color(0xFF8A9BA8); // onSurfaceVariant
  static const success = Color(0xFF26C281);
  static const textMuted = Color(0xFFA9B0D6); // secondary text on dark
  static const warning = Color(0xFFF3C200);
  static const white = Color(0xFFFFFFFF);
}
