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

  test(
    'Given Gravity open, When its boss falls for the first time, Then '
    'Anchor and Avalanche unlock and Fog, still coming soon, stays locked',
    () async {
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
      expect(change?.unlockedWorld, isNull);
      expect(
        store.saved.unlockedJokers,
        containsAll([JokerId.anchor, JokerId.avalanche]),
      );
      expect(store.saved.worlds[WorldId.fog]?.unlocked, isFalse);
    },
  );
}
