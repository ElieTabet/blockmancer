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
      adsRemoved: (ref) async => false,
      analyticsSink: (ref) => const _NoAnalytics(),
      bestScores: (ref) => SharedPreferencesBestScores(
        startingProgression: ref.watch(game.initialProgressionProvider),
      ),
      clock: (ref) => clock ?? FakeClock(DateTime.utc(2026, 10, 17, 12)),
      engagementStore: (ref) => _MemoryEngagementStore(),
      gameRules: (ref) => const BlockmancerEngine(),
      progressionStore: (ref) =>
          progressionStore ??
          FakeProgressionStore(ref.watch(game.initialProgressionProvider)),
      remoteValue: (ref) =>
          (_) => null,
      runStore: (ref) => const SharedPreferencesRunStore(),
      appVersion: (ref) async => '1.0.0',
      requestReview: (ref) => () async {},
      sessionHadError: (ref) =>
          () => false,
      showInterstitial: (ref) =>
          () async => const AdResult.failed(code: 'no_ads'),
      submitBestScore: (ref) => (_) async {},
      submitDailyScore: (ref) => (_) async {},
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

/// The engagement kept in memory, starting from nothing played.
final class _MemoryEngagementStore implements game.EngagementStore {
  game.Engagement saved = const game.Engagement();

  @override
  Future<game.Engagement> load() async => saved;

  @override
  Future<void> save(game.Engagement engagement) async => saved = engagement;
}
