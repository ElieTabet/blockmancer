import 'package:flutter_test/flutter_test.dart';
import 'package:push_notifications_domain/push_notifications_domain.dart';
import 'package:push_notifications_domain/src/behaviors/resolve_push_destination_behavior.dart';

void main() {
  const resolve = ResolvePushDestinationBehavior();

  test('a daily reminder leads to the daily run, naming its message', () {
    expect(
      resolve(ReminderMessage.comboTime.data),
      const PushDestination.dailyRun(messageId: 'combo_time'),
    );
  });

  // A newer server may send what this build has never heard of; the tap must
  // still open the app.
  test('every other push leads home, whatever it carries', () {
    for (final data in [
      <String, String>{},
      {'itemId': '7'},
      {'type': 'daily_reminder'},
      {'anything': 'else'},
    ]) {
      expect(resolve(data), const PushDestination.home(), reason: '$data');
    }
  });
}
