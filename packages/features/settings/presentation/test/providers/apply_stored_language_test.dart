import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:settings_domain/settings_domain.dart' as settings;
import 'package:settings_presentation/settings_presentation.dart';

import '../fake_settings_store.dart';

Future<void> _launchWith(settings.AppLanguage language) async {
  final container = ProviderContainer(
    overrides: settings.bindProviders(
      clearProgress: (ref) => () async {},
      settingsStore: (ref) =>
          FakeSettingsStore(settings.AppSettings(language: language)),
    ),
  );
  addTearDown(container.dispose);

  await container.read(applyStoredLanguageProvider)();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() => LocaleSettings.setLocaleSync(.en));

  test('the app starts in the language the player chose', () async {
    // Given / When
    await _launchWith(.fr);

    // Then
    expect(LocaleSettings.currentLocale, AppLocale.fr);
  });

  test("with System chosen, the app starts in the phone's language", () async {
    // Given: a phone in English, the app last shown in French
    LocaleSettings.setLocaleSync(.fr);

    // When
    await _launchWith(.system);

    // Then
    expect(LocaleSettings.currentLocale, AppLocale.en);
  });
}
