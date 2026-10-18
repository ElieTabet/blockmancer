import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:game_data/game_data.dart';
import 'package:game_data/src/dtos/saved_run_dto.br.dart';
import 'package:game_domain/game_domain.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The numbers version 1 played with, when they were constants of the build,
/// and the defaults versions 4, 7 and 8 gave the jokers and numbers they
/// added.
const _version1Tuning = JokerTuning(
  anchorMult: 4,
  avalancheChipsPerCell: 25,
  avalancheRows: 2,
  bigBoxFactor: 3,
  bigBoxMinPieceSize: 5,
  brinkFactor: 2,
  brinkMinOccupied: 40,
  collectorMultPerJoker: 1,
  columnFactor: 2,
  comboMultPerStreak: 1,
  emberFactor: 2,
  emberMult: 0,
  finisherFactor: 2,
  fullHouseCellsPerMult: 6,
  fullHouseMultPerBlock: 1,
  hatTrickBonus: 300,
  heavyFactor: 2,
  heavyMinPieceSize: 4,
  momentumMultPerTray: 2,
  patienceStoredPerMove: 2,
  pocketsExtraPieces: 4,
  precisionBonusMult: 6,
  precisionMaxPieceSize: 2,
  prismChipsPerPair: 15,
  quarryStonesPerClear: 1,
  saverPointsPerPiece: 40,
  sprinterMult: 5,
  stonemasonChipsPerStone: 50,
  stonemasonExtraStones: 2,
  sweepBonus: 500,
  symmetryMult: 4,
  tinyFactor: 3,
  tinyMaxPieceSize: 2,
  twinFactor: 3,
  twinMinLines: 2,
);

/// Every joker number distinct and off its default, so a field the DTO drops
/// or swaps shows up.
const _tuning = JokerTuning(
  anchorMult: 19,
  avalancheChipsPerCell: 21,
  avalancheRows: 6,
  bigBoxFactor: 15,
  bigBoxMinPieceSize: 9,
  brinkFactor: 24,
  brinkMinOccupied: 30,
  collectorMultPerJoker: 8,
  columnFactor: 11,
  comboMultPerStreak: 10,
  emberFactor: 33,
  emberMult: 38,
  finisherFactor: 25,
  fullHouseCellsPerMult: 22,
  fullHouseMultPerBlock: 23,
  hatTrickBonus: 950,
  heavyFactor: 12,
  heavyMinPieceSize: 5,
  momentumMultPerTray: 34,
  patienceStoredPerMove: 16,
  pocketsExtraPieces: 17,
  precisionBonusMult: 18,
  precisionMaxPieceSize: 4,
  prismChipsPerPair: 35,
  quarryStonesPerClear: 2,
  saverPointsPerPiece: 70,
  sprinterMult: 36,
  stonemasonChipsPerStone: 80,
  stonemasonExtraStones: 7,
  sweepBonus: 900,
  symmetryMult: 37,
  tinyFactor: 14,
  tinyMaxPieceSize: 1,
  twinFactor: 13,
  twinMinLines: 3,
);

const _config = RunConfig(
  chipsPerCell: 20,
  jokerPool: [.anchor, .patience, .twin, .stonemason],
  jokers: _tuning,
  mastery: MasteryThresholds(bronze: 1, gold: 15, silver: 5),
  offerCount: 3,
  partnerBias: 0.75,
  revivePieces: 3,
  reviveRows: 2,
  revivesPerRun: 1,
  rounds: [
    RoundSpec(isBoss: false, pieces: 14, stones: 0, target: 250),
    RoundSpec(
      fog: 8,
      fogStones: 3,
      isBoss: true,
      pieces: 22,
      stones: 6,
      target: 2000,
      tideGaps: 2,
    ),
  ],
  starThreshold: 9500,
  starUnlocks: [
    StarUnlock(jokers: [.brink], stars: 2),
  ],
  traySize: 3,
  world: .gravity,
);

