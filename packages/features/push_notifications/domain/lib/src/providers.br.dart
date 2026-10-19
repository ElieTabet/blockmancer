import 'package:push_notifications_domain/src/behaviors/ask_for_notifications_behavior.dart';
import 'package:push_notifications_domain/src/behaviors/sync_push_token_behavior.dart';
import 'package:push_notifications_domain/src/behaviors/watch_push_destinations_behavior.dart';
import 'package:push_notifications_domain/src/contracts/reminder_log_store.dart';
import 'package:push_notifications_domain/src/entities/push_destination.br.dart';
import 'package:push_notifications_domain/src/package_name.dart';
import 'package:push_notifications_domain/src/providers_di.br.dart' as di;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:timber/timber.dart';

part 'providers.br.g.dart';

// push_notifications_domain — public providers exposed by this layer.

typedef AskForNotificationsFun = Future<void> Function();

/// A function, not a stream provider: two pushes about the same thing are two
/// events, and a provider's value would swallow the second as unchanged.
typedef PushDestinationsFun = Stream<PushDestination> Function();

typedef StartPushTokenSyncFun = void Function();

/// A daily reminder tapped, by its message's id.
typedef TrackNotificationOpenedFun = void Function(String messageId);

/// The permission prompt and the token report behind it. See
/// [AskForNotificationsBehavior] for why they go together, in that order.
@riverpod
AskForNotificationsFun askForNotifications(Ref ref) =>
    AskForNotificationsBehavior(
      requestPermission: ref.watch(di.requestPushPermissionProvider),
      syncToken: SyncPushTokenBehavior(
        readPushToken: ref.watch(di.readPushTokenProvider),
        report: ref.watch(di.reportPushTokenProvider),
      ).call,
    ).call;

@riverpod
PushDestinationsFun pushDestinations(Ref ref) => WatchPushDestinationsBehavior(
  launchMessage: ref.watch(di.launchMessageProvider),
  openedMessages: ref.watch(di.openedMessagesProvider),
).call;

/// Reports every token FCM mints after the first.
///
/// `keepAlive` is what makes "subscribes once" true rather than hopeful: a
/// second start — signing out prepares the device again — reads this same
/// instance instead of opening a second subscription, so no guard flag is
/// needed.
///
/// Nothing starts it but [startPushTokenSyncProvider], which `device` calls
/// only once registration has succeeded: a report before that could only 401.
@Riverpod(keepAlive: true)
void pushTokenSync(Ref ref) {
  final report = ref.watch(di.reportPushTokenProvider);

  final subscription = ref
      .watch(di.pushTokenChangesProvider)()
      .listen(
        (token) => report(token).unawait(
          tag: packageName,
          logMessage: 'Reporting a refreshed push token threw',
        ),
      );

  ref.onDispose(subscription.cancel);
}

/// `keepAlive` because the caller holds the function across an await: an
/// auto-disposed provider could be gone by the time it is called, and its
/// `ref` with it.
@Riverpod(keepAlive: true)
StartPushTokenSyncFun startPushTokenSync(Ref ref) =>
    () => ref.read(pushTokenSyncProvider);

@riverpod
TrackNotificationOpenedFun trackNotificationOpened(Ref ref) {
  final sink = ref.watch(di.analyticsSinkProvider);

  return (messageId) => sink.log(.notificationOpened(messageId: messageId));
}

/// Binds this layer's inbound slots: the messaging and the reminders
/// (composition, pointing at `push`), the runs' record (the game) and
/// the report.
List<Override> bindProviders({
  required AnalyticsSink Function(Ref ref) analyticsSink,
  required di.CancelDailyReminderFun Function(Ref ref) cancelDailyReminder,
  required Future<bool> Function(Ref ref) dailyReminderEnabled,
  required di.DailyStandingFun Function(Ref ref) dailyStanding,
  required Stream<String> Function(Ref ref) displayLanguage,
  required di.HasCompletedRunFun Function(Ref ref) hasCompletedRun,
  required di.LaunchMessageFun Function(Ref ref) launchMessage,
  required di.NowFun Function(Ref ref) now,
  required di.OpenedMessagesFun Function(Ref ref) openedMessages,
  required di.PushTokenChangesFun Function(Ref ref) pushTokenChanges,
  required di.ReadPushTokenFun Function(Ref ref) readPushToken,
  required ReminderLogStore Function(Ref ref) reminderLogStore,
  required di.ReminderTextsFun Function(Ref ref) reminderTexts,
  required di.ReminderTimesFun Function(Ref ref) reminderTimes,
  required di.ReplaceRemindersFun Function(Ref ref) replaceReminders,
  required di.ReportPushTokenFun Function(Ref ref) reportPushToken,
  required di.RequestPushPermissionFun Function(Ref ref) requestPushPermission,
}) => [
  di.analyticsSinkProvider.overrideWith(analyticsSink),
  di.cancelDailyReminderProvider.overrideWith(cancelDailyReminder),
  di.dailyReminderEnabledProvider.overrideWith(dailyReminderEnabled),
  di.dailyStandingProvider.overrideWith(dailyStanding),
  di.displayLanguageProvider.overrideWith(displayLanguage),
  di.hasCompletedRunProvider.overrideWith(hasCompletedRun),
  di.launchMessageProvider.overrideWith(launchMessage),
  di.nowProvider.overrideWith(now),
  di.openedMessagesProvider.overrideWith(openedMessages),
  di.pushTokenChangesProvider.overrideWith(pushTokenChanges),
  di.readPushTokenProvider.overrideWith(readPushToken),
  di.reminderLogStoreProvider.overrideWith(reminderLogStore),
  di.reminderTextsProvider.overrideWith(reminderTexts),
  di.reminderTimesProvider.overrideWith(reminderTimes),
  di.replaceRemindersProvider.overrideWith(replaceReminders),
  di.reportPushTokenProvider.overrideWith(reportPushToken),
  di.requestPushPermissionProvider.overrideWith(requestPushPermission),
];
