import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:push/src/daily_reminder.dart';
import 'package:push/src/package_name.dart';
import 'package:timber/timber.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// [DailyReminder] over flutter_local_notifications' `zonedSchedule`, each
/// reminder once. The plugin itself is initialised by
/// `FirebasePushMessaging.initialize`, at launch, before anything schedules.
final class LocalDailyReminder implements DailyReminder {
  LocalDailyReminder({FlutterLocalNotificationsPlugin? localNotifications})
    : _localNotifications =
          localNotifications ?? FlutterLocalNotificationsPlugin();

  static const _channelId = 'daily_reminder';
  static const _firstId = 100;
  final FlutterLocalNotificationsPlugin _localNotifications;

  /// The time zone database, loaded on first use: it takes a moment.
  static var _zonesLoaded = false;

  @override
  Future<void> cancel() async {
    try {
      for (var index = 0; index < DailyReminder.maxReminders; index++) {
        await _localNotifications.cancel(id: _firstId + index);
      }
    } catch (error, stackTrace) {
      _log('Cancelling the daily reminders failed', error, stackTrace);
    }
  }

  @override
  Future<void> replace(
    List<ReminderNotification> reminders, {
    required String channelDescription,
    required String channelName,
  }) async {
    await cancel();

    try {
      await _createChannel(
        channelDescription: channelDescription,
        channelName: channelName,
      );

      final zone = tz.getLocation(await timeZone());
      final details = NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          channelName,
          channelDescription: channelDescription,
          importance: .high,
          priority: .high,
        ),
      );

      for (final (index, reminder)
          in reminders.take(DailyReminder.maxReminders).indexed) {
        await _localNotifications.zonedSchedule(
          id: _firstId + index,
          title: reminder.title,
          body: reminder.body,
          scheduledDate: tz.TZDateTime.from(reminder.at, zone),
          notificationDetails: details,
          // Inexact: a reminder minutes late is fine, and exact alarms need a
          // permission Play audits.
          androidScheduleMode: .inexactAllowWhileIdle,
          // The JSON FirebasePushMessaging reads back from a tap.
          payload: jsonEncode(reminder.data),
        );
      }
    } catch (error, stackTrace) {
      _log('Scheduling the daily reminders failed', error, stackTrace);
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

  @override
  Future<List<DateTime>> upcoming({
    required int days,
    required int hour,
    required int minute,
  }) async {
    final zone = tz.getLocation(await timeZone());
    final now = tz.TZDateTime.now(zone);

    return [
      for (var day = 0; day <= days; day++)
        tz.TZDateTime(
          zone,
          now.year,
          now.month,
          now.day + day,
          hour,
          minute,
        ).toUtc(),
    ];
  }

  /// Created before the plugin would make it at the default importance, which
  /// draws no banner and which Android never lets an app raise afterwards.
  /// Re-created with every plan, so its name follows the app's language.
  Future<void> _createChannel({
    required String channelDescription,
    required String channelName,
  }) async {
    final android = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await android?.createNotificationChannel(
      AndroidNotificationChannel(
        _channelId,
        channelName,
        description: channelDescription,
        importance: .high,
      ),
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
