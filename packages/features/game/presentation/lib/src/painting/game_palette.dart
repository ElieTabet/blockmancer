import 'dart:ui';

/// The game's own colours, from the reference prototype. Brand tokens live in
/// DSColor; these only make sense on the board.
abstract final class GamePalette {
  static const boardBackground = Color(0xFF1A1E38);
  static const bossRound = Color(0xFFFF6B7A);
  static const card = Color(0xFF1F2440);
  static const cardBorder = Color(0xFF2E355F);
  static const clearingOutline = Color(0xFFFFF4E6);
  static const collision = Color(0xFFE8473F);
  static const collisionOutline = Color(0xFFFF8A96);
  static const emptyCell = Color(0xFF262B4D);
  static const good = Color(0xFF7FE0A8);
  static const info = Color(0xFF8FD6FF);
  static const jokerCard = Color(0xFF2A2160);
  static const jokerInk = Color(0xFFDCCBFF);
  static const muted = Color(0xFFA9B0D6);
  static const lost = Color(0xFFFF8A96);

  /// One per shape colour index (Shape.colorCount).
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

  /// Behind a sheet, over the board.
  static const scrim = Color(0xE00A0C1A);
  static const sheet = Color(0xFF232846);
  static const stone = Color(0xFF5A5F7A);
}
