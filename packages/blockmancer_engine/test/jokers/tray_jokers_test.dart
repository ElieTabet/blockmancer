import 'package:blockmancer_engine/src/run/engine.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

import '../board_picture.dart';
import '../brief_config.dart';
import '../play_move.dart';

/// Round 1 under way on a board whose top row a single completes, owning
/// [jokers], [played] singles of a 3-piece tray already played.
RunState _round1({
  required List<JokerId> jokers,
  int momentumStreak = 0,
  int played = 0,
}) {
  final start = startRun(config: briefConfig, seed: 20261016);
  final (round, _) = pickJoker(
    start.copyWith(phase: const .pickingJoker(offers: [.twin])),
    id: .twin,
  );

  return round.copyWith(
    board: boardFrom(rowAlmostFull),
    jokers: jokers,
    momentumStreak: momentumStreak,
    tray: [for (var slot = 0; slot < 3; slot++) slot < played ? null : 0],
    trayDealt: 3,
  );
}

/// The move's mult, and the jokers that fired, when [state]'s next single is
/// played at [at].
(int, List<JokerFired>, RunState) _play(RunState state, {Cell at = topRight}) {
  final slot = state.tray.indexWhere((piece) => piece != null);
  final (next, events) = place(state, anchor: at, trayIndex: slot);

  return (
    events.whereType<ScoreAdded>().single.mult,
    events.whereType<JokerFired>().toList(),
    next,
  );
}

void main() {
  group('Sprinter', () {
    test('adds 5 mult when a fresh tray\'s first piece clears a line', () {
      // Given / When
      final (mult, fired, _) = _play(_round1(jokers: const [.sprinter]));

      // Then
      expect(mult, 1 + 5);
      expect(fired, const [
        JokerFired(delta: .multAdded(amount: 5), joker: .sprinter),
      ]);
    });

    test('stays quiet for a later piece of the tray', () {
      // Given / When
      final (mult, fired, _) = _play(
        _round1(jokers: const [.sprinter], played: 1),
      );

      // Then
      expect(mult, 1);
      expect(fired, isEmpty);
    });
  });

  group('Momentum', () {
    test('adds 2 mult per tray in a row whose first piece cleared, this one '
        'included', () {
      // Given: the tray before this one opened with a clear
      final state = _round1(jokers: const [.momentum], momentumStreak: 1);

      // When
      final (mult, _, next) = _play(state);

      // Then
      expect(mult, 1 + 2 * 2);
      expect(next.momentumStreak, 2);
    });

    test('goes on adding for the tray\'s later clears', () {
      // Given / When
      final (mult, _, _) = _play(
        _round1(jokers: const [.momentum], momentumStreak: 2, played: 1),
      );

      // Then
      expect(mult, 1 + 2 * 2);
    });

    test('drops to nothing for the rest of a tray whose first piece cleared '
        'nothing', () {
      // Given: a streak of 3 trays
      final state = _round1(jokers: const [.momentum], momentumStreak: 3);

      // When: the first single misses the row, the second completes it
      final (_, _, missed) = _play(state, at: const Cell(col: 0, row: 4));
      final (mult, fired, after) = _play(missed);

      // Then
      expect(missed.momentumStreak, 0);
      expect(mult, 1);
      expect(fired, isEmpty);
      expect(after.momentumStreak, 0);
    });

    test('starts every round from nothing', () {
      // Given
      final picking = _round1(
        jokers: const [.momentum],
        momentumStreak: 4,
      ).copyWith(phase: const .pickingJoker(offers: [.combo]));

      // When
      final (round2, _) = pickJoker(picking, id: .combo);

      // Then
      expect(round2.momentumStreak, 0);
    });
  });

  test(
    'Sprinter with Momentum, a fresh tray opening with a clear earns both',
    () {
      // Given / When: no streak before this tray
      final (mult, fired, _) = _play(
        _round1(jokers: const [.sprinter, .momentum]),
      );

      // Then: Sprinter's 5, then Momentum's 2 for a streak of 1
      expect(mult, 1 + 5 + 2);
      expect(fired.map((event) => event.joker), [
        JokerId.sprinter,
        JokerId.momentum,
      ]);
    },
  );
}
