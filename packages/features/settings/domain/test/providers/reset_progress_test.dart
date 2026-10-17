import 'package:flutter_test/flutter_test.dart';
import 'package:settings_domain/settings_domain.dart';

import '../fake_settings_store.dart';
import '../settings_container.dart';

void main() {
  test(
    'resetting progress clears it, then offers the tutorial again',
    () async {
      // Given
      final calls = <String>[];
      final store = FakeSettingsStore(
        const AppSettings(sound: false, tutorialSeen: true),
      );
      final container = launchWith(
        store,
        onClearProgress: () async => calls.add('clear progress'),
      );
      await container.read(settingsProvider.future);

      // When
      await container.read(resetProgressProvider)();

      // Then
      expect(calls, ['clear progress']);
      expect(await container.read(tutorialSeenProvider.future), isFalse);
      expect(store.saved, const AppSettings(sound: false));
    },
  );

  test('progress that cannot be cleared leaves the tutorial seen', () async {
    // Given
    final store = FakeSettingsStore(const AppSettings(tutorialSeen: true));
    final container = launchWith(
      store,
      onClearProgress: () async => throw StateError('no storage'),
    );
    await container.read(settingsProvider.future);

    // When
    final reset = container.read(resetProgressProvider)();

    // Then
    await expectLater(reset, throwsStateError);
    expect(await container.read(tutorialSeenProvider.future), isTrue);
  });
}
