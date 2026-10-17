import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

import '../autoplay.dart';

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

  test('the daily run of 20261016 is won the same way every time', () {
    // Given / When
    final (:events, moves: _, :state) = autoplay(20261016);

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

  test('seed 4 revives once, loses again in round 2 and ends there', () {
    // Given / When
    final (:events, moves: _, :state) = autoplay(4);

    // Then
    expect(state.phase, const RunPhase.over());
    expect(state.roundIndex, 1);
    expect(state.runTotal, 1045);
    expect(state.revivesUsed, 1);
    expect(events.whereType<Revived>(), hasLength(1));
    expect(events.last, const GameEvent.runOver(total: 1045));
  });
}
