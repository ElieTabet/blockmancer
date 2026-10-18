import 'package:flutter_test/flutter_test.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:push_notifications_presentation/push_notifications_presentation.dart';

void main() {
  tearDown(() => LocaleSettings.setLocaleSync(AppLocale.en));

  test('Given the app in English, When the reminder is scheduled, Then it '
      'says the daily run is ready', () {
    // Given
    LocaleSettings.setLocaleSync(AppLocale.en);

    // When
    final texts = dailyReminderTexts();

    // Then
    expect(texts.title, "Today's daily run is ready");
    expect(texts.channelName, 'Daily run reminder');
  });

  test('Given the app in French, When the reminder is scheduled, Then it '
      'speaks French', () {
    // Given
    LocaleSettings.setLocaleSync(AppLocale.fr);

    // When / Then
    expect(dailyReminderTexts().title, 'La partie du jour est prête');
  });
}
