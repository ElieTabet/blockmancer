import 'package:blockmancer_engine/src/run/default_config.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

import '../autoplay.dart';

/// The 14 jokers there were before Gravity's. New jokers join the end of the
/// draw order, so a run offering only these plays exactly as it did then.
final _before = defaultConfig.copyWith(
  jokerPool: const [
    .bigbox,
    .collector,
    .column,
    .combo,
    .heavy,
    .patience,
    .pockets,
    .precision,
    .quarry,
    .saver,
    .stonemason,
    .sweep,
    .tiny,
    .twin,
  ],
);

void main() {
  test('a seeded run plays to its end and replays identically', () {
    // Given
    const seed = 20261016;

    // When
    final first = autoplay(seed);
    final again = autoplay(seed);

    // Then
    expect(again.state, first.state);
    expect(again.events, first.events);
    expect(
      first.state.phase,
      anyOf(const RunPhase.won(), const RunPhase.over()),
    );
  });

  test('the run of 20261016 with every joker opens on Anchor and Avalanche, '
      'and ends in round 2', () {
    // Given / When
    final (events: _, moves: _, :state) = autoplay(20261016);

    // Then
    expect(state.phase, const RunPhase.over());
    expect(state.roundIndex, 1);
    expect(state.runTotal, 770);
    expect(state.jokers, const [JokerId.anchor, JokerId.avalanche]);
  });

  test('the run of 20261016 with the jokers before Gravity\'s '
      'is won the same way as ever', () {
    // Given / When
    final (:events, moves: _, :state) = autoplay(20261016, config: _before);

    // Then
    expect(state.phase, const RunPhase.won());
    expect(state.runTotal, 6850);
    expect(state.jokers, const [
      JokerId.pockets,
      JokerId.saver,
      JokerId.collector,
      JokerId.combo,
      JokerId.tiny,
    ]);
    expect(events.whereType<RoundWon>(), hasLength(5));
  });

  test('with the jokers before Gravity\'s, seed 4 still revives once, loses '
      'again in round 2 and ends there', () {
    // Given / When
    final (:events, moves: _, :state) = autoplay(4, config: _before);

    // Then
    expect(state.phase, const RunPhase.over());
    expect(state.roundIndex, 1);
    expect(state.runTotal, 1045);
    expect(state.revivesUsed, 1);
    expect(events.whereType<Revived>(), hasLength(1));
    expect(events.last, const GameEvent.runOver(total: 1045));
  });
}
