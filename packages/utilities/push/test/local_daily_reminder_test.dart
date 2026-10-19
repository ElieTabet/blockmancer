import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:push/push.dart';
import 'package:timezone/timezone.dart' as tz;

class _MockAndroid extends Mock
    implements AndroidFlutterLocalNotificationsPlugin {}

class _MockLocalNotifications extends Mock
    implements FlutterLocalNotificationsPlugin {}

void main() {
  late _MockAndroid android;
  late _MockLocalNotifications localNotifications;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(const AndroidNotificationChannel('id', 'name'));
    registerFallbackValue(const NotificationDetails());
    registerFallbackValue(AndroidScheduleMode.inexactAllowWhileIdle);
    registerFallbackValue(tz.TZDateTime.utc(2026));
  });

  setUp(() {
    android = _MockAndroid();
    localNotifications = _MockLocalNotifications();

    when(
      () => localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >(),
    ).thenReturn(android);
    when(
      () => localNotifications.cancel(id: any(named: 'id')),
    ).thenAnswer((_) async {});
    when(
      () => android.createNotificationChannel(any()),
    ).thenAnswer((_) async {});
    when(
      () => localNotifications.zonedSchedule(
        id: any(named: 'id'),
        title: any(named: 'title'),
        body: any(named: 'body'),
        scheduledDate: any(named: 'scheduledDate'),
        notificationDetails: any(named: 'notificationDetails'),
        androidScheduleMode: any(named: 'androidScheduleMode'),
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) async {});
  });

  test('Given an Android phone, When the reminders are planned, Then they go '
      'out on a channel that drops a banner', () async {
    // When
    await LocalDailyReminder(localNotifications: localNotifications).replace(
      [
        (
          at: DateTime.utc(2026, 10, 20, 16),
          body: 'body',
          data: const {'type': 'daily_reminder'},
          title: '🧩 title',
        ),
      ],
      channelDescription: 'One nudge a day',
      channelName: 'Daily run reminder',
    );

    // Then
    final channel =
        verify(
              () => android.createNotificationChannel(captureAny()),
            ).captured.single
            as AndroidNotificationChannel;

    expect(
      (channel.id, channel.name, channel.importance),
      ('daily_reminder', 'Daily run reminder', Importance.high),
    );

    final details =
        verify(
              () => localNotifications.zonedSchedule(
                id: 100,
                title: '🧩 title',
                body: 'body',
                scheduledDate: any(named: 'scheduledDate'),
                notificationDetails: captureAny(named: 'notificationDetails'),
                androidScheduleMode: .inexactAllowWhileIdle,
                payload: '{"type":"daily_reminder"}',
              ),
            ).captured.single
            as NotificationDetails;

    expect(
      (
        details.android?.channelId,
        details.android?.importance,
        details.android?.priority,
      ),
      ('daily_reminder', Importance.high, Priority.high),
    );
  });
}
