import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_domain/src/behaviors/clear_progress_behavior.dart';
import 'package:game_domain/src/behaviors/record_progression_behavior.dart';
import 'package:shared_domain/shared_domain.dart';

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

  test("reset progress clears the stars' jokers, and a run after it does not "
      'bring them back', () async {
    // Given: every star held, all four of the stars' jokers unlocked
    const allStars = WorldStars(
      bossBeaten: true,
      noRevive: true,
      scoreThreshold: true,
    );
    final starting = startingProgression(const TwoWorldRules());
    final progression = FakeProgressionStore()
      ..saved = starting.copyWith(
        unlockedJokers: {
          ...starting.unlockedJokers,
          .fullhouse,
          .brink,
          .finisher,
          .hattrick,
        },
        worlds: {
          for (final world in const [WorldId.rubble, WorldId.gravity])
            world: const WorldProgress(
              bossBeaten: true,
              stars: allStars,
              unlocked: true,
            ),
        },
      );

    // When: progress is reset, then a Rubble run earns nothing
    await ClearProgressBehavior(
      progression: progression,
      scores: FakeBestScores(),
      startingProgression: starting,
      store: FakeRunStore(),
    )();
    await RecordProgressionBehavior(
      rules: const TwoWorldRules(),
      store: progression,
    )(const .world(world: .rubble), runIn(const .over()));

    // Then
    expect(
      progression.saved.unlockedJokers.intersection(const {
        JokerId.fullhouse,
        JokerId.brink,
        JokerId.finisher,
        JokerId.hattrick,
      }),
      isEmpty,
    );
  });
}
