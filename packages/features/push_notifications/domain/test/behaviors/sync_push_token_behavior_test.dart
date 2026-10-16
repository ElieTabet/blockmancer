import 'package:flutter_test/flutter_test.dart';
import 'package:push_notifications_domain/src/behaviors/sync_push_token_behavior.dart';

// This exists for one case: the launch report on a fresh iOS install goes out
// without a token, because APNs has not answered by the time the splash runs.
void main() {
  late List<String> reportedTokens;

  setUp(() => reportedTokens = []);

  SyncPushTokenBehavior behaviorWith({String? token}) => SyncPushTokenBehavior(
    readPushToken: () async => token,
    report: (token) async => reportedTokens.add(token),
  );

  test('reports the token FCM holds now', () async {
    await behaviorWith(token: 'fcm-1')();

    expect(reportedTokens, ['fcm-1']);
  });

  // A report with no token would only repeat the launch report, and the server
  // replaces nothing for a field a request doesn't carry.
  test('reports nothing when there is still no token', () async {
    await behaviorWith()();

    expect(reportedTokens, isEmpty);
  });
}
