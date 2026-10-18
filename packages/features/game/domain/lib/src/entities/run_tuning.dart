import 'package:shared_domain/shared_domain.dart';

/// The text Remote Config publishes for a key, or null when none is published.
typedef RemoteValueFun = String? Function(String key);

/// [config] with every value Remote Config publishes for it. A value that
/// isn't a number in its key's range is ignored, so a typo in the console
/// plays the default rather than a broken run.
RunConfig tuned(RunConfig config, RemoteValueFun valueOf) {
  var result = config;

  for (final key in _keys) {
    if (!key.tunes(config)) continue;

    final value = _parsed(key, valueOf(key.name));

    if (value != null) result = key.write(result, value);
  }

  return result;
}

/// Every key [tuned] reads, each with the default the rules play with: a
/// world's own keys read that world's run.
List<RemoteKey> runTuningKeys(GameRules rules) => [
  for (final key in _keys)
    if (key.tunes(_configOf(key.world, rules)))
      RemoteKey(
        defaultValue: _text(key.read(_configOf(key.world, rules))),
        description: key.description,
        kind: .number,
        max: key.max,
        min: key.min,
        name: key.name,
      ),
];

/// [world]'s run, or the map's first world's for a key every world shares or
/// a world the rules can't play yet.
RunConfig _configOf(WorldId? world, GameRules rules) => rules.configFor(
  world != null && rules.isPlayable(world) ? world : rules.worldOrder.first,
  jokerPool: const [],
);

num? _parsed(_ConfigKey key, String? text) {
  if (text == null) return null;

  final value = key.isDouble
      ? double.tryParse(text.trim())
      : int.tryParse(text.trim());

  if (value == null || value < key.min || value > key.max) return null;

  return value;
}

String _text(num value) => value is double ? value.toString() : '$value';

final class _ConfigKey {
  const _ConfigKey(
    this.name,
    this.description, {
    required this.max,
    required this.min,
    required this.read,
    required this.write,
    this.isDouble = false,
    this.round,
    this.world,
  });

  final String description;
  final bool isDouble;
  final num max;
  final num min;
  final String name;
  final num Function(RunConfig config) read;

  /// The round, before the boss, the key tunes; null for none in particular.
  final int? round;
  final RunConfig Function(RunConfig config, num value) write;

  /// The only world whose run the key tunes; null for every world's.
  final WorldId? world;

  bool tunes(RunConfig config) {
    final round = this.round;

    return (world == null || world == config.world) &&
        (round == null || round < config.rounds.length - 1);
  }
}

RunConfig _withRound(
  RunConfig config,
  int index,
  RoundSpec Function(RoundSpec round) change,
) => config.copyWith(
  rounds: [
    for (final (at, round) in config.rounds.indexed)
      at == index ? change(round) : round,
  ],
);

RunConfig _withBoss(RunConfig config, RoundSpec Function(RoundSpec) change) =>
    _withRound(config, config.rounds.length - 1, change);

RunConfig _withJokers(
  RunConfig config,
  JokerTuning Function(JokerTuning jokers) change,
) => config.copyWith(jokers: change(config.jokers));

_ConfigKey _joker(
  String name,
  String description, {
  required num max,
  required num min,
  required int Function(JokerTuning jokers) read,
  required JokerTuning Function(JokerTuning jokers, int value) write,
}) => _ConfigKey(
  'joker_$name',
  description,
  max: max,
  min: min,
  read: (config) => read(config.jokers),
  write: (config, value) =>
      _withJokers(config, (jokers) => write(jokers, value.toInt())),
);

