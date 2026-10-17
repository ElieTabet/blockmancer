/// Where the guided first run's coach is.
enum TutorialStep {
  /// A line is there to clear; the score it makes comes next.
  clear,

  /// The first piece is still to be placed.
  drag,

  /// The real starting pick of the practice run the tutorial hands over to.
  pick,

  /// The clear's score holds on `chips × mult` until a touch.
  score,
}
