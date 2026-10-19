import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_notifications_domain/push_notifications_domain.dart'
    as push_notifications_domain;
import 'package:push_notifications_domain/push_notifications_domain.dart'
    show PushDestination, pushDestinationsProvider;
import 'package:push_notifications_presentation/push_notifications_presentation.dart';
import 'package:shared_domain/shared_domain.dart';

final class _NoAnalytics implements AnalyticsSink {
  const _NoAnalytics();

  @override
  void log(AnalyticsEvent event) {}
}

final class _RecordingRouting implements PushNotificationsRouting {
  final List<String> calls;

  _RecordingRouting(this.calls);

  @override
  void onDailyRunOpened() => calls.add('daily run');

  @override
  void onHomeOpened() => calls.add('home');
}

void main() {
  late List<String> calls;
  late StreamController<PushDestination> destinations;
  late int listens;

  setUp(() {
    calls = [];
    destinations = StreamController<PushDestination>.broadcast();
    listens = 0;
  });

  tearDown(() => destinations.close());

  Future<InitializePushNotificationsFun> initialize({
    Object? setupError,
  }) async {
    final container = ProviderContainer(
      overrides: [
        push_notifications_domain.trackNotificationOpenedProvider.overrideWith(
          (ref) =>
              (messageId) => calls.add('opened $messageId'),
        ),
        pushDestinationsProvider.overrideWith(
          (ref) => () {
            listens++;

            return destinations.stream;
          },
        ),
        ...bindProviders(
          initializeMessaging: (ref) =>
              ({required channelDescription, required channelName}) async {
                if (setupError != null) throw setupError;

                calls.add('initialize $channelName');
              },
          reportNonFatal: (ref) =>
              (error, stackTrace, {required reason}) async =>
                  calls.add('report $error'),
        ),
        ...bindRoutingProviders(
          pushNotificationsRouting: (ref) => _RecordingRouting(calls),
        ),
      ],
    );

    addTearDown(container.dispose);

    final initialize = container.read(initializePushNotificationsProvider);

    await initialize(channelDescription: 'News', channelName: 'Announcements');

    return initialize;
  }

  Future<void> tap(PushDestination destination) async {
    destinations.add(destination);
    await pumpEventQueue();
  }

  // A tap Android reports on what the app drew needs the plugin that drew it
  // initialized first.
  test('initializes messaging before listening for taps', () async {
    await initialize();

    expect(calls, ['initialize Announcements']);
    expect(listens, 1);
  });

  // Boot awaits this before runApp: a throw would leave the app on its splash.
  test(
    'a failed messaging setup is reported, and taps are still listened for',
    () async {
      await expectLater(
        initialize(setupError: StateError('no icon')),
        completes,
      );

      expect(calls, ['report Bad state: no icon']);
      expect(listens, 1);
    },
  );

  test('a tapped push opens home', () async {
    await initialize();
    await tap(const PushDestination.home());

    expect(calls.last, 'home');
  });

  test('a tapped daily reminder is counted by its message, then opens the '
      'daily run', () async {
    await initialize();
    await tap(const PushDestination.dailyRun(messageId: 'combo_time'));

    expect(calls.sublist(calls.length - 2), ['opened combo_time', 'daily run']);
  });

  // The launch push is read once per launch, so a second listener would be
  // a second read — and every later tap opened twice.
  test('initializing twice still listens once', () async {
    final initializeAgain = await initialize();

    await initializeAgain(channelDescription: 'News', channelName: 'Annonces');
    await tap(const PushDestination.home());

    expect(listens, 1);
    expect(calls.where((call) => call == 'home'), hasLength(1));
  });

  // Through the real domain chain, wired the way composition wires it: the
  // opened-messages slot is only called after the launch push is known, a
  // platform round trip later. Nothing may let that chain dispose meanwhile —
  // a slot that reaches its ref then would throw, and no tap would ever open.
  test('taps open after a slow launch read', () async {
    final opened = StreamController<Map<String, String>>.broadcast();
    final messages = Provider((ref) => opened.stream);

    addTearDown(opened.close);

    final container = ProviderContainer(
      overrides: [
        ...push_notifications_domain.bindProviders(
          analyticsSink: (ref) => const _NoAnalytics(),
          cancelDailyReminder: (ref) => () async {},
          dailyReminderEnabled: (ref) async => false,
          dailyStanding: (ref) =>
              (day) async => (played: false, streak: 0),
          displayLanguage: (ref) => Stream.value('en'),
          hasCompletedRun: (ref) =>
              () async => false,
          launchMessage: (ref) =>
              () =>
                  Future.delayed(const Duration(milliseconds: 50), () => null),
          now: (ref) => DateTime.now,
          openedMessages: (ref) =>
              () => ref.watch(messages),
          pushTokenChanges: (ref) =>
              () => const Stream.empty(),
          readPushToken: (ref) =>
              () async => null,
          reminderLogStore: (ref) => throw UnimplementedError(),
          reminderTexts: (ref) => reminderMessageTexts,
          reminderTimes: (ref) =>
              ({required days, required hour, required minute}) async => [],
          replaceReminders: (ref) => (reminders) async {},
          reportPushToken: (ref) => (token) async {},
          requestPushPermission: (ref) =>
              () async => true,
        ),
        ...bindProviders(
          initializeMessaging: (ref) =>
              ({required channelDescription, required channelName}) async {},
          reportNonFatal: (ref) =>
              (error, stackTrace, {required reason}) async {},
        ),
        ...bindRoutingProviders(
          pushNotificationsRouting: (ref) => _RecordingRouting(calls),
        ),
      ],
    );

    addTearDown(container.dispose);

    await container.read(initializePushNotificationsProvider)(
      channelDescription: 'News',
      channelName: 'Announcements',
    );
    await Future<void>.delayed(const Duration(milliseconds: 100));

    opened.add({'itemId': '7'});
    await pumpEventQueue();

    expect(calls, ['home']);
  });
}
