import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:push/push.dart';
import 'package:timber/timber.dart';

class _MockLocalNotifications extends Mock
    implements FlutterLocalNotificationsPlugin {}

class _MockMessaging extends Mock implements FirebaseMessaging {}

class _RecordingTree implements Tree {
  final List<String> lines = [];

  @override
  void log(
    LogLevel level, {
    required String tag,
    required String logMessage,
    Object? exception,
    StackTrace? stackTrace,
  }) => lines.add('$tag $logMessage $exception');
}

void main() {
  late StreamController<RemoteMessage> foreground;
  late _MockLocalNotifications localNotifications;
  late _MockMessaging messaging;
  late StreamController<RemoteMessage> opened;
  late _RecordingTree tree;

  setUpAll(() {
    registerFallbackValue(const AndroidNotificationChannel('id', 'name'));
    registerFallbackValue(const NotificationDetails());
    registerFallbackValue(const InitializationSettings());
  });

  setUp(() {
    foreground = StreamController<RemoteMessage>.broadcast();
    localNotifications = _MockLocalNotifications();
    messaging = _MockMessaging();
    opened = StreamController<RemoteMessage>.broadcast();
    tree = _RecordingTree();

    Timber.plant(tree);

    when(
      () => localNotifications.initialize(
        settings: any(named: 'settings'),
        onDidReceiveNotificationResponse: any(
          named: 'onDidReceiveNotificationResponse',
        ),
      ),
    ).thenAnswer((_) async => true);
    when(
      () => localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >(),
    ).thenReturn(null);
    when(
      () => localNotifications.show(
        id: any(named: 'id'),
        title: any(named: 'title'),
        body: any(named: 'body'),
        notificationDetails: any(named: 'notificationDetails'),
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => messaging.setForegroundNotificationPresentationOptions(
        alert: any(named: 'alert'),
        badge: any(named: 'badge'),
        sound: any(named: 'sound'),
      ),
    ).thenAnswer((_) async {});
  });

  tearDown(() {
    Timber.chop(tree);
    debugDefaultTargetPlatformOverride = null;

    return Future.wait([foreground.close(), opened.close()]);
  });

  FirebasePushMessaging subject() => FirebasePushMessaging(
    localNotifications: localNotifications,
    messaging: messaging,
    foregroundMessages: foreground.stream,
    openedMessages: opened.stream,
  );

  Future<FirebasePushMessaging> initializeOn(TargetPlatform platform) async {
    debugDefaultTargetPlatformOverride = platform;

    final messaging = subject();

    await messaging.initialize(
      channelDescription: 'App announcements',
      channelName: 'Announcements',
    );

    return messaging;
  }

  RemoteMessage messageWith({
    Map<String, dynamic> data = const {},
    String? title,
  }) => RemoteMessage(
    data: data,
    notification: title == null
        ? null
        : RemoteNotification(title: title, body: 'body'),
  );

  /// The callback the local plugin was handed, invoked the way it would be by
  /// a tap on a notification carrying each of [payloads].
  void tapLocal(List<String?> payloads) {
    final onTap =
        verify(
              () => localNotifications.initialize(
                settings: any(named: 'settings'),
                onDidReceiveNotificationResponse: captureAny(
                  named: 'onDidReceiveNotificationResponse',
                ),
              ),
            ).captured.last
            as DidReceiveNotificationResponseCallback;

    for (final payload in payloads) {
      onTap(
        NotificationResponse(
          notificationResponseType: .selectedNotification,
          payload: payload,
        ),
      );
    }
  }

  // Ordinary on a first launch: FCM has no token until APNs answers, and
  // telemetry must not fail over it.
  test(
    'currentToken answers null rather than throwing on apns-token-not-set',
    () async {
      when(() => messaging.getToken()).thenThrow(
        FirebaseException(
          plugin: 'firebase_messaging',
          code: 'apns-token-not-set',
        ),
      );

      await expectLater(subject().currentToken(), completion(isNull));
    },
  );

  test('currentToken answers the token when there is one', () async {
    when(() => messaging.getToken()).thenAnswer((_) async => 'a-token');

    await expectLater(subject().currentToken(), completion('a-token'));
  });

  // A push credential never belongs in a log line, the same rule the device
  // data source already follows.
  test('the token never reaches a log line', () async {
    when(() => messaging.getToken()).thenAnswer((_) async => 'a-token');

    await subject().currentToken();

    expect(tree.lines.where((line) => line.contains('a-token')), isEmpty);
  });

  // Android hands a foreground message to the app and draws nothing itself.
  test('a foreground notification is drawn on Android', () async {
    await initializeOn(.android);

    foreground.add(messageWith(title: 'Rehearsal moved'));
    await pumpEventQueue();

    verify(
      () => localNotifications.show(
        id: any(named: 'id'),
        title: 'Rehearsal moved',
        body: 'body',
        notificationDetails: any(named: 'notificationDetails'),
        payload: any(named: 'payload'),
      ),
    ).called(1);
  });

  // Nothing to draw, and with no tap handling nothing a tap could do.
  test('a data-only message draws nothing', () async {
    await initializeOn(.android);

    foreground.add(messageWith());
    await pumpEventQueue();

    verifyNever(
      () => localNotifications.show(
        id: any(named: 'id'),
        title: any(named: 'title'),
        body: any(named: 'body'),
        notificationDetails: any(named: 'notificationDetails'),
        payload: any(named: 'payload'),
      ),
    );
  });

  // The presentation options already show it; a listener would be a second
  // banner for the same push.
  test('iOS installs no foreground listener', () async {
    await initializeOn(.iOS);

    foreground.add(messageWith(title: 'Rehearsal moved'));
    await pumpEventQueue();

    verifyNever(
      () => localNotifications.show(
        id: any(named: 'id'),
        title: any(named: 'title'),
        body: any(named: 'body'),
        notificationDetails: any(named: 'notificationDetails'),
        payload: any(named: 'payload'),
      ),
    );
    verify(
      () => messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: false,
        sound: true,
      ),
    ).called(1);
  });

  // Left at their defaults these ask for permission during boot, which is the
  // shelf's moment, not the splash's.
  test(
    'local notifications are initialized without requesting permission',
    () async {
      await initializeOn(.iOS);

      final settings =
          verify(
                () => localNotifications.initialize(
                  settings: captureAny(named: 'settings'),
                  onDidReceiveNotificationResponse: any(
                    named: 'onDidReceiveNotificationResponse',
                  ),
                ),
              ).captured.single
              as InitializationSettings;
      final darwin = settings.iOS!;

      expect(darwin.requestAlertPermission, isFalse);
      expect(darwin.requestBadgePermission, isFalse);
      expect(darwin.requestSoundPermission, isFalse);
    },
  );

  group('launchMessage', () {
    setUp(() {
      when(() => messaging.getInitialMessage()).thenAnswer((_) async => null);
      when(
        () => localNotifications.getNotificationAppLaunchDetails(),
      ).thenAnswer((_) async => null);
    });

    test('answers the data of the push the OS drew', () async {
      when(
        () => messaging.getInitialMessage(),
      ).thenAnswer((_) async => messageWith(data: {'newsItemId': '7'}));

      await expectLater(
        subject().launchMessage(),
        completion({'newsItemId': '7'}),
      );
    });

    // Drawn by the app in the foreground, then tapped after the app died: FCM
    // never knew about that tap.
    test('answers the data of a notification the app drew itself', () async {
      when(
        () => localNotifications.getNotificationAppLaunchDetails(),
      ).thenAnswer(
        (_) async => const NotificationAppLaunchDetails(
          true,
          notificationResponse: NotificationResponse(
            notificationResponseType: .selectedNotification,
            payload: '{"publicationId":"3","action":"added"}',
          ),
        ),
      );

      await expectLater(
        subject().launchMessage(),
        completion({'publicationId': '3', 'action': 'added'}),
      );
    });

    test('answers null when no notification launched the app', () async {
      await expectLater(subject().launchMessage(), completion(isNull));
    });

    test('answers null rather than throwing', () async {
      when(
        () => messaging.getInitialMessage(),
      ).thenThrow(FirebaseException(plugin: 'firebase_messaging'));

      await expectLater(subject().launchMessage(), completion(isNull));
    });
  });

  group('openedMessages', () {
    test('carries a tap on a push the OS drew', () async {
      final tapped = <Map<String, String>>[];
      final subscription = subject().openedMessages.listen(tapped.add);
      addTearDown(subscription.cancel);

      opened.add(messageWith(data: {'newsItemId': 7}));
      await pumpEventQueue();

      expect(tapped, [
        {'newsItemId': '7'},
      ]);
    });

    // What Android drew in the foreground comes back with the data it was
    // drawn from, so routing cannot tell the two apart.
    test('carries a tap on what the app drew in the foreground', () async {
      final messaging = await initializeOn(.android);
      final tapped = <Map<String, String>>[];
      final subscription = messaging.openedMessages.listen(tapped.add);
      addTearDown(subscription.cancel);

      foreground.add(
        messageWith(data: {'newsItemId': '7'}, title: 'Rehearsal moved'),
      );
      await pumpEventQueue();

      final payload =
          verify(
                () => localNotifications.show(
                  id: any(named: 'id'),
                  title: any(named: 'title'),
                  body: any(named: 'body'),
                  notificationDetails: any(named: 'notificationDetails'),
                  payload: captureAny(named: 'payload'),
                ),
              ).captured.single
              as String;

      tapLocal([payload]);
      await pumpEventQueue();

      expect(tapped, [
        {'newsItemId': '7'},
      ]);
    });

    test('drops a tap whose payload is not ours', () async {
      final messaging = await initializeOn(.android);
      final tapped = <Map<String, String>>[];
      final subscription = messaging.openedMessages.listen(tapped.add);
      addTearDown(subscription.cancel);

      tapLocal(['not json', '[1]', null]);
      await pumpEventQueue();

      expect(tapped, isEmpty);
    });
  });

  // What lets a screen catch up on what a push announces while it is open.
  test('carries every push that arrives in front', () async {
    final received = <Map<String, String>>[];
    final subscription = subject().receivedMessages.listen(received.add);
    addTearDown(subscription.cancel);

    foreground
      ..add(messageWith(data: {'newsItemId': 7}, title: 'Rehearsal moved'))
      ..add(messageWith(data: {'newsItemId': '8'}));
    await pumpEventQueue();

    expect(received, [
      {'newsItemId': '7'},
      {'newsItemId': '8'},
    ]);
  });
}
