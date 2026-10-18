/// What a joker does to a score, as the Spellbook sorts them: one frame
/// colour each.
enum JokerKind {
  /// Adds to the mult.
  additiveMult,

  /// Changes the board or the round: stones, fog, pieces.
  boardEffect,

  /// Adds chips.
  chips,

  /// Changes which pieces are drawn.
  drawWeight,

  /// Adds points of its own, outside chips × mult.
  flatBonus,

  /// Multiplies the mult.
  multiplicativeMult,
}
