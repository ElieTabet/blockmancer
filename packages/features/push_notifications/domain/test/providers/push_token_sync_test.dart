import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_notifications_domain/push_notifications_domain.dart';

// The refresh half of the token story. The launch report carries whatever token
// exists at startup; everything FCM mints afterwards arrives here.
void main() {
  late List<String> reportedTokens;
  late int subscriptions;
  late StreamController<String> tokens;

  ProviderContainer containerWith() {
    final container = ProviderContainer(
      overrides: [
        pushTokenChangesProvider.overrideWith(
          (ref) => () {
            subscriptions++;

            return tokens.stream;
          },
        ),
        reportPushTokenProvider.overrideWith(
          (ref) =>
              (token) async => reportedTokens.add(token),
        ),
      ],
    );

    addTearDown(container.dispose);

    return container;
  }

  setUp(() {
    reportedTokens = [];
    subscriptions = 0;
    tokens = StreamController<String>.broadcast();
  });

  tearDown(() => tokens.close());

  test('reports every refreshed token', () async {
    containerWith().read(startPushTokenSyncProvider)();

    tokens
      ..add('fcm-1')
      ..add('fcm-2');
    await pumpEventQueue();

    expect(reportedTokens, ['fcm-1', 'fcm-2']);
  });

  // Signing out prepares the device again. keepAlive is what makes the second
  // start reach the same instance rather than open a second subscription —
  // without it every token would be reported twice.
  test('a second start does not open a second subscription', () async {
    final start = containerWith().read(startPushTokenSyncProvider);

    start();
    start();

    tokens.add('fcm-1');
    await pumpEventQueue();

    expect(subscriptions, 1);
    expect(reportedTokens, ['fcm-1']);
  });

  // `device` starts it only once registration has succeeded.
  test('nothing is reported before the sync is started', () async {
    containerWith();

    tokens.add('fcm-1');
    await pumpEventQueue();

    expect(reportedTokens, isEmpty);
  });
}
