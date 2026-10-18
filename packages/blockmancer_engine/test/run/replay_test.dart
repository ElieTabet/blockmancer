import 'package:blockmancer_engine/src/run/replay.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

import '../autoplay.dart';
import '../brief_config.dart';

void main() {
  // Each seed's bot gets to take a joker of its build.
  for (final (seed, build) in const [
    (1, [JokerId.patience, JokerId.twin]),
    (7, [JokerId.combo, JokerId.collector]),
    (5, [JokerId.heavy, JokerId.bigbox]),
  ]) {
    test('a run built on ${build.map((joker) => joker.name).join(' + ')} '
        'replays from its seed and moves to the same end', () {
      // Given
      final played = autoplay(seed, build: build, config: briefConfigBeforeFog);

      // When
      final replayed = replay(
        config: briefConfigBeforeFog,
        moves: played.moves,
        seed: seed,
      );

      // Then
      expect(replayed, played.state);
      expect(replayed.runTotal, played.state.runTotal);
      expect(
        played.state.jokers.toSet().intersection(build.toSet()),
        isNotEmpty,
      );
    });
  }

  test('a run offering only part of the jokers replays to the same end', () {
    // Given
    final config = briefConfig.copyWith(
      jokerPool: const [.collector, .combo, .patience, .twin],
    );
    final played = autoplay(7, config: config);

    // When
    final replayed = replay(config: config, moves: played.moves, seed: 7);

    // Then
    expect(replayed, played.state);
    expect(
      played.state.jokers.toSet().difference(config.jokerPool.toSet()),
      isEmpty,
    );
  });

  test('a move the run could not have made is refused', () {
    // Given
    final played = autoplay(7);
    final tampered = [
      ...played.moves.take(1),
      const RunMove.place(anchor: Cell(col: 8, row: 8), trayIndex: 0),
    ];

    // When / Then
    expect(
      () => replay(config: briefConfig, moves: tampered, seed: 7),
      throwsArgumentError,
    );
  });
}
