import 'package:l10n_application/l10n_application.dart';
import 'package:push_notifications_domain/push_notifications_domain.dart';

/// The Android channel the daily reminders are filed under, in the language
/// the app shows.
({String channelDescription, String channelName}) dailyReminderChannelTexts() {
  final reminder = t.push.reminder;

  return (
    channelDescription: reminder.channelDescription,
    channelName: reminder.channelName,
  );
}

/// The app's language (`en`, `fr`) now, then on every change.
Stream<String> displayLanguages() async* {
  yield LocaleSettings.currentLocale.languageCode;
  yield* LocaleSettings.getLocaleStream().map((locale) => locale.languageCode);
}

/// [message]'s words in [language], read from that language's translations
/// rather than the app's current ones, so they never depend on which switched
/// first.
({String body, String title}) reminderMessageTexts(
  ReminderMessage message, {
  required String language,
  required int streak,
}) {
  final messages = AppLocaleUtils.parse(
    language,
  ).translations.push.reminder.messages;

  return switch (message) {
    .beatYesterday => (
      body: messages.beatYesterday.body,
      title: messages.beatYesterday.title,
    ),
    .blocksFalling => (
      body: messages.blocksFalling.body,
      title: messages.blocksFalling.title,
    ),
    .boardReady => (
      body: messages.boardReady.body,
      title: messages.boardReady.title,
    ),
    .boardReset => (
      body: messages.boardReset.body,
      title: messages.boardReset.title,
    ),
    .comboTime => (
      body: messages.comboTime.body,
      title: messages.comboTime.title,
    ),
    .comeback => (body: messages.comeback.body, title: messages.comeback.title),
    .fiveMinutes => (
      body: messages.fiveMinutes.body,
      title: messages.fiveMinutes.title,
    ),
    .jokersRestless => (
      body: messages.jokersRestless.body,
      title: messages.jokersRestless.title,
    ),
    .newDaily => (body: messages.newDaily.body, title: messages.newDaily.title),
    .streakCount => (
      body: messages.streakCount.body,
      title: messages.streakCount.title(n: streak),
    ),
    .streakFire => (
      body: messages.streakFire.body(n: streak),
      title: messages.streakFire.title,
    ),
  };
}
