// The offers are the engine's to draw and the pool game_domain's to choose:
// this is the one place both are real. Whole runs are played by the engine's
// balance bot, reached in its src/ because it isn't part of the rules'
// contract.

import 'package:app_providers/app_providers.dart';
import 'package:app_router/app_router.dart';
import 'package:blockmancer_engine/src/bot/greedy_policy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart' as game;
import 'package:shared_domain/shared_domain.dart';

/// Runs played per mode: enough for every joker a pool holds to turn up.
const _runs = 40;

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: appOverrides(collectsTelemetry: false, router: AppRouter()),
    );
    addTearDown(container.dispose);
  });

  /// Every joker offered across [_runs] whole runs of [config], the bot
  /// taking a [preferred] joker whenever one is offered.
  Set<JokerId> offeredAcross(
    RunConfig config, {
    required List<JokerId> preferred,
  }) {
    final rules = container.read(game.gameRulesProvider);
    final offered = <JokerId>{};

    for (var seed = 0; seed < _runs; seed++) {
      var state = rules.startRun(config: config, seed: seed);

      for (
        var move = greedyMove(state, build: preferred);
        move != null;
        move = greedyMove(state, build: preferred)
      ) {
        if (state.phase case PickingJokerPhase(:final offers)) {
          offered.addAll(offers);
        }

        state = switch (move) {
          EndMove() => rules.endRun(state),
          PickMove(:final id) => rules.pickJoker(state, id: id),
          PlaceMove(:final anchor, :final trayIndex) => rules.place(
            state,
            anchor: anchor,
            trayIndex: trayIndex,
          ),
          ReviveMove() => rules.revive(state),
        }.$1;
      }
    }

    return offered;
  }

  test('a fresh profile is never offered a locked joker in world runs, and '
      'daily runs can be', () {
    // Given: a new player
    final fresh = container.read(game.initialProgressionProvider);
    final locked = JokerId.values.toSet().difference(fresh.unlockedJokers);
    final startFor = container.read(game.runStartForProvider);
    final world = startFor(.world, progression: fresh, world: .rubble);
    final daily = startFor(.daily, progression: fresh);

    // When: both are played through, the bot reaching for locked jokers
    final inWorldRuns = offeredAcross(world.config, preferred: locked.toList());
    final inDailyRuns = offeredAcross(daily.config, preferred: locked.toList());

    // Then
    expect(locked, isNotEmpty);
    expect(inWorldRuns.intersection(locked), isEmpty);
    expect(inWorldRuns, fresh.unlockedJokers);
    expect(inDailyRuns.intersection(locked), isNotEmpty);
  });
}
