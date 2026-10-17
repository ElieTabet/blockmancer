enum Sound {
  clear('clear'),
  joker('joker'),
  place('place'),
  roundLost('round_lost'),
  roundWon('round_won'),
  tap('tap');

  final String _fileName;

  const Sound(this._fileName);

  /// Package-qualified, because the asset is bundled by this package and
  /// loaded from whichever app depends on it.
  String get assetKey => 'packages/sounds/assets/sounds/$_fileName.ogg';
}
