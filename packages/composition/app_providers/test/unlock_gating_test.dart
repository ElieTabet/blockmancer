// The offers are the engine's to draw and the pool game_domain's to choose:
// this is the one place both are real.

import 'package:app_providers/app_providers.dart';
import 'package:app_router/app_router.dart';
import 'package:blockmancer_engine/blockmancer_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart' as game;
import 'package:shared_domain/shared_domain.dart';

import 'engine_game.dart';
import 'fake_progression_store.dart';

/// Runs started per mode: enough for every joker a pool holds to be offered.
const _seeds = 200;

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: appOverrides(collectsTelemetry: false, router: AppRouter()),
    );
    addTearDown(container.dispose);
  });

  /// Every joker offered as the starting pick of [_seeds] runs of [config].
  Set<JokerId> offeredAcross(RunConfig config) {
    final rules = container.read(game.gameRulesProvider);

    return {
      for (var seed = 0; seed < _seeds; seed++)
        if (rules.startRun(config: config, seed: seed).phase
            case PickingJokerPhase(:final offers))
          ...offers,
    };
  }

  test('Given a new player, When a world run starts, Then it offers only the '
      'jokers they have unlocked, and the daily offers the others too', () {
    // Given
    final fresh = container.read(game.initialProgressionProvider);
    final locked = JokerId.values.toSet().difference(fresh.unlockedJokers);
    final startFor = container.read(game.runStartForProvider);

    // When
    final rubble = startFor(.world, progression: fresh, world: .rubble);
    final gravity = startFor(.world, progression: fresh, world: .gravity);
    final daily = startFor(.daily, progression: fresh);

    // Then
    expect(locked, isNotEmpty);
    expect(rubble.config.jokerPool.toSet(), fresh.unlockedJokers);
    expect(gravity.config.jokerPool.toSet(), fresh.unlockedJokers);
    expect(offeredAcross(rubble.config).intersection(locked), isEmpty);
    expect(offeredAcross(gravity.config).intersection(locked), isEmpty);
    expect(offeredAcross(daily.config).intersection(locked), isNotEmpty);
  });

  test("Given a new player, Then the stars' four jokers are locked, and only "
      'the daily offers them', () {
    // Given
    const starJokers = {
      JokerId.brink,
      JokerId.finisher,
      JokerId.fullhouse,
      JokerId.hattrick,
    };
    final fresh = container.read(game.initialProgressionProvider);
    final startFor = container.read(game.runStartForProvider);

    // When
    final practice = startFor(.practice, progression: fresh);
    final daily = startFor(.daily, progression: fresh);

    // Then
    expect(fresh.unlockedJokers.intersection(starJokers), isEmpty);
    expect(offeredAcross(practice.config).intersection(starJokers), isEmpty);
    expect(offeredAcross(daily.config).intersection(starJokers), isNotEmpty);
  });

  test(
    "Given Rubble's three stars, When a Gravity run earns its third star, Then "
    'Full House and On the Brink unlock',
    () async {
      // Given
      const rules = BlockmancerEngine();
      final fresh = game.startingProgression(rules);
      final store = FakeProgressionStore(
        fresh.copyWith(
          worlds: {
            ...fresh.worlds,
            .rubble: const WorldProgress(
              bossBeaten: true,
              stars: WorldStars(
                bossBeaten: true,
                noRevive: true,
                scoreThreshold: true,
              ),
              unlocked: true,
            ),
            .gravity: fresh.worlds[WorldId.gravity]!.copyWith(unlocked: true),
          },
        ),
      );
      final gameContainer = engineGame(progressionStore: store);
      final config = rules.configFor(
        .gravity,
        jokerPool: fresh.unlockedJokers.toList(),
      );
      final ended = rules
          .startRun(config: config, seed: 1)
          .copyWith(phase: const .over(), runTotal: config.starThreshold);

      // When
      final change = await gameContainer.read(game.recordProgressionProvider)(
        const .world(world: .gravity),
        ended,
      );

      // Then
      expect(change?.unlockedJokers, [JokerId.fullhouse, JokerId.brink]);
      expect(
        store.saved.unlockedJokers,
        containsAll([JokerId.fullhouse, JokerId.brink]),
      );
    },
  );

  test('Given Gravity open, When its boss falls for the first time, Then '
      'Anchor and Avalanche unlock, and Fog opens', () async {
    // Given
    const rules = BlockmancerEngine();
    final fresh = game.startingProgression(rules);
    final store = FakeProgressionStore(
      fresh.copyWith(
        worlds: {
          ...fresh.worlds,
          WorldId.gravity: fresh.worlds[WorldId.gravity]!.copyWith(
            unlocked: true,
          ),
        },
      ),
    );
    final gameContainer = engineGame(progressionStore: store);
    final won = rules
        .startRun(
          config: rules.configFor(
            .gravity,
            jokerPool: fresh.unlockedJokers.toList(),
          ),
          seed: 1,
        )
        .copyWith(phase: const .won());

    // When
    final change = await gameContainer.read(game.recordProgressionProvider)(
      const .world(world: .gravity),
      won,
    );

    // Then
    expect(change?.unlockedJokers, [JokerId.anchor, JokerId.avalanche]);
    expect(change?.unlockedWorld, WorldId.fog);
    expect(
      store.saved.unlockedJokers,
      containsAll([JokerId.anchor, JokerId.avalanche]),
    );
    expect(store.saved.worlds[WorldId.fog]?.unlocked, isTrue);
  });

  test(
    'Given Fog open, When its boss falls for the first time, Then Lantern and '
    'Ember unlock, and Tide opens',
    () async {
      // Given
      const rules = BlockmancerEngine();
      final fresh = game.startingProgression(rules);
      final store = FakeProgressionStore(
        fresh.copyWith(
          worlds: {
            ...fresh.worlds,
            WorldId.fog: fresh.worlds[WorldId.fog]!.copyWith(unlocked: true),
          },
        ),
      );
      final gameContainer = engineGame(progressionStore: store);
      final won = rules
          .startRun(
            config: rules.configFor(
              .fog,
              jokerPool: fresh.unlockedJokers.toList(),
            ),
            seed: 1,
          )
          .copyWith(phase: const .won());

      // When
      final change = await gameContainer.read(game.recordProgressionProvider)(
        const .world(world: .fog),
        won,
      );

      // Then
      expect(change?.unlockedJokers, [JokerId.lantern, JokerId.ember]);
      expect(change?.unlockedWorld, WorldId.tide);
      expect(store.saved.worlds[WorldId.tide]?.unlocked, isTrue);
    },
  );

  test('Given Tide open, When its boss falls for the first time, Then Sprinter '
      'and Momentum unlock, and Mirror opens', () async {
    // Given
    const rules = BlockmancerEngine();
    final fresh = game.startingProgression(rules);
    final store = FakeProgressionStore(
      fresh.copyWith(
        worlds: {
          ...fresh.worlds,
          WorldId.tide: fresh.worlds[WorldId.tide]!.copyWith(unlocked: true),
        },
      ),
    );
    final gameContainer = engineGame(progressionStore: store);
    final won = rules
        .startRun(
          config: rules.configFor(
            .tide,
            jokerPool: fresh.unlockedJokers.toList(),
          ),
          seed: 1,
        )
        .copyWith(phase: const .won());

    // When
    final change = await gameContainer.read(game.recordProgressionProvider)(
      const .world(world: .tide),
      won,
    );

    // Then
    expect(change?.unlockedJokers, [JokerId.sprinter, JokerId.momentum]);
    expect(change?.unlockedWorld, WorldId.mirror);
    expect(store.saved.worlds[WorldId.mirror]?.unlocked, isTrue);
  });

  test(
    'Given Mirror open, When its boss falls for the first time, Then Symmetry '
    'and Prism unlock, the last world having none after it',
    () async {
      // Given
      const rules = BlockmancerEngine();
      final fresh = game.startingProgression(rules);
      final store = FakeProgressionStore(
        fresh.copyWith(
          worlds: {
            ...fresh.worlds,
            WorldId.mirror: fresh.worlds[WorldId.mirror]!.copyWith(
              unlocked: true,
            ),
          },
        ),
      );
      final gameContainer = engineGame(progressionStore: store);
      final won = rules
          .startRun(
            config: rules.configFor(
              .mirror,
              jokerPool: fresh.unlockedJokers.toList(),
            ),
            seed: 1,
          )
          .copyWith(phase: const .won());

      // When
      final change = await gameContainer.read(game.recordProgressionProvider)(
        const .world(world: .mirror),
        won,
      );

      // Then
      expect(change?.unlockedJokers, [JokerId.symmetry, JokerId.prism]);
      expect(change?.unlockedWorld, isNull);
    },
  );
}
