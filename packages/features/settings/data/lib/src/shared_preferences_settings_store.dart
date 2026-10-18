import 'package:settings_domain/settings_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// One key per setting, so a setting added later reads as its default on a
/// device that saved before it existed.
final class SharedPreferencesSettingsStore implements SettingsStore {
  const SharedPreferencesSettingsStore();

  static const _dailyReminder = 'settings.dailyReminder';
  static const _defaults = AppSettings();
  static const _haptics = 'settings.haptics';
  static const _language = 'settings.language';
  static const _reduceMotion = 'settings.reduceMotion';
  static const _sound = 'settings.sound';
  static const _tutorialSeen = 'settings.tutorialSeen';

  @override
  Future<AppSettings> load() async {
    final preferences = await SharedPreferences.getInstance();

    bool flag(String key, bool fallback) => switch (preferences.get(key)) {
      final bool value => value,
      _ => fallback,
    };

    return AppSettings(
      dailyReminder: flag(_dailyReminder, _defaults.dailyReminder),
      haptics: flag(_haptics, _defaults.haptics),
      language:
          AppLanguage.values.asNameMap()[preferences.get(_language)] ??
          _defaults.language,
      reduceMotion: flag(_reduceMotion, _defaults.reduceMotion),
      sound: flag(_sound, _defaults.sound),
      tutorialSeen: flag(_tutorialSeen, _defaults.tutorialSeen),
    );
  }

  @override
  Future<void> save(AppSettings settings) async {
    final preferences = await SharedPreferences.getInstance();

    await Future.wait([
      preferences.setBool(_dailyReminder, settings.dailyReminder),
      preferences.setBool(_haptics, settings.haptics),
      preferences.setString(_language, settings.language.name),
      preferences.setBool(_reduceMotion, settings.reduceMotion),
      preferences.setBool(_sound, settings.sound),
      preferences.setBool(_tutorialSeen, settings.tutorialSeen),
    ]);
  }
}
