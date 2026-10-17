/// Where one world of the map stands for the player.
enum WorldNodeStatus {
  /// Without its rules yet, so nobody can play it.
  comingSoon,

  /// Open, its boss not beaten yet.
  current,

  /// Its boss beaten. Still open, for the stars it lacks.
  done,

  /// Waiting on the boss before it.
  locked,
}
