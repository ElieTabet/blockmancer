import 'package:flutter/material.dart';

/// A joker card's frame, one per kind of joker (what it does to a score): the
/// one map every joker card reads its colours from.
enum DSJokerFrame {
  additiveMult(edge: Color(0xFFFF7A6B), surface: Color(0xFF3A1D2B)),
  boardEffect(edge: Color(0xFF4FD1C5), surface: Color(0xFF123536)),
  chips(edge: Color(0xFF5AB8FF), surface: Color(0xFF142D4A)),
  drawWeight(edge: Color(0xFFFFA24C), surface: Color(0xFF3A2915)),
  flatBonus(edge: Color(0xFF7FE0A8), surface: Color(0xFF153527)),
  multiplicativeMult(edge: Color(0xFFC77DFF), surface: Color(0xFF2C1A47));

  const DSJokerFrame({required this.edge, required this.surface});

  /// The frame, the emblem and the kind's chip.
  final Color edge;

  /// The card's face.
  final Color surface;
}

/// A joker's mastery tiers, from runs won with it.
abstract final class DSMasteryColor {
  static const bronze = Color(0xFFD08A4E);

  /// A tier not reached yet.
  static const empty = Color(0xFF3A4170);
  static const gold = Color(0xFFFFD34D);
  static const silver = Color(0xFFD3DAE3);
}
