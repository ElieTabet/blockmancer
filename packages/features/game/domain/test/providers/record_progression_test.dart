import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_progression_store.dart';
import '../fakes.dart';

void main() {
  test('what a world run earns is what the progression shows next', () async {
    // Given: the progression shown from a fresh profile
    final store = FakeProgressionStore()
      ..saved = startingProgression(const TwoWorldRules());
    final container = ProviderContainer(
      overrides: bindProviders(
        bestScores: (ref) => FakeBestScores(),
        clock: (ref) => FakeClock(DateTime.utc(2026, 10, 17, 12)),
        gameRules: (ref) => const TwoWorldRules(),
        progressionStore: (ref) => store,
        runStore: (ref) => FakeRunStore(),
      ),
    );
    addTearDown(container.dispose);
    container.listen(progressionProvider, (_, _) {});
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
}
