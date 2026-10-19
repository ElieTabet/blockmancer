import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_engagement_store.dart';
import '../fakes.dart';
import '../fake_progression_store.dart';

void main() {
  late FakeBestScores scores;
  late FakeProgressionStore progression;
  late FakeRunStore store;
  late ProviderContainer container;

  setUp(() {
    scores = FakeBestScores()
      ..saved[const GameMode.daily(day: 20261017)] = 2400
      ..saved[const GameMode.practice()] = 3100;
    store = FakeRunStore()..saved = savedIn(const .playing());
    progression = FakeProgressionStore()
      ..saved = startingProgression(
        const TwoWorldRules(),
      ).copyWith(unlockedJokers: JokerId.values.toSet());
    container = ProviderContainer(
      overrides: bindProviders(
        adsRemoved: (ref) async => false,
        analyticsSink: (ref) => FakeAnalyticsSink(),
        bestScores: (ref) => scores,
        clock: (ref) => FakeClock(DateTime.utc(2026, 10, 17, 12)),
        engagementStore: (ref) => FakeEngagementStore(),
        gameRules: (ref) => const TwoWorldRules(),
        onRunFinished: (ref) => () async {},
        progressionStore: (ref) => progression,
        remoteValue: (ref) =>
            (_) => null,
        runStore: (ref) => store,
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
  });

  test('clearing progress forgets every best, the saved run and the map, '
      'back where a new player starts', () async {
    // Given / When
    await container.read(clearProgressProvider)();

    // Then
    expect(scores.saved, isEmpty);
    expect(store.saved, isNull);
    expect(progression.saved, startingProgression(const TwoWorldRules()));
  });

  test('what was shown of the progress is shown afresh', () async {
    // Given: today's best, practice's, the run to continue and the map shown
    container
      ..listen(todaysDailyBestProvider, (_, _) {})
      ..listen(bestScoreProvider(const .practice()), (_, _) {})
      ..listen(hasSavedRunProvider, (_, _) {})
      ..listen(progressionProvider, (_, _) {});
    expect(await container.read(todaysDailyBestProvider.future), 2400);
    expect(
      await container.read(bestScoreProvider(const .practice()).future),
      3100,
    );
    expect(await container.read(hasSavedRunProvider.future), isTrue);
    expect(
      (await container.read(progressionProvider.future)).unlockedJokers,
      JokerId.values.toSet(),
    );

    // When
    await container.read(clearProgressProvider)();

    // Then
    expect(await container.read(todaysDailyBestProvider.future), isNull);
    expect(
      await container.read(bestScoreProvider(const .practice()).future),
      isNull,
    );
    expect(await container.read(hasSavedRunProvider.future), isFalse);
    expect((await container.read(progressionProvider.future)).unlockedJokers, {
      JokerId.patience,
      JokerId.twin,
    });
  });
}
