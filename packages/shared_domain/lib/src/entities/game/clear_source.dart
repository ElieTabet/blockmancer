/// What completed the lines a `LinesCleared` took.
enum ClearSource {
  /// The piece just placed: the move scores them.
  move,

  /// The tide's rise (Tide's boss): they clear for nothing.
  tide,
}
