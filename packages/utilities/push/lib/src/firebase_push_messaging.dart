import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:push/src/package_name.dart';
import 'package:push/src/push_messaging.dart';
import 'package:timber/timber.dart';

/// FCM behind [PushMessaging], and the only place the two messaging plugins are
/// imported.
///
/// The two platforms need opposite things in the foreground and that asymmetry
/// is the whole reason this class is not thinner: iOS is told to present the
/// push itself, while Android hands the message to the app and draws nothing,
/// so only Android grows a listener and a channel — and a notification drawn by
/// the app comes back through the local plugin when tapped, not through FCM.
final class FirebasePushMessaging implements PushMessaging {
  static const _channelId = 'announcements';

  StreamSubscription<RemoteMessage>? _foregroundSubscription;

  static const _icon = 'ic_stat_notification';

  final Stream<RemoteMessage>? _injectedMessages;
  final FirebaseMessaging? _injectedMessaging;
  final Stream<RemoteMessage>? _injectedOpenedMessages;
  final FlutterLocalNotificationsPlugin _localNotifications;

  /// Taps on what [_listenInForeground] drew. Broadcast, like FCM's own opened
  /// stream: a tap nobody is listening for has nowhere to go anyway.
  final _localTaps = StreamController<Map<String, String>>.broadcast();

  /// Clear of the daily reminders' ids (1, and 100 on), which cancelling them
  /// would otherwise take down.
  int _nextNotificationId = 1000;

  /// Every argument is optional so the composition layer can write
  /// `FirebasePushMessaging()` and stay free of the two plugins; they are here
  /// for tests. [foregroundMessages] and [openedMessages] have to be among them
  /// at all: `FirebaseMessaging.onMessage` and `.onMessageOpenedApp` are
  /// static, so they cannot arrive through [messaging].
  FirebasePushMessaging({
    Stream<RemoteMessage>? foregroundMessages,
    FlutterLocalNotificationsPlugin? localNotifications,
    FirebaseMessaging? messaging,
    Stream<RemoteMessage>? openedMessages,
  }) : _injectedMessages = foregroundMessages,
       _injectedMessaging = messaging,
       _injectedOpenedMessages = openedMessages,
       _localNotifications =
           localNotifications ?? FlutterLocalNotificationsPlugin();

  /// Resolved on use, never in the constructor: `FirebaseMessaging.instance`
  /// throws until `Firebase.initializeApp` has run, and constructing this is
  /// wiring, which happens before boot gets that far.
  Stream<RemoteMessage> get _foregroundMessages =>
      _injectedMessages ?? FirebaseMessaging.onMessage;

  FirebaseMessaging get _messaging =>
      _injectedMessaging ?? FirebaseMessaging.instance;

  Stream<RemoteMessage> get _openedRemoteMessages =>
      _injectedOpenedMessages ?? FirebaseMessaging.onMessageOpenedApp;

  @override
  Future<String?> currentToken() async {
    try {
      return await _messaging.getToken();
    } catch (error, stackTrace) {
      // iOS throws `apns-token-not-set` until APNs answers, which is ordinary
      // on a first launch. The token arrives later through [tokenChanges], and
      // a caller reporting telemetry should not fail over its absence.
      //
      // The token itself is never logged: it is a push credential.
      Timber.w(
        tag: packageName,
        logMessage: 'No FCM token yet',
        exception: error,
        stackTrace: stackTrace,
      );

      return null;
    }
  }

  @override
  Future<void> initialize({
    required String channelDescription,
    required String channelName,
  }) async {
    // Every request flag is off. They default to true, which would put the OS
    // prompt over the splash — the shelf owns that moment, through
    // [requestPermission].
    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings(_icon),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: _onLocalTap,
    );

    if (defaultTargetPlatform != .android) {
      // Presentation options are iOS's entire foreground story. Adding the
      // listener below on top of them would draw a second banner. No badge:
      // the app is open, so the icon would keep a 1 nobody clears until the
      // next launch.
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: false,
        sound: true,
      );

      return;
    }

    await _createChannel(
      channelDescription: channelDescription,
      channelName: channelName,
    );

    _listenInForeground(
      channelDescription: channelDescription,
      channelName: channelName,
    );
  }

  /// FCM first: it is what the OS drew in the background. The local plugin's
  /// answer only matters for a notification the app drew in the foreground and
  /// that outlived it, which FCM knows nothing about.
  @override
  Future<Map<String, String>?> launchMessage() async {
    try {
      final message = await _messaging.getInitialMessage();

      if (message != null) return _stringsOf(message.data);

      final details = await _localNotifications
          .getNotificationAppLaunchDetails();

      if (details == null || !details.didNotificationLaunchApp) return null;

      return _decode(details.notificationResponse?.payload);
    } catch (error, stackTrace) {
      Timber.w(
        tag: packageName,
        logMessage: 'Reading the launching notification threw',
        exception: error,
        stackTrace: stackTrace,
      );

      return null;
    }
  }

  @override
  Stream<Map<String, String>> get openedMessages => Stream.multi((controller) {
    final remote = _openedRemoteMessages.listen(
      (message) => controller.add(_stringsOf(message.data)),
    );
    final local = _localTaps.stream.listen(controller.add);

    controller.onCancel = () => Future.wait([remote.cancel(), local.cancel()]);
  });

  @override
  Stream<Map<String, String>> get receivedMessages =>
      _foregroundMessages.map((message) => _stringsOf(message.data));

  @override
  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission();

    return switch (settings.authorizationStatus) {
      .authorized || .provisional => true,
      _ => false,
    };
  }

  @override
  Stream<String> get tokenChanges => _messaging.onTokenRefresh;

  /// Re-created on every launch rather than once per install. The id and the
  /// importance are frozen after the first time, but the name and description
  /// are not — and re-sending them is what keeps the entry in the phone's
  /// system settings in the language the phone is set to now.
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

  /// The payload is what [_listenInForeground] wrote, so anything else — an
  /// empty payload, or one from before payloads were written — is no message.
  Map<String, String>? _decode(String? payload) {
    if (payload == null || payload.isEmpty) return null;

    try {
      final decoded = jsonDecode(payload);

      return decoded is Map<String, dynamic> ? _stringsOf(decoded) : null;
    } on FormatException {
      return null;
    }
  }

  void _listenInForeground({
    required String channelDescription,
    required String channelName,
  }) {
    unawaited(_foregroundSubscription?.cancel());

    _foregroundSubscription = _foregroundMessages.listen((message) {
      final notification = message.notification;

      // A data-only message has nothing to draw.
      if (notification == null) return;

      _localNotifications
          .show(
            id: _nextNotificationId++,
            title: notification.title,
            body: notification.body,
            notificationDetails: NotificationDetails(
              android: AndroidNotificationDetails(
                _channelId,
                channelName,
                channelDescription: channelDescription,
                importance: .high,
                priority: .high,
              ),
            ),
            // Carried so a tap on it can be routed like one the OS drew.
            payload: jsonEncode(message.data),
          )
          .unawait(
            tag: packageName,
            logMessage: 'Drawing a foreground notification threw',
          );
    });
  }

  void _onLocalTap(NotificationResponse response) {
    final data = _decode(response.payload);

    if (data != null) _localTaps.add(data);
  }

  /// FCM's data values are strings on the wire, typed `dynamic` by the plugin.
  Map<String, String> _stringsOf(Map<String, dynamic> data) => {
    for (final MapEntry(:key, :value) in data.entries) key: '$value',
  };
}
