import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_domain/src/behaviors/record_run_end_behavior.dart';

import '../fake_best_scores.dart';

const _today = GameMode.daily(day: 20261017);

void main() {
  test("a mode's first finished run is its best", () async {
    // Given
    final scores = FakeBestScores();

    // When
    final record = await RecordRunEndBehavior(scores: scores)(_today, 1200);

    // Then
    expect(record, const RunEndRecord(best: 1200, isNewBest: true));
    expect(scores.saved[_today], 1200);
  });

  test('a run equalling the best is not a new best', () async {
    // Given
    final scores = FakeBestScores()..saved[_today] = 1500;

    // When
    final record = await RecordRunEndBehavior(scores: scores)(_today, 1500);

    // Then
    expect(record, const RunEndRecord(best: 1500, isNewBest: false));
    expect(scores.saved[_today], 1500);
  });

  test('a run short of the best leaves it standing', () async {
    // Given
    final scores = FakeBestScores()..saved[_today] = 1500;

    // When
    final record = await RecordRunEndBehavior(scores: scores)(_today, 900);

    // Then
    expect(record, const RunEndRecord(best: 1500, isNewBest: false));
    expect(scores.saved[_today], 1500);
  });

  test("each day's daily run and practice keep their own best", () async {
    // Given
    final scores = FakeBestScores()
      ..saved[_today] = 3000
      ..saved[const GameMode.practice()] = 4000;

    // When
    final tomorrow = await RecordRunEndBehavior(scores: scores)(
      const GameMode.daily(day: 20261018),
      900,
    );

    // Then
    expect(tomorrow, const RunEndRecord(best: 900, isNewBest: true));
    expect(scores.saved[_today], 3000);
    expect(scores.saved[const GameMode.practice()], 4000);
  });
}
