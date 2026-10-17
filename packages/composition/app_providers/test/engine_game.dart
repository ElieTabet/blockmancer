import 'package:blockmancer_engine/blockmancer_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_data/game_data.dart';
import 'package:game_domain/game_domain.dart' as game;
import 'package:shared_domain/shared_domain.dart';

import 'fake_clock.dart';
import 'fake_progression_store.dart';

/// The game's domain over the real engine, as composition binds it, but on
/// [clock] and with the progression kept in [progressionStore] — a new
/// player's, at noon on 17 October 2026 UTC, unless given.
ProviderContainer engineGame({
  game.Clock? clock,
  game.ProgressionStore? progressionStore,
}) {
  final container = ProviderContainer(
    overrides: game.bindProviders(
      analyticsSink: (ref) => const _NoAnalytics(),
      bestScores: (ref) => SharedPreferencesBestScores(
        startingProgression: ref.watch(game.initialProgressionProvider),
      ),
      clock: (ref) => clock ?? FakeClock(DateTime.utc(2026, 10, 17, 12)),
      gameRules: (ref) => const BlockmancerEngine(),
      progressionStore: (ref) =>
          progressionStore ??
          FakeProgressionStore(ref.watch(game.initialProgressionProvider)),
      runStore: (ref) => const SharedPreferencesRunStore(),
    ),
  );
  addTearDown(container.dispose);

  return container;
}

/// Counts nothing: these runs are the engine's, not a player's.
final class _NoAnalytics implements AnalyticsSink {
  const _NoAnalytics();

  @override
  void log(AnalyticsEvent event) {}
}