/// Mid-round in the boss: stones and pieces on the board, a stored Patience
/// bank, a streak going, one revive spent and a tray slot already played,
/// whose piece cleared a line.
final _midRound = RunState(
  board: Board.empty().withCells({
    const Cell(col: 0, row: 0): const .stone(),
    const Cell(col: 7, row: 7): const .stone(),
    const Cell(col: 3, row: 2): const .filled(colorIndex: 0),
    const Cell(col: 4, row: 2): const .filled(colorIndex: 8),
  }),
  config: _config,
  jokers: const [.patience, .twin, .stonemason],
  phase: const .playing(),
  pickIndex: 2,
  piecesLeft: 11,
  piecesRngState: 0xDEADBEEF,
  revivesUsed: 1,
  roundIndex: 1,
  runTotal: 1870,
  score: 640,
  seed: 20261017,
  stonesRngState: 123456789,
  storedMult: 6,
  streak: 3,
  tray: const [4, null, 16],
  momentumStreak: 1,
  trayClearMask: 0x2,
  trayDealt: 3,
);

/// [_midRound] as the version 1 build wrote it, before the config carried chips
/// per cell or joker numbers. Frozen: never regenerate it from today's DTOs.
const _version1Save = """
{"day":20261017,"mode":"daily","run":{"board":[
-1,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,1,9,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,-1],
"config":{"offerCount":3,"partnerBias":0.75,"revivePieces":3,"reviveRows":2,
"revivesPerRun":1,"rounds":[{"isBoss":false,"pieces":14,"stones":0,"target":250},
{"isBoss":true,"pieces":22,"stones":6,"target":2000}],"traySize":3},
"jokers":["patience","twin","stonemason"],
"phase":{"kind":"playing","offers":null,"reason":null},"pickIndex":2,
"piecesLeft":11,"piecesRngState":3735928559,"revivesUsed":1,"roundIndex":1,
"runTotal":1870,"score":640,"seed":20261017,"stonesRngState":123456789,
"storedMult":6,"streak":3,"tray":[4,null,16]},"version":1}
""";

/// [_midRound] as the version 2 build wrote it, before the config named its
/// world. Frozen: never regenerate it from today's DTOs.
const _version2Save = """
{"day":20261017,"mode":"daily","run":{"board":[
-1,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,1,9,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,-1],
"config":{"chipsPerCell":20,"jokers":{"bigBoxFactor":15,"bigBoxMinPieceSize":9,
"collectorMultPerJoker":8,"columnFactor":11,"comboMultPerStreak":10,
"heavyFactor":12,"heavyMinPieceSize":5,"patienceStoredPerMove":16,
"pocketsExtraPieces":17,"precisionBonusMult":18,"precisionMaxPieceSize":4,
"quarryStonesPerClear":2,"saverPointsPerPiece":70,"stonemasonChipsPerStone":80,
"stonemasonExtraStones":7,"sweepBonus":900,"tinyFactor":14,"tinyMaxPieceSize":1,
"twinFactor":13,"twinMinLines":3},"offerCount":3,"partnerBias":0.75,
"revivePieces":3,"reviveRows":2,"revivesPerRun":1,
"rounds":[{"isBoss":false,"pieces":14,"stones":0,"target":250},
{"isBoss":true,"pieces":22,"stones":6,"target":2000}],"traySize":3},
"jokers":["patience","twin","stonemason"],
"phase":{"kind":"playing","offers":null,"reason":null},"pickIndex":2,
"piecesLeft":11,"piecesRngState":3735928559,"revivesUsed":1,"roundIndex":1,
"runTotal":1870,"score":640,"seed":20261017,"stonesRngState":123456789,
"storedMult":6,"streak":3,"tray":[4,null,16]},"version":2}
""";

/// [_midRound] as the version 3 build wrote it, before the config named its
/// joker pool or Anchor's and Avalanche's numbers. Frozen: never regenerate it
/// from today's DTOs.
const _version3Save = """
{"day":20261017,"mode":"daily","run":{"board":[
-1,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,1,9,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,-1],
"config":{"chipsPerCell":20,"jokers":{"bigBoxFactor":15,"bigBoxMinPieceSize":9,
"collectorMultPerJoker":8,"columnFactor":11,"comboMultPerStreak":10,
"heavyFactor":12,"heavyMinPieceSize":5,"patienceStoredPerMove":16,
"pocketsExtraPieces":17,"precisionBonusMult":18,"precisionMaxPieceSize":4,
"quarryStonesPerClear":2,"saverPointsPerPiece":70,"stonemasonChipsPerStone":80,
"stonemasonExtraStones":7,"sweepBonus":900,"tinyFactor":14,"tinyMaxPieceSize":1,
"twinFactor":13,"twinMinLines":3},"offerCount":3,"partnerBias":0.75,
"revivePieces":3,"reviveRows":2,"revivesPerRun":1,
"rounds":[{"isBoss":false,"pieces":14,"stones":0,"target":250},
{"isBoss":true,"pieces":22,"stones":6,"target":2000}],"traySize":3,
"world":"gravity"},
"jokers":["patience","twin","stonemason"],
"phase":{"kind":"playing","offers":null,"reason":null},"pickIndex":2,
"piecesLeft":11,"piecesRngState":3735928559,"revivesUsed":1,"roundIndex":1,
"runTotal":1870,"score":640,"seed":20261017,"stonesRngState":123456789,
"storedMult":6,"streak":3,"tray":[4,null,16]},"version":3}
""";

