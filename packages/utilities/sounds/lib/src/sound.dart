/// Every sound the app plays, each with the volume that levels it against the
/// others: the files come from different packs, mastered at different levels.
enum Sound {
  bossStart('boss_start', volume: 0.5),
  bossWin('boss_win', volume: 0.9),
  clear('clear', volume: 0.7),
  joker('joker', volume: 0.7),
  kaching('kaching', volume: 1),
  place('place', volume: 1),
  roundLost('round_lost', volume: 0.8),
  roundWon('round_won', volume: 0.8),
  tap('tap', volume: 0.4),
  tick('tick', volume: 0.8);

  final String _fileName;

  /// Relative to the file as mastered; above 1 amplifies.
  final double volume;

  const Sound(this._fileName, {required this.volume});

  /// Package-qualified, because the asset is bundled by this package and
  /// loaded from whichever app depends on it.
  String get assetKey => 'packages/sounds/assets/sounds/$_fileName.ogg';
}
