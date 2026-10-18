import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_presentation/src/notifiers/game_notifier.br.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_game_rules.dart';
import '../game_overrides.dart';

void main() {
  /// Rules whose run in [world] waits on the pick that starts its boss.
  FakeGameRules rulesIn(WorldId world) {
    final config = testConfig.copyWith(world: world);

    return FakeGameRules(
        start: runIn(
          const .pickingJoker(offers: [.twin]),
        ).copyWith(config: config),
      )
      ..next = (
        runIn(const .playing(), roundIndex: 1).copyWith(config: config),
        const [GameEvent.roundStarted(pieces: 22, roundIndex: 1, target: 2000)],
      );
  }

  ProviderContainer container(
    FakeGameRules rules, {
    GameLaunch launch = .world,
    Progression? progression,
    FakeProgressionStore? store,
    WorldId world = .gravity,
  }) {
    final container = ProviderContainer(
      overrides: gameOverrides(
        rules,
        launch: launch,
        progression: progression,
        progressionStore: store,
        world: world,
      ),
    );
    addTearDown(container.dispose);
    container.listen(gameProvider, (_, _) {});

    return container;
  }

  test("a world run reaching its boss for the first time shows that world's "
      'boss card', () {
    // Given
    final game = container(rulesIn(.gravity));

    // When
    game.read(gameProvider.notifier).pickJoker(.twin);

    // Then
    expect(game.read(gameProvider).bossCard, WorldId.gravity);
  });

  test('a boss card put away is remembered, and not shown again on this '
      'screen', () async {
    // Given
    final rules = rulesIn(.gravity);
    final store = FakeProgressionStore(startingProgression(rules));
    final game = container(rules, store: store);
    final notifier = game.read(gameProvider.notifier)..pickJoker(.twin);

    // When
    notifier.closeBossCard();
    await Future<void>.delayed(Duration.zero);
    notifier
      ..retry()
      ..pickJoker(.twin);

    // Then
    expect(store.saved.bossCardsSeen, {WorldId.gravity});
    expect(game.read(gameProvider).bossCard, isNull);
  });

  test('a boss card the progression has seen is not shown', () {
    // Given
    final rules = rulesIn(.gravity);
    final game = container(
      rules,
      progression: startingProgression(
        rules,
      ).copyWith(bossCardsSeen: const {.gravity}),
    );

    // When
    game.read(gameProvider.notifier).pickJoker(.twin);

    // Then
    expect(game.read(gameProvider).bossCard, isNull);
  });

  test(
    "the map's first world, and runs outside the map, show no boss card",
    () {
      for (final (launch, world) in const [
        (GameLaunch.world, WorldId.rubble),
        (GameLaunch.daily, WorldId.gravity),
        (GameLaunch.practice, WorldId.gravity),
      ]) {
        // Given
        final game = container(rulesIn(world), launch: launch, world: world);

        // When
        game.read(gameProvider.notifier).pickJoker(.twin);

        // Then
        expect(game.read(gameProvider).bossCard, isNull, reason: '$launch');
      }
    },
  );
}
