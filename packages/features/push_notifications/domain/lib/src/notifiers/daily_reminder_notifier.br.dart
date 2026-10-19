import 'package:push_notifications_domain/src/behaviors/plan_daily_reminders_behavior.dart';
import 'package:push_notifications_domain/src/entities/reminder_log.br.dart';
import 'package:push_notifications_domain/src/package_name.dart';
import 'package:push_notifications_domain/src/providers.br.dart';
import 'package:push_notifications_domain/src/providers_di.br.dart' as di;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timber/timber.dart';

part 'daily_reminder_notifier.br.g.dart';

/// When the daily reminder goes off, the phone's local time: early evening,
/// when the day's run is likely still to play.
const reminderTime = (hour: 18, minute: 0);

/// The daily reminders: a week of them, planned afresh on every app start and
/// return, on a change of the Settings switch or of the app's language, and
/// at any run's end (see [PlanDailyRemindersBehavior]). Only for a player who
/// has played a run of any kind to its end, with the switch on; cancelled
/// otherwise. Its state is the plan.
///
/// Kept alive so the plan follows the switch and the language for the app's
/// life.
@Riverpod(keepAlive: true)
class DailyReminderNotifier extends _$DailyReminderNotifier {
  /// Each plan's reading of the log through to its scheduling, one after the
  /// other: two plans interleaved would cancel each other's reminders, or
  /// both count the same reminders shown.
  var _writes = Future<void>.value();

  @override
  Future<List<PlannedReminder>> build() async {
    final enabled = ref.watch(di.dailyReminderEnabledProvider.future);
    final language = ref.watch(di.displayLanguageProvider.future);
    final dailyStanding = ref.read(di.dailyStandingProvider);
    final hasCompletedRun = ref.read(di.hasCompletedRunProvider);
    final now = ref.read(di.nowProvider);
    final reminderTimes = ref.read(di.reminderTimesProvider);

    // Cancelled whenever they aren't due, so reminders planned before the
    // switch went off, or before a progress reset, don't linger.
    if (!await enabled || !await hasCompletedRun()) {
      await _inOrder(ref.read(di.cancelDailyReminderProvider));

      return const [];
    }

    final times = await reminderTimes(
      days: reminderDays,
      hour: reminderTime.hour,
      minute: reminderTime.minute,
    );
    final slots = <ReminderSlot>[];

    for (final (day, at) in times.indexed) {
      final (:played, :streak) = await dailyStanding(at.toUtc());

      slots.add((at: at, day: day, played: played, streak: streak));
    }

    if (!ref.mounted) return const [];

    final replace = ref.read(di.replaceRemindersProvider);
    final store = ref.read(di.reminderLogStoreProvider);
    final texts = ref.read(di.reminderTextsProvider);
    final languageCode = await language;
    var planned = const <PlannedReminder>[];

    await _inOrder(() async {
      final log = const PlanDailyRemindersBehavior()(
        log: await store.load(),
        now: now(),
        slots: slots,
      );

      planned = log.planned;
      await store.save(log);
      await replace([
        for (final reminder in log.planned)
          _notificationOf(reminder, language: languageCode, texts: texts),
      ]);
    });

    return planned;
  }

  /// A run of any kind was just played to its end: asks for notifications (the OS
  /// prompts once, then answers from its record) and plans the reminders,
  /// unless the player turned them off.
  Future<void> runFinished() async {
    final askForNotifications = ref.read(askForNotificationsProvider);

    if (!await ref.read(di.dailyReminderEnabledProvider.future)) return;

    try {
      await askForNotifications();
    } on Object catch (error, stackTrace) {
      // Planned all the same: a phone that refused shows nothing, and one
      // that allows it later gets them from then on.
      _log('Asking for notifications failed', error, stackTrace);
    }

    await _replan();
  }

  /// Back in the app: the days are counted from this open, and the phone may
  /// have changed time zone or language since.
  Future<void> resumed() => _replan();

  /// Never throws: a reminder that couldn't be planned is logged, and the
  /// next plan starts from whatever the log then holds.
  Future<void> _inOrder(Future<void> Function() write) => _writes = _writes
      .then((_) => write())
      .onError<Object>(
        (error, stackTrace) =>
            _log('Planning the daily reminders failed', error, stackTrace),
      );

  Future<void> _replan() async {
    if (!ref.mounted) return;

    ref.invalidateSelf();
    await future;
  }

  static di.ReminderNotification _notificationOf(
    PlannedReminder reminder, {
    required String language,
    required di.ReminderTextsFun texts,
  }) {
    final (:body, :title) = texts(
      reminder.message,
      language: language,
      streak: reminder.streak,
    );

    return (
      at: reminder.at,
      body: body,
      data: reminder.message.data,
      title: title,
    );
  }

  static void _log(String message, Object error, StackTrace stackTrace) =>
      Timber.e(
        tag: packageName,
        logMessage: message,
        exception: error,
        stackTrace: stackTrace,
      );
}