/// [_midRound] as the version 4 build wrote it, before the config named the
/// total that earns the third star. Frozen: never regenerate it from today's
/// DTOs.
const _version4Save = """
{"day":20261017,"mode":"daily","run":{"board":[
-1,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,1,9,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,-1],
"config":{"chipsPerCell":20,"jokerPool":["anchor","patience","twin","stonemason"],
"jokers":{"anchorMult":19,"avalancheChipsPerCell":21,"bigBoxFactor":15,
"bigBoxMinPieceSize":9,"collectorMultPerJoker":8,"columnFactor":11,
"comboMultPerStreak":10,"heavyFactor":12,"heavyMinPieceSize":5,
"patienceStoredPerMove":16,"pocketsExtraPieces":17,"precisionBonusMult":18,
"precisionMaxPieceSize":4,"quarryStonesPerClear":2,"saverPointsPerPiece":70,
"stonemasonChipsPerStone":80,"stonemasonExtraStones":7,"sweepBonus":900,
"tinyFactor":14,"tinyMaxPieceSize":1,"twinFactor":13,"twinMinLines":3},
"offerCount":3,"partnerBias":0.75,"revivePieces":3,"reviveRows":2,
"revivesPerRun":1,"rounds":[{"isBoss":false,"pieces":14,"stones":0,"target":250},
{"isBoss":true,"pieces":22,"stones":6,"target":2000}],"traySize":3,
"world":"gravity"},
"jokers":["patience","twin","stonemason"],
"phase":{"kind":"playing","offers":null,"reason":null},"pickIndex":2,
"piecesLeft":11,"piecesRngState":3735928559,"revivesUsed":1,"roundIndex":1,
"runTotal":1870,"score":640,"seed":20261017,"stonesRngState":123456789,
"storedMult":6,"streak":3,"tray":[4,null,16]},"version":4}
""";

/// [_midRound] as the version 5 build wrote it for practice, before world
/// runs named their world. Frozen: never regenerate it from today's DTOs.
const _version5PracticeSave = """
{"day":null,"mode":"practice","run":{"board":[
-1,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,1,9,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,-1],
"config":{"chipsPerCell":20,"jokerPool":["anchor","patience","twin","stonemason"],
"jokers":{"anchorMult":19,"avalancheChipsPerCell":21,"bigBoxFactor":15,
"bigBoxMinPieceSize":9,"collectorMultPerJoker":8,"columnFactor":11,
"comboMultPerStreak":10,"heavyFactor":12,"heavyMinPieceSize":5,
"patienceStoredPerMove":16,"pocketsExtraPieces":17,"precisionBonusMult":18,
"precisionMaxPieceSize":4,"quarryStonesPerClear":2,"saverPointsPerPiece":70,
"stonemasonChipsPerStone":80,"stonemasonExtraStones":7,"sweepBonus":900,
"tinyFactor":14,"tinyMaxPieceSize":1,"twinFactor":13,"twinMinLines":3},
"offerCount":3,"partnerBias":0.75,"revivePieces":3,"reviveRows":2,
"revivesPerRun":1,"rounds":[{"isBoss":false,"pieces":14,"stones":0,"target":250},
{"isBoss":true,"pieces":22,"stones":6,"target":2000}],"starThreshold":9500,
"traySize":3,"world":"gravity"},
"jokers":["patience","twin","stonemason"],
"phase":{"kind":"playing","offers":null,"reason":null},"pickIndex":2,
"piecesLeft":11,"piecesRngState":3735928559,"revivesUsed":1,"roundIndex":1,
"runTotal":1870,"score":640,"seed":20261017,"stonesRngState":123456789,
"storedMult":6,"streak":3,"tray":[4,null,16]},"version":5}
""";

