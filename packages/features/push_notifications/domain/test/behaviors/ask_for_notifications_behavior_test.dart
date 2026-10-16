import 'package:flutter_test/flutter_test.dart';
import 'package:push_notifications_domain/src/behaviors/ask_for_notifications_behavior.dart';

void main() {
  late List<String> calls;

  setUp(() => calls = []);

  AskForNotificationsBehavior behaviorWith({required bool granted}) =>
      AskForNotificationsBehavior(
        requestPermission: () async {
          calls.add('permission');

          return granted;
        },
        syncToken: () async => calls.add('sync'),
      );

  // Answering the prompt is what makes a token readable on a fresh iOS
  // install, so the sync must come after it.
  test('asks first, then syncs the token', () async {
    await behaviorWith(granted: true)();

    expect(calls, ['permission', 'sync']);
  });

  // A denied install still has a token, and starts receiving the day its owner
  // turns notifications on in Settings.
  test('still syncs when permission is denied', () async {
    await behaviorWith(granted: false)();

    expect(calls, ['permission', 'sync']);
  });
}
