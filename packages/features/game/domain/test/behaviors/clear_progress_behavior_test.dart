import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_domain/src/behaviors/clear_progress_behavior.dart';

import '../fake_progression_store.dart';
import '../fakes.dart';

void main() {
  test('the bests, the saved run and the map are all forgotten', () async {
    // Given: a player who has beaten Rubble's boss
    final starting = startingProgression(const TwoWorldRules());
    final progression = FakeProgressionStore()
      ..saved = starting.copyWith(tutorialDone: true, unlockedJokers: {});
    final scores = FakeBestScores()..saved[const GameMode.practice()] = 3100;
    final store = FakeRunStore()..saved = savedIn(const .playing());

    // When
    await ClearProgressBehavior(
      progression: progression,
      scores: scores,
      startingProgression: starting,
      store: store,
    )();

    // Then
    expect(scores.saved, isEmpty);
    expect(store.saved, isNull);
    expect(progression.saved, starting);
  });
}
