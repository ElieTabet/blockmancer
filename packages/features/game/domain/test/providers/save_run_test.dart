import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fakes.dart';

void main() {
  late FakeRunStore store;
  late ProviderContainer container;

  setUp(() {
    store = FakeRunStore();
    container = ProviderContainer(
      overrides: bindProviders(
        bestScores: (ref) => FakeBestScores(),
        clock: (ref) => FakeClock(DateTime.utc(2026, 10, 17)),
        gameRules: (ref) => const DailySeedRules(),
        runStore: (ref) => store,
      ),
    );
    addTearDown(container.dispose);
    container.listen(hasSavedRunProvider, (_, _) {});
  });

  test('a run in play is kept, and offered to resume', () async {
    // Given
    expect(await container.read(hasSavedRunProvider.future), isFalse);

    // When
    await container.read(saveRunProvider)(savedIn(const .playing()));

    // Then
    expect(store.saved, savedIn(const .playing()));
    expect(await container.read(hasSavedRunProvider.future), isTrue);
  });

  for (final (name, phase) in const [
    ('been won', RunPhase.won()),
    ('been ended', RunPhase.over()),
  ]) {
    test('a run that has $name is forgotten, never offered again', () async {
      // Given
      await container.read(saveRunProvider)(savedIn(const .playing()));
      expect(await container.read(hasSavedRunProvider.future), isTrue);

      // When
      await container.read(saveRunProvider)(savedIn(phase));

      // Then
      expect(store.saved, isNull);
      expect(await container.read(hasSavedRunProvider.future), isFalse);
    });
  }
}
