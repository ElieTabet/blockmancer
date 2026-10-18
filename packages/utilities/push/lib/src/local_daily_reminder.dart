import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:push/src/daily_reminder.dart';
import 'package:push/src/package_name.dart';
import 'package:timber/timber.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// [DailyReminder] over flutter_local_notifications' `zonedSchedule`, repeating
/// on the time of day. The plugin itself is initialised by
/// `FirebasePushMessaging.initialize`, at launch, before anything schedules.
final class LocalDailyReminder implements DailyReminder {
  LocalDailyReminder({FlutterLocalNotificationsPlugin? localNotifications})
    : _localNotifications =
          localNotifications ?? FlutterLocalNotificationsPlugin();

  static const _channelId = 'daily_reminder';
  static const _id = 1;
  final FlutterLocalNotificationsPlugin _localNotifications;

  /// The time zone database, loaded on first use: it takes a moment.
  static var _zonesLoaded = false;

  @override
  Future<void> cancel() async {
    try {
      await _localNotifications.cancel(id: _id);
    } catch (error, stackTrace) {
      _log('Cancelling the daily reminder failed', error, stackTrace);
    }
  }

  @override
  Future<void> schedule({
    required String body,
    required String channelDescription,
    required String channelName,
    required int hour,
    required int minute,
    required String title,
  }) async {
    try {
      final zone = tz.getLocation(await timeZone());
      final now = tz.TZDateTime.now(zone);
      final today = tz.TZDateTime(
        zone,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      await _localNotifications.zonedSchedule(
        id: _id,
        title: title,
        body: body,
        scheduledDate: today.isAfter(now)
            ? today
            : today.add(const Duration(days: 1)),
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            channelName,
            channelDescription: channelDescription,
          ),
        ),
        // Inexact: a reminder minutes late is fine, and exact alarms need a
        // permission Play audits.
        androidScheduleMode: .inexactAllowWhileIdle,
        matchDateTimeComponents: .time,
      );
    } catch (error, stackTrace) {
      _log('Scheduling the daily reminder failed', error, stackTrace);
    }
  }

  @override
  Future<String> timeZone() async {
    try {
      if (!_zonesLoaded) {
        tz_data.initializeTimeZones();
        _zonesLoaded = true;
      }

      final name = (await FlutterTimezone.getLocalTimezone()).identifier;

      // A name the database lacks would make the schedule throw.
      tz.getLocation(name);

      return name;
    } catch (error, stackTrace) {
      _log('Reading the time zone failed', error, stackTrace);

      return 'UTC';
    }
  }

  static void _log(String message, Object error, StackTrace stackTrace) =>
      Timber.e(
        tag: packageName,
        logMessage: message,
        exception: error,
        stackTrace: stackTrace,
      );
}
