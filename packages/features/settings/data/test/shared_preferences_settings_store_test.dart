import 'package:flutter_test/flutter_test.dart';
import 'package:settings_data/settings_data.dart';
import 'package:settings_domain/settings_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// What the next launch reads: the store's cache gone, the device's values
/// kept.
Future<AppSettings> _relaunched() async {
  final stored = await SharedPreferences.getInstance();
  SharedPreferences.setMockInitialValues({
    for (final key in stored.getKeys()) key: stored.get(key)!,
  });

  return const SharedPreferencesSettingsStore().load();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('a first launch reads the defaults', () async {
    // Given / When
    final settings = await const SharedPreferencesSettingsStore().load();

    // Then
    expect(settings, const AppSettings());
  });

  test('saved settings are read back by the next launch', () async {
    // Given
    const chosen = AppSettings(
      dailyReminder: false,
      haptics: false,
      language: .fr,
      reduceMotion: true,
      sound: false,
      tutorialSeen: true,
    );

    // When
    await const SharedPreferencesSettingsStore().save(chosen);

    // Then
    expect(await _relaunched(), chosen);
  });

  test('each setting is kept under its own key', () async {
    // Given / When
    await const SharedPreferencesSettingsStore().save(
      const AppSettings(language: .en),
    );

    // Then
    final stored = await SharedPreferences.getInstance();
    expect(stored.getKeys(), {
      'settings.dailyReminder',
      'settings.haptics',
      'settings.language',
      'settings.reduceMotion',
      'settings.sound',
      'settings.tutorialSeen',
    });
    expect(stored.getString('settings.language'), 'en');
  });

  test('a value that cannot be read is its default', () async {
    // Given
    SharedPreferences.setMockInitialValues({
      'settings.haptics': 'yes',
      'settings.language': 'klingon',
      'settings.reduceMotion': 1,
      'settings.sound': false,
    });

    // When
    final settings = await const SharedPreferencesSettingsStore().load();

    // Then
    expect(settings, const AppSettings(sound: false));
  });
}
