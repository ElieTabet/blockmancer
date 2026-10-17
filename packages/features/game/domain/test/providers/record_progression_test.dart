import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_progression_store.dart';
import '../fakes.dart';

void main() {
  /// The game over a fresh profile, its progression shown.
  ProviderContainer freshGame() {
    final store = FakeProgressionStore()
      ..saved = startingProgression(const TwoWorldRules());
    final container = ProviderContainer(
      overrides: bindProviders(
        analyticsSink: (ref) => FakeAnalyticsSink(),
        bestScores: (ref) => FakeBestScores(),
        clock: (ref) => FakeClock(DateTime.utc(2026, 10, 17, 12)),
        gameRules: (ref) => const TwoWorldRules(),
        progressionStore: (ref) => store,
        runStore: (ref) => FakeRunStore(),
      ),
    );
    addTearDown(container.dispose);
    container.listen(progressionProvider, (_, _) {});

    return container;
  }

  test('what a world run earns is what the progression shows next', () async {
    // Given: the progression shown from a fresh profile
    final container = freshGame();
    expect((await container.read(progressionProvider.future)).unlockedJokers, {
      JokerId.patience,
      JokerId.twin,
    });

    // When: Rubble's boss is beaten
    await container.read(recordProgressionProvider)(
      const .world(world: .rubble),
      runIn(const .won()),
    );

    // Then
    final shown = await container.read(progressionProvider.future);
    expect(shown.worlds[WorldId.gravity]?.unlocked, isTrue);
    expect(shown.unlockedJokers, contains(JokerId.quarry));
  });

  test(
    "a daily run's joker stats are what the progression shows next",
    () async {
      // Given
      final container = freshGame();
      await container.read(progressionProvider.future);

      // When
      await container.read(recordProgressionProvider)(
        const .daily(day: 20261017),
        runIn(const .over(), runTotal: 1200).copyWith(jokers: [.twin]),
      );

      // Then
      final shown = await container.read(progressionProvider.future);
      expect(
        shown.jokerStats[JokerId.twin],
        const JokerStats(bestRunTotal: 1200, runsWon: 0, timesPicked: 0),
      );
    },
  );
}
