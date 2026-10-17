import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';

import '../fakes.dart';

void main() {
  late FakeBestScores scores;
  late FakeRunStore store;
  late ProviderContainer container;

  setUp(() {
    scores = FakeBestScores()
      ..saved[const GameMode.daily(day: 20261017)] = 2400
      ..saved[const GameMode.practice()] = 3100;
    store = FakeRunStore()..saved = savedIn(const .playing());
    container = ProviderContainer(
      overrides: bindProviders(
        bestScores: (ref) => scores,
        clock: (ref) => FakeClock(DateTime.utc(2026, 10, 17, 12)),
        gameRules: (ref) => const DailySeedRules(),
        runStore: (ref) => store,
      ),
    );
    addTearDown(container.dispose);
  });

  test('clearing progress forgets every best and the saved run', () async {
    // Given / When
    await container.read(clearProgressProvider)();

    // Then
    expect(scores.saved, isEmpty);
    expect(store.saved, isNull);
  });

  test('what was shown of the progress is shown afresh', () async {
    // Given: Home showing today's best, practice's and the run to continue
    container
      ..listen(todaysDailyBestProvider, (_, _) {})
      ..listen(bestScoreProvider(const .practice()), (_, _) {})
      ..listen(hasSavedRunProvider, (_, _) {});
    expect(await container.read(todaysDailyBestProvider.future), 2400);
    expect(
      await container.read(bestScoreProvider(const .practice()).future),
      3100,
    );
    expect(await container.read(hasSavedRunProvider.future), isTrue);

    // When
    await container.read(clearProgressProvider)();

    // Then
    expect(await container.read(todaysDailyBestProvider.future), isNull);
    expect(
      await container.read(bestScoreProvider(const .practice()).future),
      isNull,
    );
    expect(await container.read(hasSavedRunProvider.future), isFalse);
  });
}
