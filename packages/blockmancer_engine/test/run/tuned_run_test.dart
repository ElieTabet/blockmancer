import 'package:blockmancer_engine/src/run/default_config.dart';
import 'package:blockmancer_engine/src/run/engine.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

import '../board_picture.dart';
import '../play_move.dart';
import '../tuned_config.dart';

const _seed = 20261016;

/// A run under [config] in its first round, having started with [joker].
RunState _playing(
  JokerId joker, {
  required RunConfig config,
  int seed = _seed,
}) {
  final start = startRun(config: config, seed: seed);

  return pickJoker(
    start.copyWith(phase: .pickingJoker(offers: [joker])),
    id: joker,
  ).$1;
}

void main() {
  test('a round starts with Deep Pockets\' configured extra pieces', () {
    // Given
    final start = startRun(
      config: tunedConfig,
      seed: _seed,
    ).copyWith(phase: const .pickingJoker(offers: [.pockets]));

    // When
    final (state, events) = pickJoker(start, id: .pockets);

    // Then
    expect(
      events.first,
      const GameEvent.roundStarted(pieces: 14 + 17, roundIndex: 0, target: 250),
    );
    expect(state.piecesLeft, 14 + 17 - 3);
  });

  test('the tray is drawn with Tiny Tools\' configured weights', () {
    // Given
    double singlesShare(RunConfig config) {
      final drawn = [
        for (var seed = 1; seed <= 200; seed++)
          ..._playing(.tiny, config: config, seed: seed).tray,
      ];

      return drawn.where((id) => id == 0).length / drawn.length;
    }

    // When
    final tuned = singlesShare(tunedConfig);
    final untuned = singlesShare(defaultConfig);

    // Then: a single weighs 14 of 32 tuned, 3 of 25 by default
    expect(tuned, greaterThan(0.3));
    expect(untuned, lessThan(0.2));
  });

  test('winning a round banks Saver\'s configured points per unused piece', () {
    // Given: 161 points short of the target, five pieces still to draw
    final state = _playing(.saver, config: tunedConfig).copyWith(
      board: boardFrom(rowAlmostFull),
      piecesLeft: 5,
      score: 250 - 161,
      tray: [0, null, null],
    );

    // When
    final (won, events) = place(state, anchor: topRight, trayIndex: 0);

    // Then
    expect(
      events,
      contains(
        const GameEvent.roundWon(bonus: 5 * 70, roundIndex: 0, score: 250),
      ),
    );
    expect(won.runTotal, 250 + 350);
  });
}
