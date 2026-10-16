import 'package:blockmancer_engine/blockmancer_engine.dart';
import 'package:test/test.dart';

import '../play_move.dart';

void main() {
  test(
    'a move that clears nothing scores the piece size and resets the streak',
    () {
      // Given / When
      final score = playMove(
        const [],
        at: topLeft,
        previousStreak: 3,
        shape: 9,
      );

      // Then
      expect(score.points, 4);
      expect((score.chips, score.mult), (0, 0));
      expect(score.streak, 0);
      expect(score.fired, isEmpty);
    },
  );

  test('one line scores 10 chips per cell times 1 mult, plus the piece', () {
    // Given / When
    final score = playMove(rowAlmostFull, at: topRight, shape: 0);

    // Then
    expect((score.chips, score.mult), (80, 1));
    expect(score.points, 1 + 80);
    expect(score.streak, 1);
  });

  test('a row and a column at once score their 15 distinct cells times 2', () {
    // Given / When
    final score = playMove(crossAlmostFull, at: topLeft, shape: 0);

    // Then
    expect((score.chips, score.mult), (150, 2));
    expect(score.points, 1 + 300);
  });

  test('a clear after a clear extends the streak', () {
    // Given / When
    final score = playMove(
      rowAlmostFull,
      at: topRight,
      previousStreak: 2,
      shape: 0,
    );

    // Then
    expect(score.streak, 3);
  });

  test('additive effects apply before multiplicative ones', () {
    // Given: Combo King adds 1 on a streak of 2, Twin Lines triples 2 lines
    // When
    final score = playMove(
      crossAlmostFull,
      at: topLeft,
      jokers: const [.twin, .combo],
      previousStreak: 1,
      shape: 0,
    );

    // Then: (2 + 1) × 3, not 2 × 3 + 1
    expect(score.mult, 9);
    expect(score.points, 1 + 150 * 9);
    expect(score.fired.map((fired) => fired.joker), [
      JokerId.combo,
      JokerId.twin,
    ]);
  });
}
