import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:push_notifications_domain/push_notifications_domain.dart';
import 'package:push_notifications_domain/src/behaviors/watch_push_destinations_behavior.dart';

void main() {
  late StreamController<Map<String, String>> opened;
  late Completer<void> launchRead;

  setUp(() {
    opened = StreamController<Map<String, String>>.broadcast();
    launchRead = Completer<void>();
  });

  tearDown(() => opened.close());

  Future<List<PushDestination>> destinationsWith({
    Map<String, String>? launch,
    List<Map<String, String>> taps = const [],
  }) async {
    final destinations = <PushDestination>[];
    final subscription = WatchPushDestinationsBehavior(
      launchMessage: () async {
        launchRead.complete();

        return launch;
      },
      openedMessages: () => opened.stream,
    )().listen(destinations.add);

    addTearDown(subscription.cancel);

    await pumpEventQueue();
    taps.forEach(opened.add);
    await pumpEventQueue();

    return destinations;
  }

  test('the push that launched the app comes first, then each tap', () async {
    final destinations = await destinationsWith(
      launch: {'itemId': '7'},
      taps: [
        {'itemId': '3'},
      ],
    );

    expect(destinations, [
      const PushDestination.home(),
      const PushDestination.home(),
    ]);
  });

  test('no launch push opens nothing until a tap', () async {
    final destinations = await destinationsWith();

    expect(launchRead.isCompleted, isTrue);
    expect(destinations, isEmpty);
  });

  // Two taps on the same push are two openings, not one unchanged value.
  test('the same push tapped twice opens twice', () async {
    final destinations = await destinationsWith(
      taps: [
        {'itemId': '7'},
        {'itemId': '7'},
      ],
    );

    expect(destinations, hasLength(2));
  });
}
