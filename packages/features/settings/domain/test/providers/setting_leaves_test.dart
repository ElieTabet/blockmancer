import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:settings_domain/settings_domain.dart';

import '../fake_settings_store.dart';
import '../settings_container.dart';

/// A store whose settings arrive when [loaded] completes.
final class _SlowStore extends FakeSettingsStore {
  _SlowStore(super.saved);

  final loaded = Completer<void>();

  @override
  Future<AppSettings> load() async {
    await loaded.future;

    return super.load();
  }
}

const _quiet = AppSettings(
  dailyReminder: false,
  haptics: false,
  language: .en,
  reduceMotion: true,
  sound: false,
  tutorialSeen: true,
);

void main() {
  test('while the settings load, each reads as a first launch has it', () {
    // Given / When
    final container = launchWith(_SlowStore(_quiet));

    // Then
    expect(container.read(soundOnProvider), isTrue);
    expect(container.read(hapticsOnProvider), isTrue);
    expect(container.read(reduceMotionOnProvider), isFalse);
    expect(container.read(dailyReminderOnProvider), isTrue);
  });

  test('once loaded, each reads what the player chose', () async {
    // Given
    final store = _SlowStore(_quiet);
    final container = launchWith(store);
    container
      ..listen(soundOnProvider, (_, _) {})
      ..listen(hapticsOnProvider, (_, _) {})
      ..listen(reduceMotionOnProvider, (_, _) {})
      ..listen(dailyReminderOnProvider, (_, _) {});

    // When
    store.loaded.complete();
    await container.read(settingsProvider.future);

    // Then
    expect(container.read(soundOnProvider), isFalse);
    expect(container.read(hapticsOnProvider), isFalse);
    expect(container.read(reduceMotionOnProvider), isTrue);
    expect(container.read(dailyReminderOnProvider), isFalse);
    expect(await container.read(dailyReminderEnabledProvider.future), isFalse);
  });

  test('the tutorial and the language wait for what is stored', () async {
    // Given
    final store = _SlowStore(_quiet);
    final container = launchWith(store);
    final seen = container.read(tutorialSeenProvider.future);
    final language = container.read(appLanguageProvider.future);

    // When
    store.loaded.complete();

    // Then
    expect(await seen, isTrue);
    expect(await language, AppLanguage.en);
  });

  test('a change reaches the leaf that reads it', () async {
    // Given
    final container = launchWith(FakeSettingsStore());
    container.listen(soundOnProvider, (_, _) {});
    await container.read(settingsProvider.future);

    // When
    await container.read(settingsProvider.notifier).setSound(false);

    // Then
    expect(container.read(soundOnProvider), isFalse);
  });
}
