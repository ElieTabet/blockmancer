import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_progression_store.dart';
import '../fakes.dart';

/// [TwoWorldRules]' map with Fog after it, which has no rules yet.
final class _FogComingRules implements GameRules {
  const _FogComingRules();

  static const _known = TwoWorldRules();

  @override
  RunConfig get defaultConfig => _known.configFor(.rubble, jokerPool: const []);

  @override
  List<WorldId> get worldOrder => const [.rubble, .gravity, .fog];

  @override
  RunConfig configFor(WorldId world, {required List<JokerId> jokerPool}) {
    if (world == .fog) throw ArgumentError.value(world, 'world');

    return _known.configFor(world, jokerPool: jokerPool);
  }

  @override
  bool isPlayable(WorldId world) => world != .fog;

  @override
  List<JokerId> unlocksOf(WorldId world) => _known.unlocksOf(world);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('Given a map whose last world has no rules yet, '
      'When the map is summed up, '
      'Then each world comes in the map\'s order with its boss target, third '
      'star, unlocks and their tuning, and the last is coming soon', () {
    // Given
    final container = ProviderContainer(
      overrides: bindProviders(
        analyticsSink: (ref) => FakeAnalyticsSink(),
        bestScores: (ref) => FakeBestScores(),
        clock: (ref) => FakeClock(DateTime.utc(2026, 10, 17, 12)),
        gameRules: (ref) => const _FogComingRules(),
        progressionStore: (ref) => FakeProgressionStore(),
        remoteValue: (ref) =>
            (_) => null,
        runStore: (ref) => FakeRunStore(),
      ),
    );
    addTearDown(container.dispose);

    // When
    final worlds = container.read(worldSummariesProvider);

    // Then
    final tuning = const _FogComingRules().defaultConfig.jokers;
    expect(worlds, [
      WorldSummary(
        bossTarget: 250,
        id: .rubble,
        jokerTuning: tuning,
        playable: true,
        starThreshold: 8000,
        unlocks: [.stonemason, .quarry],
      ),
      WorldSummary(
        bossTarget: 250,
        id: .gravity,
        jokerTuning: tuning,
        playable: true,
        starThreshold: 8000,
        unlocks: [.anchor, .avalanche],
      ),
      WorldSummary(
        bossTarget: 0,
        id: .fog,
        jokerTuning: tuning,
        playable: false,
        starThreshold: 0,
        unlocks: [],
      ),
    ]);
  });
}
