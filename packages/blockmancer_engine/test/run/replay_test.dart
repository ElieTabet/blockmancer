import 'package:blockmancer_engine/src/run/default_config.dart';
import 'package:blockmancer_engine/src/run/replay.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

import '../autoplay.dart';

void main() {
  for (final (seed, build) in const [
    (20261016, [JokerId.patience, JokerId.twin]),
    (7, [JokerId.combo, JokerId.collector]),
    (42, [JokerId.heavy, JokerId.bigbox]),
  ]) {
    test('a run built on ${build.map((joker) => joker.name).join(' + ')} '
        'replays from its seed and moves to the same end', () {
      // Given
      final played = autoplay(seed, build: build);

      // When
      final replayed = replay(
        config: defaultConfig,
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

  test('a move the run could not have made is refused', () {
    // Given
    final played = autoplay(7);
    final tampered = [
      ...played.moves.take(1),
      const RunMove.place(anchor: Cell(col: 8, row: 8), trayIndex: 0),
    ];

    // When / Then
    expect(
      () => replay(config: defaultConfig, moves: tampered, seed: 7),
      throwsArgumentError,
    );
  });
}
