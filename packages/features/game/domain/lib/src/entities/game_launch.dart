/// What the player asked to play.
enum GameLaunch {
  daily,
  practice,

  /// The run saved on this device, where it stood.
  resume,

  /// The guided first run, which hands over to a practice run.
  tutorial,
}
