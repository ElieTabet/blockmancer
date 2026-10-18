enum LossReason {
  /// The tide pushed a filled cell, a stone or fog off the top (Tide's boss).
  flooded,

  /// None of the pieces left in the tray fits anywhere.
  noRoom,

  /// Every piece of the round was played without reaching the target.
  outOfPieces,
}
