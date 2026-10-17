import 'package:flutter/material.dart';

/// The game board's colours, from the reference prototype. Kept apart from
/// [DSColor] because they only mean something on a board — but here, in the
/// design system, so every screen that draws pieces draws the same ones.
class DSGameColor {
  static const boardBackground = Color(0xFF1A1E38);
  static const bossRound = Color(0xFFFF6B7A);

  /// Outlines the lines a drop would clear.
  static const clearingOutline = Color(0xFFFFF4E6);
  static const collision = Color(0xFFE8473F);
  static const collisionOutline = Color(0xFFFF8A96);
  static const emptyCell = Color(0xFF262B4D);

  /// One per shape colour index (`Shape.colorCount`): a shape always wears
  /// the same one.
  static const pieces = [
    Color(0xFFFFC845),
    Color(0xFF5EC8FF),
    Color(0xFF7FE0A8),
    Color(0xFFFF8A5B),
    Color(0xFFFF6B7A),
    Color(0xFFA57BFF),
    Color(0xFF4FB7FF),
    Color(0xFFE8613F),
    Color(0xFF5FD98F),
  ];
  static const regularRound = Color(0xFF5EC8FF);
  static const stone = Color(0xFF5A5F7A);

  /// A stone's sunken face, inside its [stone] bevel: flat pieces have none,
  /// so a stone never reads as one more colour.
  static const stoneFace = Color(0xFF3B3F57);
}
