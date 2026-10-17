import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:game_data/game_data.dart';
import 'package:game_data/src/dtos/saved_run_dto.br.dart';
import 'package:game_domain/game_domain.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _config = RunConfig(
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
    expect((jsonDecode(raw!) as Map<String, dynamic>)['version'], 1);
  });

  for (final (name, raw) in [
    ('is not JSON', 'not json'),
    (
      'comes from an unknown version',
      () {
        final json = SavedRunDto.fromDomain(
          SavedRun(mode: const .practice(), run: _midRound),
        ).toJson()..['version'] = 2;

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

  test('a version 1 save passes through migrate unchanged', () {
    // Given
    final json = SavedRunDto.fromDomain(
      SavedRun(mode: const .practice(), run: _midRound),
    ).toJson();

    // When / Then
    expect(migrate(json), same(json));
  });
}
