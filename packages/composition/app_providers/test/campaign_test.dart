// The whole map, played by a new player from the first world to the last
// with the real rules: each world and each joker opens exactly once.

import 'package:blockmancer_engine/blockmancer_engine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart' as game;
import 'package:shared_domain/shared_domain.dart';

import 'engine_game.dart';
import 'fake_progression_store.dart';

void main() {
  test('Given a new player, When they beat every world in order, Then each '
      'world and each joker pair unlocks once, and a second win unlocks '
      'nothing', () async {
    // Given
    const rules = BlockmancerEngine();
    final store = FakeProgressionStore(game.startingProgression(rules));
    final container = engineGame(progressionStore: store);
    final record = container.read(game.recordProgressionProvider);
    final opened = <WorldId>[];
    final unlocked = <JokerId>[];

    Future<game.ProgressionChange?> win(WorldId world) => record(
      .world(world: world),
      rules
          .startRun(
            config: rules.configFor(
              world,
              jokerPool: store.saved.unlockedJokers.toList(),
            ),
            seed: 1,
          )
          .copyWith(phase: const .won()),
    );

    // When
    for (final world in rules.worldOrder) {
      expect(store.saved.worlds[world]?.unlocked, isTrue, reason: world.name);

      final change = await win(world);
      final next = change?.unlockedWorld;

      if (next != null) opened.add(next);
      unlocked.addAll(change?.unlockedJokers ?? const []);
    }

    final again = [for (final world in rules.worldOrder) await win(world)];

    // Then
    expect(opened, rules.worldOrder.skip(1));
    expect(unlocked.toSet(), hasLength(unlocked.length));
    expect(
      unlocked.toSet(),
      JokerId.values.toSet().difference(rules.startingJokers.toSet()),
    );
    expect(store.saved.unlockedJokers, JokerId.values.toSet());
    for (final change in again) {
      expect(change?.unlockedWorld, isNull);
      expect(change?.unlockedJokers, isEmpty);
    }
  });
}