/// [_midRound] as the version 6 build wrote it, before the stars' four jokers
/// and Hat Trick's tray. Frozen: never regenerate it from today's DTOs.
const _version6Save = """
{"day":20261017,"mode":"daily","run":{"board":[
-1,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,1,9,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,-1],
"config":{"chipsPerCell":20,"jokerPool":["anchor","patience","twin","stonemason"],
"jokers":{"anchorMult":19,"avalancheChipsPerCell":21,"bigBoxFactor":15,
"bigBoxMinPieceSize":9,"collectorMultPerJoker":8,"columnFactor":11,
"comboMultPerStreak":10,"heavyFactor":12,"heavyMinPieceSize":5,
"patienceStoredPerMove":16,"pocketsExtraPieces":17,"precisionBonusMult":18,
"precisionMaxPieceSize":4,"quarryStonesPerClear":2,"saverPointsPerPiece":70,
"stonemasonChipsPerStone":80,"stonemasonExtraStones":7,"sweepBonus":900,
"tinyFactor":14,"tinyMaxPieceSize":1,"twinFactor":13,"twinMinLines":3},
"offerCount":3,"partnerBias":0.75,"revivePieces":3,"reviveRows":2,
"revivesPerRun":1,"rounds":[{"isBoss":false,"pieces":14,"stones":0,"target":250},
{"isBoss":true,"pieces":22,"stones":6,"target":2000}],"starThreshold":9500,
"traySize":3,"world":"gravity"},
"jokers":["patience","twin","stonemason"],
"phase":{"kind":"playing","offers":null,"reason":null},"pickIndex":2,
"piecesLeft":11,"piecesRngState":3735928559,"revivesUsed":1,"roundIndex":1,
"runTotal":1870,"score":640,"seed":20261017,"stonesRngState":123456789,
"storedMult":6,"streak":3,"tray":[4,null,16]},"version":6}
""";

/// What version 7 fills in for a save from before it: the numbers and unlocks
/// it first shipped for the stars' jokers, and a tray that can't earn Hat
/// Trick.
RunState _beforeVersion7(RunState run) => _beforeVersion8(run).copyWith(
  config: _beforeVersion8(run).config.copyWith(
    jokers: _beforeVersion8(run).config.jokers.copyWith(
      brinkFactor: 2,
      brinkMinOccupied: 40,
      finisherFactor: 2,
      fullHouseCellsPerMult: 6,
      hatTrickBonus: 300,
    ),
    starUnlocks: const [
      StarUnlock(jokers: [.fullhouse, .brink], stars: 4),
      StarUnlock(jokers: [.finisher, .hattrick], stars: 6),
    ],
  ),
  trayClearMask: null,
);

/// What version 8 fills in for a save from before it: the two bottom rows
/// Avalanche counted and the +1 mult Full House added when they were
/// constants.
RunState _beforeVersion8(RunState run) => _beforeVersion9(run).copyWith(
  config: _beforeVersion9(run).config.copyWith(
    jokers: _beforeVersion9(
      run,
    ).config.jokers.copyWith(avalancheRows: 2, fullHouseMultPerBlock: 1),
  ),
);

/// What version 10 fills in for a save from before it: Ember's mult on every
/// clear, none.
RunState _beforeVersion10(RunState run) => run.copyWith(
  config: run.config.copyWith(jokers: run.config.jokers.copyWith(emberMult: 0)),
);

/// What version 9 fills in for a save from before it: the first numbers of
/// Fog, Tide and Mirror's jokers, no fog or tide in any round, no tray streak,
/// and the tray in hand read as dealt as it stands.
RunState _beforeVersion9(RunState run) => _beforeVersion10(run).copyWith(
  config: _beforeVersion10(run).config.copyWith(
    jokers: _beforeVersion10(run).config.jokers.copyWith(
      emberFactor: 2,
      momentumMultPerTray: 2,
      prismChipsPerPair: 15,
      sprinterMult: 5,
      symmetryMult: 4,
    ),
    rounds: [
      for (final round in _beforeVersion10(run).config.rounds)
        round.copyWith(fog: 0, fogStones: 0, tideGaps: 0),
    ],
  ),
  momentumStreak: 0,
  trayDealt: run.tray.whereType<int>().length,
);

