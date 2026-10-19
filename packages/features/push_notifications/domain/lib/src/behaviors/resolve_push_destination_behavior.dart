import 'package:push_notifications_domain/src/entities/push_destination.br.dart';
import 'package:push_notifications_domain/src/entities/reminder_message.dart';

/// Where a push leads, read from its `data`.
///
/// A daily reminder leads to the daily run. Anything this build does not
/// recognise opens Home: a push from a newer server should still open the app.
class ResolvePushDestinationBehavior {
  const ResolvePushDestinationBehavior();

  PushDestination call(Map<String, String> data) =>
      switch ((data[ReminderData.type], data[ReminderData.message])) {
        (ReminderData.dailyReminder, final String messageId) => .dailyRun(
          messageId: messageId,
        ),
        _ => const .home(),
      };
}
