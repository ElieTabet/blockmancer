import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:settings_domain/settings_domain.dart';

import '../fake_settings_store.dart';
import '../settings_container.dart';

/// A store whose first save waits for [firstSave] while later ones land at
/// once.
final class _SlowFirstSaveStore extends FakeSettingsStore {
  var _saves = 0;
  final firstSave = Completer<void>();

  @override
  Future<void> save(AppSettings settings) async {
    if (_saves++ == 0) await firstSave.future;

    await super.save(settings);
  }
}

final class _FailingStore extends FakeSettingsStore {
  @override
  Future<void> save(AppSettings settings) async =>
      throw StateError('disk full');
}

final class _UnreachableStore extends FakeSettingsStore {
  @override
  Future<AppSettings> load() async => throw StateError('no storage');
}

void main() {
  test('a first launch has sound and haptics on, and full motion', () async {
    // Given / When
    final settings = await launchWith(
      FakeSettingsStore(),
    ).read(settingsProvider.future);

    // Then
    expect(settings, const AppSettings());
    expect(settings.sound, isTrue);
    expect(settings.haptics, isTrue);
    expect(settings.reduceMotion, isFalse);
    expect(settings.language, AppLanguage.system);
    expect(settings.tutorialSeen, isFalse);
  });

  test('what the player chose is read back by the next launch', () async {
    // Given
    final store = FakeSettingsStore();
    final first = launchWith(store);
    await first.read(settingsProvider.future);
    final notifier = first.read(settingsProvider.notifier);

    // When
    await notifier.setSound(false);
    await notifier.setHaptics(false);
    await notifier.setReduceMotion(true);
    await notifier.setLanguage(.fr);
    await notifier.markTutorialSeen();

    // Then
    expect(
      await launchWith(store).read(settingsProvider.future),
      const AppSettings(
        haptics: false,
        language: .fr,
        reduceMotion: true,
        sound: false,
        tutorialSeen: true,
      ),
    );
  });

  test('a change shows before it is written', () async {
    // Given
    final store = _SlowFirstSaveStore();
    final container = launchWith(store);
    await container.read(settingsProvider.future);

    // When
    final saving = container.read(settingsProvider.notifier).setSound(false);

    // Then
    expect(container.read(settingsProvider).value?.sound, isFalse);
    expect(store.saved, isNull);
    store.firstSave.complete();
    await saving;
    expect(store.saved?.sound, isFalse);
  });

  test('a slow write never lands after the change that followed it', () async {
    // Given
    final store = _SlowFirstSaveStore();
    final container = launchWith(store);
    await container.read(settingsProvider.future);
    final notifier = container.read(settingsProvider.notifier);

    // When: sound goes off, then back on before the first write lands
    final off = notifier.setSound(false);
    final on = notifier.setSound(true);
    store.firstSave.complete();
    await Future.wait([off, on]);

    // Then
    expect(store.saved?.sound, isTrue);
  });

  test(
    'a change that cannot be written still holds until the app closes',
    () async {
      // Given
      final container = launchWith(_FailingStore());
      await container.read(settingsProvider.future);

      // When
      await container.read(settingsProvider.notifier).setReduceMotion(true);

      // Then
      expect(container.read(settingsProvider).value?.reduceMotion, isTrue);
    },
  );

  test('a change made while the settings load keeps what was stored', () async {
    // Given
    final store = FakeSettingsStore(const AppSettings(sound: false));
    final container = launchWith(store);

    // When
    await container.read(settingsProvider.notifier).setHaptics(false);

    // Then
    expect(
      container.read(settingsProvider).value,
      const AppSettings(haptics: false, sound: false),
    );
    expect(store.saved, const AppSettings(haptics: false, sound: false));
  });

  test('settings that cannot be read are a first launch\'s', () async {
    // Given / When
    final settings = await launchWith(
      _UnreachableStore(),
    ).read(settingsProvider.future);

    // Then
    expect(settings, const AppSettings());
  });
}
