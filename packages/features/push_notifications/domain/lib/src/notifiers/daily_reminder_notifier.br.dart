import 'package:push_notifications_domain/src/package_name.dart';
import 'package:push_notifications_domain/src/providers.br.dart';
import 'package:push_notifications_domain/src/providers_di.br.dart' as di;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timber/timber.dart';

part 'daily_reminder_notifier.br.g.dart';

/// When the daily reminder goes off, the phone's local time: early evening,
/// when the day's run is likely still to play.
const reminderTime = (hour: 18, minute: 0);

/// The daily reminder: scheduled only for a player who has played a daily run
/// to its end, with the switch on; cancelled otherwise. Its state is the time
/// zone it was scheduled in, null when there is none, so a change of zone
/// reschedules it at the new local time.
///
/// Kept alive so that zone outlives the screens: it is read again on every
/// return to the app.
@Riverpod(keepAlive: true)
class DailyReminderNotifier extends _$DailyReminderNotifier {
  @override
  Future<String?> build() async {
    final enabled = await ref.watch(di.dailyReminderEnabledProvider.future);
    final hasPlayedDaily = ref.read(di.hasPlayedDailyProvider);
    final scheduleReminder = ref.read(di.scheduleDailyReminderProvider);
    final timeZone = ref.read(di.currentTimeZoneProvider);

    // Cancelled whenever it isn't due, so a reminder scheduled before the
    // switch went off, or before a progress reset, doesn't linger.
    if (!enabled || !await hasPlayedDaily()) {
      await ref.read(di.cancelDailyReminderProvider)();

      return null;
    }

    final zone = await timeZone();
    await scheduleReminder(
      hour: reminderTime.hour,
      minute: reminderTime.minute,
    );

    return zone;
  }

  /// A daily run was just played to its end: asks for notifications (the OS
  /// prompts once, then answers from its record) and schedules the reminder,
  /// unless the player turned it off.
  Future<void> dailyRunFinished() async {
    final askForNotifications = ref.read(askForNotificationsProvider);

    if (!await ref.read(di.dailyReminderEnabledProvider.future)) return;

    try {
      await askForNotifications();
    } on Object catch (error, stackTrace) {
      // Scheduled all the same: a phone that refused shows nothing, and one
      // that allows it later gets it from then on.
      Timber.e(
        tag: packageName,
        logMessage: 'Asking for notifications failed',
        exception: error,
        stackTrace: stackTrace,
      );
    }

    if (!ref.mounted) return;

    ref.invalidateSelf();
    await future;
  }

  /// Back in the app: reschedules when the phone has changed time zone since,
  /// so the reminder keeps to the local time.
  Future<void> resumed() async {
    final scheduledIn = await future;

    if (scheduledIn == null || !ref.mounted) return;

    if (await ref.read(di.currentTimeZoneProvider)() == scheduledIn) return;

    if (!ref.mounted) return;

    ref.invalidateSelf();
    await future;
  }
}
