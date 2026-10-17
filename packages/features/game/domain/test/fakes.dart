import 'package:game_domain/game_domain.dart';
import 'package:shared_domain/shared_domain.dart';

export 'fake_best_scores.dart';
export 'fake_run_store.dart';

/// A clock at [current], which a test may move.
final class FakeClock implements Clock {
  FakeClock(this.current);

  DateTime current;

  @override
  DateTime now() => current;
}

/// Rules on the engine's map, cut short: Rubble, then Gravity, then Fog, which
/// has no rules yet. The daily seed is the date as `yyyymmdd` plus one, so a
/// test can tell a seed from a day. Beating Rubble's boss unlocks Stonemason
/// and Quarry, Gravity's Anchor and Avalanche. Nothing else is called.
final class TwoWorldRules implements GameRules {
  const TwoWorldRules();

  @override
  List<JokerId> get startingJokers => const [.patience, .twin];

  @override
  List<WorldId> get worldOrder => const [.rubble, .gravity, .fog];

  @override
  RunConfig configFor(WorldId world, {required List<JokerId> jokerPool}) {
    if (!isPlayable(world)) {
      throw ArgumentError.value(world, 'world', 'is not playable');
    }

    return _config.copyWith(jokerPool: jokerPool, world: world);
  }

  @override
  int dailySeed({required int day, required int month, required int year}) =>
      year * 10000 + month * 100 + day + 1;

  @override
  bool isPlayable(WorldId world) => world == .rubble || world == .gravity;

  @override
  WorldId? nextWorld(WorldId world) => switch (world) {
    .rubble => .gravity,
    .gravity => .fog,
    .fog || .mirror || .speed => null,
  };

  @override
  List<JokerId> unlocksOf(WorldId world) => switch (world) {
    .rubble => const [.stonemason, .quarry],
    .gravity => const [.anchor, .avalanche],
    .fog || .mirror || .speed => const [],
  };

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Rules with a map of [worldOrder] and [startingJokers]. Nothing else is
/// called.
final class MapRules implements GameRules {
  const MapRules({required this.startingJokers, required this.worldOrder});

  @override
  final List<JokerId> startingJokers;

  @override
  final List<WorldId> worldOrder;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _config = RunConfig(
  chipsPerCell: 10,
  jokerPool: JokerId.values,
  jokers: JokerTuning(
    anchorMult: 4,
    avalancheChipsPerCell: 25,
    bigBoxFactor: 3,
    bigBoxMinPieceSize: 5,
    brinkFactor: 2,
    brinkMinOccupied: 40,
    collectorMultPerJoker: 1,
    columnFactor: 2,
    comboMultPerStreak: 1,
    finisherFactor: 2,
    fullHouseCellsPerMult: 6,
    hatTrickBonus: 300,
    heavyFactor: 2,
    heavyMinPieceSize: 4,
    patienceStoredPerMove: 2,
    pocketsExtraPieces: 4,
    precisionBonusMult: 6,
    precisionMaxPieceSize: 2,
    quarryStonesPerClear: 1,
    saverPointsPerPiece: 40,
    stonemasonChipsPerStone: 50,
    stonemasonExtraStones: 2,
    sweepBonus: 500,
    tinyFactor: 3,
    tinyMaxPieceSize: 2,
    twinFactor: 3,
    twinMinLines: 2,
  ),
  offerCount: 3,
  partnerBias: 0.75,
  revivePieces: 3,
  reviveRows: 2,
  revivesPerRun: 1,
  rounds: [RoundSpec(isBoss: true, pieces: 14, stones: 0, target: 250)],
  starThreshold: 8000,
  starUnlocks: [
    StarUnlock(jokers: [.fullhouse, .brink], stars: 4),
    StarUnlock(jokers: [.finisher, .hattrick], stars: 6),
  ],
  traySize: 3,
  world: .rubble,
);

/// A Rubble run in [phase], whose third star takes 8000 points.
RunState runIn(RunPhase phase, {int revivesUsed = 0, int runTotal = 0}) =>
    RunState(
      board: Board.empty(),
      config: _config,
      jokers: const [],
      phase: phase,
      pickIndex: 1,
      piecesLeft: 5,
      piecesRngState: 0,
      revivesUsed: revivesUsed,
      roundIndex: 0,
      runTotal: runTotal,
      score: 40,
      seed: 7,
      stonesRngState: 0,
      storedMult: 0,
      streak: 0,
      tray: const [0, 1, 2],
    );

/// A practice run in [phase].
SavedRun savedIn(RunPhase phase) =>
    SavedRun(mode: const .practice(), run: runIn(phase));
