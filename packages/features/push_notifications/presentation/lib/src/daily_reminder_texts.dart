import 'package:l10n_application/l10n_application.dart';

/// What the daily reminder says, and the Android channel it is filed under.
typedef DailyReminderTexts = ({
  String body,
  String channelDescription,
  String channelName,
  String title,
});

/// Read when the reminder is scheduled, so it speaks the language the app
/// shows then.
DailyReminderTexts dailyReminderTexts() {
  final reminder = t.push.reminder;

  return (
    body: reminder.body,
    channelDescription: reminder.channelDescription,
    channelName: reminder.channelName,
    title: reminder.title,
  );
}
