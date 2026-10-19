import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:push_notifications_domain/push_notifications_domain.dart';
import 'package:push_notifications_presentation/push_notifications_presentation.dart';

void main() {
  tearDown(() => LocaleSettings.setLocaleSync(AppLocale.en));

  // A lock screen cuts what's longer; a year-long streak is the longest a
  // streak message gets in practice.
  test('every reminder fits a lock screen, in every language: titles of 40 '
      'characters at most and bodies of 110', () {
    for (final locale in AppLocale.values) {
      for (final message in ReminderMessage.values) {
        final (:body, :title) = reminderMessageTexts(
          message,
          language: locale.languageCode,
          streak: 365,
        );
        final reason = '${locale.languageCode} ${message.id}';

        expect(title.characters.length, lessThanOrEqualTo(40), reason: reason);
        expect(body.characters.length, lessThanOrEqualTo(110), reason: reason);
        expect(title, isNot(contains(r'$')), reason: reason);
        expect(body, isNot(contains(r'$')), reason: reason);
      }
    }
  });

  test('every reminder title starts with its emoji', () {
    for (final locale in AppLocale.values) {
      for (final message in ReminderMessage.values) {
        final (:body, :title) = reminderMessageTexts(
          message,
          language: locale.languageCode,
          streak: 2,
        );

        expect(
          title.characters.first.runes.first,
          greaterThan(0x2000),
          reason: '${locale.languageCode} ${message.id}',
        );
      }
    }
  });

  test('Given the app in English, When a streak message is written in '
      'French, Then it is French and names the streak', () {
    // Given
    LocaleSettings.setLocaleSync(AppLocale.en);

    // When
    final texts = reminderMessageTexts(.streakCount, language: 'fr', streak: 4);

    // Then
    expect(texts.title, '🔥 Série de 4 jours !');
  });

  test('Given the app in French, When the channel is named, Then it speaks '
      'French', () {
    // Given
    LocaleSettings.setLocaleSync(AppLocale.fr);

    // When / Then
    expect(
      dailyReminderChannelTexts().channelName,
      'Rappel de la partie du jour',
    );
  });

  test('Given the app in English, When it switches to French, Then the '
      'language read is English, then French', () async {
    // Given
    LocaleSettings.setLocaleSync(AppLocale.en);
    final languages = <String>[];
    final subscription = displayLanguages().listen(languages.add);
    addTearDown(subscription.cancel);
    await pumpEventQueue();

    // When
    LocaleSettings.setLocaleSync(AppLocale.fr);
    await pumpEventQueue();

    // Then
    expect(languages, ['en', 'fr']);
  });
}