final _keys = <_ConfigKey>[
  for (var round = 0; round < 4; round++) ...[
    _ConfigKey(
      'round_${round + 1}_target',
      'Points to clear round ${round + 1}',
      max: 100000,
      min: 1,
      read: (config) => config.rounds[round].target,
      round: round,
      write: (config, value) => _withRound(
        config,
        round,
        (spec) => spec.copyWith(target: value.toInt()),
      ),
    ),
    _ConfigKey(
      'round_${round + 1}_pieces',
      'Pieces dealt in round ${round + 1}',
      max: 60,
      min: 1,
      read: (config) => config.rounds[round].pieces,
      round: round,
      write: (config, value) => _withRound(
        config,
        round,
        (spec) => spec.copyWith(pieces: value.toInt()),
      ),
    ),
  ],
  _ConfigKey(
    'boss_pieces',
    'Pieces dealt in every boss round',
    max: 60,
    min: 1,
    read: (config) => config.rounds.last.pieces,
    write: (config, value) =>
        _withBoss(config, (spec) => spec.copyWith(pieces: value.toInt())),
  ),
  for (final world in WorldId.values) ...[
    _ConfigKey(
      'boss_target_${world.name}',
      "Points to beat ${world.name}'s boss",
      max: 100000,
      min: 1,
      read: (config) => config.rounds.last.target,
      world: world,
      write: (config, value) =>
          _withBoss(config, (spec) => spec.copyWith(target: value.toInt())),
    ),
    _ConfigKey(
      'star3_${world.name}',
      "Run total that earns ${world.name}'s third star",
      max: 1000000,
      min: 0,
      read: (config) => config.starThreshold,
      world: world,
      write: (config, value) => config.copyWith(starThreshold: value.toInt()),
    ),
  ],
  _ConfigKey(
    'rubble_boss_stones',
    "Stones on the board as Rubble's boss starts",
    max: 20,
    min: 0,
    read: (config) => config.rounds.last.stones,
    world: .rubble,
    write: (config, value) =>
        _withBoss(config, (spec) => spec.copyWith(stones: value.toInt())),
  ),
  _ConfigKey(
    'fog_boss_cells',
    "Fog cells on the board as Fog's boss starts",
    max: 30,
    min: 0,
    read: (config) => config.rounds.last.fog,
    world: .fog,
    write: (config, value) =>
        _withBoss(config, (spec) => spec.copyWith(fog: value.toInt())),
  ),
  _ConfigKey(
    'fog_boss_hidden_stones',
    "How many of Fog's cells hide a stone",
    max: 30,
    min: 0,
    read: (config) => config.rounds.last.fogStones,
    world: .fog,
    write: (config, value) =>
        _withBoss(config, (spec) => spec.copyWith(fogStones: value.toInt())),
  ),
  _ConfigKey(
    'tide_boss_gaps',
    "Empty columns in each stone row Tide's boss raises",
    max: 7,
    min: 1,
    read: (config) => config.rounds.last.tideGaps,
    world: .tide,
    write: (config, value) =>
        _withBoss(config, (spec) => spec.copyWith(tideGaps: value.toInt())),
  ),
  _ConfigKey(
    'chips_per_cell',
    'Chips per cleared cell',
    max: 1000,
    min: 1,
    read: (config) => config.chipsPerCell,
    write: (config, value) => config.copyWith(chipsPerCell: value.toInt()),
  ),
  _ConfigKey(
    'offer_count',
    'Jokers offered at each pick',
    max: 3,
    min: 1,
    read: (config) => config.offerCount,
    write: (config, value) => config.copyWith(offerCount: value.toInt()),
  ),
  _ConfigKey(
    'partner_bias',
    "Chance an offer slot holds an owned joker's partner",
    isDouble: true,
    max: 1,
    min: 0,
    read: (config) => config.partnerBias,
    write: (config, value) => config.copyWith(partnerBias: value.toDouble()),
  ),
  _ConfigKey(
    'revive_pieces',
    'Pieces a revive adds',
    max: 20,
    min: 0,
    read: (config) => config.revivePieces,
    write: (config, value) => config.copyWith(revivePieces: value.toInt()),
  ),
  _ConfigKey(
    'revive_rows',
    'Fullest rows a revive empties',
    max: 8,
    min: 0,
    read: (config) => config.reviveRows,
    write: (config, value) => config.copyWith(reviveRows: value.toInt()),
  ),
  _ConfigKey(
    'revives_per_run',
    'Revives a run may use',
    max: 5,
    min: 0,
    read: (config) => config.revivesPerRun,
    write: (config, value) => config.copyWith(revivesPerRun: value.toInt()),
  ),
  _joker(
    'anchor_mult',
    'Anchor: mult when the bottom row clears',
    max: 50,
    min: 0,
    read: (jokers) => jokers.anchorMult,
    write: (jokers, value) => jokers.copyWith(anchorMult: value),
  ),
  _joker(
    'avalanche_chips_per_cell',
    'Avalanche: chips per filled cell left in the bottom rows',
    max: 1000,
    min: 0,
    read: (jokers) => jokers.avalancheChipsPerCell,
    write: (jokers, value) => jokers.copyWith(avalancheChipsPerCell: value),
  ),
  _joker(
    'avalanche_rows',
    'Avalanche: bottom rows counted',
    max: 8,
    min: 1,
    read: (jokers) => jokers.avalancheRows,
    write: (jokers, value) => jokers.copyWith(avalancheRows: value),
  ),
  _joker(
    'big_box_factor',
    'Big Box: draw weight of big pieces',
    max: 10,
    min: 1,
    read: (jokers) => jokers.bigBoxFactor,
    write: (jokers, value) => jokers.copyWith(bigBoxFactor: value),
  ),
  _joker(
    'big_box_min_piece_size',
    'Big Box: cells from which a piece is big',
    max: 9,
    min: 1,
    read: (jokers) => jokers.bigBoxMinPieceSize,
    write: (jokers, value) => jokers.copyWith(bigBoxMinPieceSize: value),
  ),
  _joker(
    'brink_factor',
    'On the Brink: mult factor on a crowded board',
    max: 10,
    min: 1,
    read: (jokers) => jokers.brinkFactor,
    write: (jokers, value) => jokers.copyWith(brinkFactor: value),
  ),
  _joker(
    'brink_min_occupied',
    'On the Brink: occupied cells for a crowded board',
    max: 64,
    min: 0,
    read: (jokers) => jokers.brinkMinOccupied,
    write: (jokers, value) => jokers.copyWith(brinkMinOccupied: value),
  ),
  _joker(
    'collector_mult_per_joker',
    'Collector: mult for every two jokers owned',
    max: 10,
    min: 0,
    read: (jokers) => jokers.collectorMultPerJoker,
    write: (jokers, value) => jokers.copyWith(collectorMultPerJoker: value),
  ),
  _joker(
    'column_factor',
    'Column Hunter: mult factor on a column clear',
    max: 10,
    min: 1,
    read: (jokers) => jokers.columnFactor,
    write: (jokers, value) => jokers.copyWith(columnFactor: value),
  ),
  _joker(
    'combo_mult_per_streak',
    'Combo King: mult per level of the streak',
    max: 10,
    min: 0,
    read: (jokers) => jokers.comboMultPerStreak,
    write: (jokers, value) => jokers.copyWith(comboMultPerStreak: value),
  ),
  _joker(
    'ember_factor',
    'Ember: mult factor when a stone or fog goes',
    max: 10,
    min: 1,
    read: (jokers) => jokers.emberFactor,
    write: (jokers, value) => jokers.copyWith(emberFactor: value),
  ),
  _joker(
    'ember_mult',
    'Ember: mult on a clear that takes no stone or fog',
    max: 50,
    min: 0,
    read: (jokers) => jokers.emberMult,
    write: (jokers, value) => jokers.copyWith(emberMult: value),
  ),
  _joker(
    'finisher_factor',
    "Finisher: mult factor on the tray's last piece",
    max: 10,
    min: 1,
    read: (jokers) => jokers.finisherFactor,
    write: (jokers, value) => jokers.copyWith(finisherFactor: value),
  ),
  _joker(
    'full_house_cells_per_mult',
    'Full House: occupied cells per step of mult',
    max: 64,
    min: 1,
    read: (jokers) => jokers.fullHouseCellsPerMult,
    write: (jokers, value) => jokers.copyWith(fullHouseCellsPerMult: value),
  ),
  _joker(
    'full_house_mult_per_block',
    'Full House: mult per step',
    max: 10,
    min: 0,
    read: (jokers) => jokers.fullHouseMultPerBlock,
    write: (jokers, value) => jokers.copyWith(fullHouseMultPerBlock: value),
  ),
  _joker(
    'hat_trick_bonus',
    'Hat Trick: points when every piece of a tray clears',
    max: 10000,
    min: 0,
    read: (jokers) => jokers.hatTrickBonus,
    write: (jokers, value) => jokers.copyWith(hatTrickBonus: value),
  ),
  _joker(
    'heavy_factor',
    'Heavyweight: mult factor for a big piece',
    max: 10,
    min: 1,
    read: (jokers) => jokers.heavyFactor,
    write: (jokers, value) => jokers.copyWith(heavyFactor: value),
  ),
  _joker(
    'heavy_min_piece_size',
    'Heavyweight: cells from which a piece is big',
    max: 9,
    min: 1,
    read: (jokers) => jokers.heavyMinPieceSize,
    write: (jokers, value) => jokers.copyWith(heavyMinPieceSize: value),
  ),
  _joker(
    'momentum_mult_per_tray',
    'Momentum: mult per tray in the streak',
    max: 10,
    min: 0,
    read: (jokers) => jokers.momentumMultPerTray,
    write: (jokers, value) => jokers.copyWith(momentumMultPerTray: value),
  ),
  _joker(
    'patience_stored_per_move',
    'Patience: mult stored per move that clears nothing',
    max: 10,
    min: 0,
    read: (jokers) => jokers.patienceStoredPerMove,
    write: (jokers, value) => jokers.copyWith(patienceStoredPerMove: value),
  ),
  _joker(
    'pockets_extra_pieces',
    'Deep Pockets: extra pieces every round',
    max: 30,
    min: 0,
    read: (jokers) => jokers.pocketsExtraPieces,
    write: (jokers, value) => jokers.copyWith(pocketsExtraPieces: value),
  ),
  _joker(
    'precision_bonus_mult',
    'Precision: mult when a small piece clears',
    max: 50,
    min: 0,
    read: (jokers) => jokers.precisionBonusMult,
    write: (jokers, value) => jokers.copyWith(precisionBonusMult: value),
  ),
  _joker(
    'precision_max_piece_size',
    'Precision: cells up to which a piece is small',
    max: 9,
    min: 1,
    read: (jokers) => jokers.precisionMaxPieceSize,
    write: (jokers, value) => jokers.copyWith(precisionMaxPieceSize: value),
  ),
  _joker(
    'prism_chips_per_pair',
    'Prism: chips per cell matched across the centre',
    max: 1000,
    min: 0,
    read: (jokers) => jokers.prismChipsPerPair,
    write: (jokers, value) => jokers.copyWith(prismChipsPerPair: value),
  ),
  _joker(
    'quarry_stones_per_clear',
    'Quarry: stones dropped after each clear',
    max: 5,
    min: 0,
    read: (jokers) => jokers.quarryStonesPerClear,
    write: (jokers, value) => jokers.copyWith(quarryStonesPerClear: value),
  ),
  _joker(
    'saver_points_per_piece',
    'Saver: run points per piece left when a round is won',
    max: 1000,
    min: 0,
    read: (jokers) => jokers.saverPointsPerPiece,
    write: (jokers, value) => jokers.copyWith(saverPointsPerPiece: value),
  ),
  _joker(
    'sprinter_mult',
    "Sprinter: mult when a tray's first piece clears",
    max: 50,
    min: 0,
    read: (jokers) => jokers.sprinterMult,
    write: (jokers, value) => jokers.copyWith(sprinterMult: value),
  ),
  _joker(
    'stonemason_chips_per_stone',
    'Stonemason: chips per stone cleared',
    max: 1000,
    min: 0,
    read: (jokers) => jokers.stonemasonChipsPerStone,
    write: (jokers, value) => jokers.copyWith(stonemasonChipsPerStone: value),
  ),
  _joker(
    'stonemason_extra_stones',
    'Stonemason: stones added at every round start',
    max: 10,
    min: 0,
    read: (jokers) => jokers.stonemasonExtraStones,
    write: (jokers, value) => jokers.copyWith(stonemasonExtraStones: value),
  ),
  _joker(
    'sweep_bonus',
    'Clean Sweep: points when the board empties',
    max: 10000,
    min: 0,
    read: (jokers) => jokers.sweepBonus,
    write: (jokers, value) => jokers.copyWith(sweepBonus: value),
  ),
  _joker(
    'symmetry_mult',
    'Symmetry: mult when the board is mirror-symmetric',
    max: 50,
    min: 0,
    read: (jokers) => jokers.symmetryMult,
    write: (jokers, value) => jokers.copyWith(symmetryMult: value),
  ),
  _joker(
    'tiny_factor',
    'Tiny Tools: draw weight of small pieces',
    max: 10,
    min: 1,
    read: (jokers) => jokers.tinyFactor,
    write: (jokers, value) => jokers.copyWith(tinyFactor: value),
  ),
  _joker(
    'tiny_max_piece_size',
    'Tiny Tools: cells up to which a piece is small',
    max: 9,
    min: 1,
    read: (jokers) => jokers.tinyMaxPieceSize,
    write: (jokers, value) => jokers.copyWith(tinyMaxPieceSize: value),
  ),
  _joker(
    'twin_factor',
    'Twin Lines: mult factor when lines clear together',
    max: 10,
    min: 1,
    read: (jokers) => jokers.twinFactor,
    write: (jokers, value) => jokers.copyWith(twinFactor: value),
  ),
  _joker(
    'twin_min_lines',
    'Twin Lines: lines that must clear together',
    max: 16,
    min: 2,
    read: (jokers) => jokers.twinMinLines,
    write: (jokers, value) => jokers.copyWith(twinMinLines: value),
  ),
];
