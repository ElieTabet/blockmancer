import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:game_data/game_data.dart';
import 'package:game_data/src/dtos/saved_run_dto.br.dart';
import 'package:game_domain/game_domain.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The numbers version 1 played with, when they were constants of the build,
/// and the defaults version 4 gave the jokers it added.
const _version1Tuning = JokerTuning(
  anchorMult: 4,
  avalancheChipsPerCell: 25,
  bigBoxFactor: 3,
  bigBoxMinPieceSize: 5,
  collectorMultPerJoker: 1,
  columnFactor: 2,
  comboMultPerStreak: 1,
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
);

/// Every joker number distinct and off its default, so a field the DTO drops
/// or swaps shows up.
const _tuning = JokerTuning(
  anchorMult: 19,
  avalancheChipsPerCell: 21,
  bigBoxFactor: 15,
  bigBoxMinPieceSize: 9,
  collectorMultPerJoker: 8,
  columnFactor: 11,
  comboMultPerStreak: 10,
  heavyFactor: 12,
  heavyMinPieceSize: 5,
  patienceStoredPerMove: 16,
  pocketsExtraPieces: 17,
  precisionBonusMult: 18,
  precisionMaxPieceSize: 4,
  quarryStonesPerClear: 2,
  saverPointsPerPiece: 70,
  stonemasonChipsPerStone: 80,
  stonemasonExtraStones: 7,
  sweepBonus: 900,
  tinyFactor: 14,
  tinyMaxPieceSize: 1,
  twinFactor: 13,
  twinMinLines: 3,
);

const _config = RunConfig(
  chipsPerCell: 20,
  jokerPool: [.anchor, .patience, .twin, .stonemason],
  jokers: _tuning,
  offerCount: 3,
  partnerBias: 0.75,
  revivePieces: 3,
  reviveRows: 2,
  revivesPerRun: 1,
  rounds: [
    RoundSpec(isBoss: false, pieces: 14, stones: 0, target: 250),
    RoundSpec(isBoss: true, pieces: 22, stones: 6, target: 2000),
  ],
  traySize: 3,
  world: .gravity,
);

/// Mid-round in the boss: stones and pieces on the board, a stored Patience
/// bank, a streak going, one revive spent and a tray slot already played.
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
    expect((jsonDecode(raw!) as Map<String, dynamic>)['version'], 4);
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
          run: _midRound.copyWith(
            config: _config.copyWith(
              chipsPerCell: 10,
              jokerPool: _version3Pool,
              jokers: _version1Tuning,
              world: .rubble,
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
          run: _midRound.copyWith(
            config: _config.copyWith(
              jokerPool: _version3Pool,
              jokers: _tuning.copyWith(
                anchorMult: 4,
                avalancheChipsPerCell: 25,
              ),
              world: .rubble,
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
          run: _midRound.copyWith(
            config: _config.copyWith(
              jokerPool: _version3Pool,
              jokers: _tuning.copyWith(
                anchorMult: 4,
                avalancheChipsPerCell: 25,
              ),
            ),
          ),
        ),
      );
    },
  );

  test('a version 4 save passes through migrate unchanged', () {
    // Given
    final json = SavedRunDto.fromDomain(
      SavedRun(mode: const .practice(), run: _midRound),
    ).toJson();

    // When / Then
    expect(migrate(json), same(json));
  });
}
