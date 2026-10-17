import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_domain/src/behaviors/clear_progress_behavior.dart';

import '../fakes.dart';

void main() {
  test('the bests and the saved run are both forgotten', () async {
    // Given
    final scores = FakeBestScores()..saved[const GameMode.practice()] = 3100;
    final store = FakeRunStore()..saved = savedIn(const .playing());

    // When
    await ClearProgressBehavior(scores: scores, store: store)();

    // Then
    expect(scores.saved, isEmpty);
    expect(store.saved, isNull);
  });
}
