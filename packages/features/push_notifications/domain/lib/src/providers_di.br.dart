import 'package:push_notifications_domain/src/contracts/reminder_log_store.dart';
import 'package:push_notifications_domain/src/entities/reminder_message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

part 'providers_di.br.g.dart';

// push_notifications_domain — inbound dependency-injection slots. The messaging
// and the reminders come from `push`, the daily run's record from the game;
// each throws until the composition layer overrides it.

/// Cancels every daily reminder. Never throws.
typedef CancelDailyReminderFun = Future<void> Function();

/// Whether the daily run of [day]'s UTC day is played to its end, and the
/// streak on that day were nothing else played until then.
typedef DailyStandingFun =
    Future<({bool played, int streak})> Function(DateTime day);

/// Whether a run of any kind was ever played to its end on this device.
typedef HasCompletedRunFun = Future<bool> Function();

typedef NowFun = DateTime Function();

/// A reminder as the OS is handed it.
typedef ReminderNotification = ({
  DateTime at,
  String body,
  Map<String, String> data,
  String title,
});

/// [message]'s words in [language] (`en`, `fr`), naming [streak] if it
/// names one.
typedef ReminderTextsFun =
    ({String body, String title}) Function(
      ReminderMessage message, {
      required String language,
      required int streak,
    });

/// The instant of [hour]:[minute] local time today and on each of the [days]
/// days after, today's first, passed or not.
typedef ReminderTimesFun =
    Future<List<DateTime>> Function({
      required int days,
      required int hour,
      required int minute,
    });

/// [reminders], replacing every one scheduled before. Never throws.
typedef ReplaceRemindersFun =
    Future<void> Function(List<ReminderNotification> reminders);

/// The data of the notification that launched the app, or null.
typedef LaunchMessageFun = Future<Map<String, String>?> Function();

/// The data of each notification tapped while the app runs.
typedef OpenedMessagesFun = Stream<Map<String, String>> Function();

/// Every token FCM mints after the first.
typedef PushTokenChangesFun = Stream<String> Function();

/// The registration token FCM holds right now, or null when there is none yet.
typedef ReadPushTokenFun = Future<String?> Function();

/// Hands a token to whatever tells the server about this install. Never fails
/// at the call site: a report that did not land is the reporter's to log.
typedef ReportPushTokenFun = Future<void> Function(String token);

/// The OS prompt, or its standing answer once there is one.
typedef RequestPushPermissionFun = Future<bool> Function();

@riverpod
AnalyticsSink analyticsSink(Ref ref) => throw UnimplementedError(
  'analyticsSinkProvider must be overridden by the composition layer',
);

@riverpod
CancelDailyReminderFun cancelDailyReminder(Ref ref) => throw UnimplementedError(
  'cancelDailyReminderProvider must be overridden by the composition layer',
);

/// Whether the player wants the daily reminder (Settings).
@riverpod
Future<bool> dailyReminderEnabled(Ref ref) => throw UnimplementedError(
  'dailyReminderEnabledProvider must be overridden by the composition layer',
);

@riverpod
DailyStandingFun dailyStanding(Ref ref) => throw UnimplementedError(
  'dailyStandingProvider must be overridden by the composition layer',
);

/// The language the app shows (`en`, `fr`), now and on every change.
@riverpod
Stream<String> displayLanguage(Ref ref) => throw UnimplementedError(
  'displayLanguageProvider must be overridden by the composition layer',
);

@riverpod
HasCompletedRunFun hasCompletedRun(Ref ref) => throw UnimplementedError(
  'hasCompletedRunProvider must be overridden by the composition layer',
);

@riverpod
LaunchMessageFun launchMessage(Ref ref) => throw UnimplementedError(
  'launchMessageProvider must be overridden by the composition layer',
);

@riverpod
NowFun now(Ref ref) => throw UnimplementedError(
  'nowProvider must be overridden by the composition layer',
);

@riverpod
OpenedMessagesFun openedMessages(Ref ref) => throw UnimplementedError(
  'openedMessagesProvider must be overridden by the composition layer',
);

@riverpod
PushTokenChangesFun pushTokenChanges(Ref ref) => throw UnimplementedError(
  'pushTokenChangesProvider must be overridden by the composition layer',
);

@riverpod
ReadPushTokenFun readPushToken(Ref ref) => throw UnimplementedError(
  'readPushTokenProvider must be overridden by the composition layer',
);

@riverpod
ReminderLogStore reminderLogStore(Ref ref) => throw UnimplementedError(
  'reminderLogStoreProvider must be overridden by the composition layer',
);

@riverpod
ReminderTextsFun reminderTexts(Ref ref) => throw UnimplementedError(
  'reminderTextsProvider must be overridden by the composition layer',
);

@riverpod
ReminderTimesFun reminderTimes(Ref ref) => throw UnimplementedError(
  'reminderTimesProvider must be overridden by the composition layer',
);

@riverpod
ReplaceRemindersFun replaceReminders(Ref ref) => throw UnimplementedError(
  'replaceRemindersProvider must be overridden by the composition layer',
);

@riverpod
ReportPushTokenFun reportPushToken(Ref ref) => throw UnimplementedError(
  'reportPushTokenProvider must be overridden by the composition layer',
);

@riverpod
RequestPushPermissionFun requestPushPermission(
  Ref ref,
) => throw UnimplementedError(
  'requestPushPermissionProvider must be overridden by the composition layer',
);