/// The 14 jokers before version 4 added Anchor and Avalanche.
const _version3Pool = [
  JokerId.bigbox,
  JokerId.collector,
  JokerId.column,
  JokerId.combo,
  JokerId.heavy,
  JokerId.patience,
  JokerId.pockets,
  JokerId.precision,
  JokerId.quarry,
  JokerId.saver,
  JokerId.stonemason,
  JokerId.sweep,
  JokerId.tiny,
  JokerId.twin,
];

/// [run] as the next launch reads it: through JSON, the store's cache gone.
Future<SavedRun?> _relaunchedWith(SavedRun run) async {
  await const SharedPreferencesRunStore().save(run);
  final stored = await SharedPreferences.getInstance();
  SharedPreferences.setMockInitialValues({
    for (final key in stored.getKeys()) key: stored.get(key)!,
  });

  return const SharedPreferencesRunStore().load();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('a run mid-round comes back exactly as it was saved', () async {
    // Given
    final saved = SavedRun(mode: const .daily(day: 20261017), run: _midRound);

    // When
    final loaded = await _relaunchedWith(saved);

    // Then
    expect(loaded, saved);
  });

  test('a board with fog comes back with what each fog cell hides', () async {
    // Given
    final saved = SavedRun(
      mode: const .world(world: .fog),
      run: _midRound.copyWith(
        board: _midRound.board.withCells({
          const Cell(col: 5, row: 5): const .fog(hidesStone: false),
          const Cell(col: 6, row: 5): const .fog(hidesStone: true),
        }),
      ),
    );

    // When
    final loaded = await _relaunchedWith(saved);

    // Then
    expect(loaded, saved);
  });

  for (final phase in const [
    RunPhase.pickingJoker(offers: [.combo, .saver, .quarry]),
    RunPhase.roundLost(reason: .noRoom),
    RunPhase.roundLost(reason: .outOfPieces),
  ]) {
    test('a practice run saved at $phase comes back the same', () async {
      // Given
      final saved = SavedRun(
        mode: const .practice(),
        run: _midRound.copyWith(phase: phase),
      );

      // When
      final loaded = await _relaunchedWith(saved);

      // Then
      expect(loaded, saved);
    });
  }

  test('a world run comes back as the run of its world', () async {
    // Given
    final saved = SavedRun(
      mode: const .world(world: .gravity),
      run: _midRound,
    );

    // When
    final loaded = await _relaunchedWith(saved);

    // Then
    expect(loaded, saved);
  });

  test('nothing is resumed before a run has been saved', () async {
    expect(await const SharedPreferencesRunStore().load(), isNull);
  });

  test('a cleared run is not resumed', () async {
    // Given
    const store = SharedPreferencesRunStore();
    await store.save(SavedRun(mode: const .practice(), run: _midRound));

    // When
    await store.clear();

    // Then
    expect(await store.load(), isNull);
  });

  test('the save names its schema version', () async {
    // Given / When
    await const SharedPreferencesRunStore().save(
      SavedRun(mode: const .practice(), run: _midRound),
    );

    // Then
    final raw = (await SharedPreferences.getInstance()).getString('run.saved');
    expect((jsonDecode(raw!) as Map<String, dynamic>)['version'], 11);
  });

  for (final (name, raw) in [
    ('is not JSON', 'not json'),
    (
      'comes from an unknown version',
      () {
        final json = SavedRunDto.fromDomain(
          SavedRun(mode: const .practice(), run: _midRound),
        ).toJson()..['version'] = savedRunVersion + 1;

        return jsonEncode(json);
      }(),
    ),
    (
      'names a joker this build lacks',
      () {
        final json = SavedRunDto.fromDomain(
          SavedRun(mode: const .practice(), run: _midRound),
        ).toJson();
        (json['run'] as Map<String, dynamic>)['jokers'] = ['wildcard'];

        return jsonEncode(json);
      }(),
    ),
    (
      'offers a joker this build lacks',
      () {
        final json = SavedRunDto.fromDomain(
          SavedRun(mode: const .practice(), run: _midRound),
        ).toJson();
        final run = json['run'] as Map<String, dynamic>;
        (run['config'] as Map<String, dynamic>)['jokerPool'] = ['wildcard'];

        return jsonEncode(json);
      }(),
    ),
    (
      'names a world this build lacks',
      () {
        final json = SavedRunDto.fromDomain(
          SavedRun(mode: const .practice(), run: _midRound),
        ).toJson();
        final run = json['run'] as Map<String, dynamic>;
        (run['config'] as Map<String, dynamic>)['world'] = 'atlantis';

        return jsonEncode(json);
      }(),
    ),
  ]) {
    test('a save that $name is treated as no save', () async {
      // Given
      SharedPreferences.setMockInitialValues({'run.saved': raw});

      // When
      final loaded = await const SharedPreferencesRunStore().load();

      // Then
      expect(loaded, isNull);
    });
  }

  test('a save naming no version cannot be migrated', () {
    expect(() => migrate({'mode': 'practice'}), throwsFormatException);
  });

  test(
    'a save from version 1 resumes with the numbers it was played with',
    () async {
      // Given
      SharedPreferences.setMockInitialValues({'run.saved': _version1Save});

      // When
      final loaded = await const SharedPreferencesRunStore().load();

      // Then
      expect(loaded?.run.config.chipsPerCell, 10);
      expect(loaded?.run.config.jokers, _version1Tuning);
      expect(
        loaded,
        SavedRun(
          mode: const .daily(day: 20261017),
          run: _beforeVersion7(
            _midRound.copyWith(
              config: _config.copyWith(
                chipsPerCell: 10,
                jokerPool: _version3Pool,
                jokers: _version1Tuning,
                starThreshold: 8000,
                world: .rubble,
              ),
            ),
          ),
        ),
      );
    },
  );

  test(
    'a save from version 2 resumes in Rubble, the only world it had',
    () async {
      // Given
      SharedPreferences.setMockInitialValues({'run.saved': _version2Save});

      // When
      final loaded = await const SharedPreferencesRunStore().load();

      // Then
      expect(loaded?.run.config.world, WorldId.rubble);
      expect(
        loaded,
        SavedRun(
          mode: const .daily(day: 20261017),
          run: _beforeVersion7(
            _midRound.copyWith(
              config: _config.copyWith(
                jokerPool: _version3Pool,
                jokers: _tuning.copyWith(
                  anchorMult: 4,
                  avalancheChipsPerCell: 25,
                ),
                starThreshold: 8000,
                world: .rubble,
              ),
            ),
          ),
        ),
      );
    },
  );

  test(
    'a save from version 3 resumes offering the 14 jokers it drew from',
    () async {
      // Given
      SharedPreferences.setMockInitialValues({'run.saved': _version3Save});

      // When
      final loaded = await const SharedPreferencesRunStore().load();

      // Then
      expect(loaded?.run.config.jokerPool, _version3Pool);
      expect(
        loaded,
        SavedRun(
          mode: const .daily(day: 20261017),
          run: _beforeVersion7(
            _midRound.copyWith(
              config: _config.copyWith(
                jokerPool: _version3Pool,
                jokers: _tuning.copyWith(
                  anchorMult: 4,
                  avalancheChipsPerCell: 25,
                ),
                starThreshold: 8250,
              ),
            ),
          ),
        ),
      );
    },
  );

  for (final (world, starThreshold) in const [
    ('gravity', 8250),
    ('rubble', 8000),
  ]) {
    test(
      'a save from version 4 in $world resumes with the star threshold version 5 gave it',
      () async {
        // Given
        SharedPreferences.setMockInitialValues({
          'run.saved': _version4Save.replaceFirst(
            '"world":"gravity"',
            '"world":"$world"',
          ),
        });

        // When
        final loaded = await const SharedPreferencesRunStore().load();

        // Then
        expect(
          loaded,
          SavedRun(
            mode: const .daily(day: 20261017),
            run: _beforeVersion7(
              _midRound.copyWith(
                config: _config.copyWith(
                  starThreshold: starThreshold,
                  world: WorldId.values.byName(world),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  test('a practice run saved by version 5 resumes as practice', () async {
    // Given
    SharedPreferences.setMockInitialValues({
      'run.saved': _version5PracticeSave,
    });

    // When
    final loaded = await const SharedPreferencesRunStore().load();

    // Then
    expect(
      loaded,
      SavedRun(mode: const .practice(), run: _beforeVersion7(_midRound)),
    );
  });

  test(
    "a save from version 6 resumes with today's star unlocks, its tray unable "
    'to earn Hat Trick',
    () async {
      // Given
      SharedPreferences.setMockInitialValues({'run.saved': _version6Save});

      // When
      final loaded = await const SharedPreferencesRunStore().load();

      // Then
      expect(loaded?.run.trayClearMask, isNull);
      expect(loaded?.run.config.jokerPool, _config.jokerPool);
      expect(
        loaded,
        SavedRun(
          mode: const .daily(day: 20261017),
          run: _beforeVersion7(_midRound),
        ),
      );
    },
  );

  test(
    "a save from version 7 resumes with Avalanche's two rows and Full House's "
    '+1 mult',
    () async {
      // Given: today's save as version 7 wrote it, without the two numbers
      final json = SavedRunDto.fromDomain(
        SavedRun(mode: const .daily(day: 20261017), run: _midRound),
      ).toJson()..['version'] = 7;
      final config =
          (json['run'] as Map<String, dynamic>)['config']
              as Map<String, dynamic>;
      (config['jokers'] as Map<String, dynamic>)
        ..remove('avalancheRows')
        ..remove('fullHouseMultPerBlock');
      SharedPreferences.setMockInitialValues({'run.saved': jsonEncode(json)});

      // When
      final loaded = await const SharedPreferencesRunStore().load();

      // Then
      expect(
        loaded,
        SavedRun(
          mode: const .daily(day: 20261017),
          run: _beforeVersion8(_midRound),
        ),
      );
    },
  );

  test('a save from version 10 resumes with the mastery tiers version 11 first '
      'shipped', () async {
    // Given: today's save as version 10 wrote it, without mastery
    final json = SavedRunDto.fromDomain(
      SavedRun(mode: const .daily(day: 20261017), run: _midRound),
    ).toJson()..['version'] = 10;
    ((json['run'] as Map<String, dynamic>)['config'] as Map<String, dynamic>)
        .remove('mastery');
    SharedPreferences.setMockInitialValues({'run.saved': jsonEncode(json)});

    // When
    final loaded = await const SharedPreferencesRunStore().load();

    // Then
    expect(
      loaded?.run.config.mastery,
      const MasteryThresholds(bronze: 1, gold: 15, silver: 5),
    );
    expect(
      loaded?.run.config.copyWith(mastery: _config.mastery),
      _midRound.config,
    );
  });

  test("a save from version 9 resumes with Ember's old rule, no mult on every "
      'clear', () async {
    // Given: today's save as version 9 wrote it, without Ember's mult
    final json = SavedRunDto.fromDomain(
      SavedRun(mode: const .daily(day: 20261017), run: _midRound),
    ).toJson()..['version'] = 9;
    final config =
        (json['run'] as Map<String, dynamic>)['config'] as Map<String, dynamic>;
    (config['jokers'] as Map<String, dynamic>).remove('emberMult');
    SharedPreferences.setMockInitialValues({'run.saved': jsonEncode(json)});

    // When
    final loaded = await const SharedPreferencesRunStore().load();

    // Then
    expect(
      loaded,
      SavedRun(
        mode: const .daily(day: 20261017),
        run: _beforeVersion10(_midRound),
      ),
    );
  });

  test(
    "a save from version 8 resumes with no fog, no tide and no tray streak",
    () async {
      // Given: today's save as version 8 wrote it, without version 9's fields
      final json = SavedRunDto.fromDomain(
        SavedRun(mode: const .daily(day: 20261017), run: _midRound),
      ).toJson()..['version'] = 8;
      final run = json['run'] as Map<String, dynamic>;
      final config = run['config'] as Map<String, dynamic>;
      run
        ..remove('momentumStreak')
        ..remove('trayDealt');
      (config['jokers'] as Map<String, dynamic>)
        ..remove('emberFactor')
        ..remove('momentumMultPerTray')
        ..remove('prismChipsPerPair')
        ..remove('sprinterMult')
        ..remove('symmetryMult');
      for (final round in config['rounds'] as List<dynamic>) {
        (round as Map<String, dynamic>)
          ..remove('fog')
          ..remove('fogStones')
          ..remove('tideGaps');
      }
      SharedPreferences.setMockInitialValues({'run.saved': jsonEncode(json)});

      // When
      final loaded = await const SharedPreferencesRunStore().load();

      // Then
      expect(
        loaded,
        SavedRun(
          mode: const .daily(day: 20261017),
          run: _beforeVersion9(_midRound),
        ),
      );
    },
  );

  test('a save of the current version passes through migrate unchanged', () {
    // Given
    final json = SavedRunDto.fromDomain(
      SavedRun(mode: const .practice(), run: _midRound),
    ).toJson();

    // When / Then
    expect(migrate(json), same(json));
  });
}
