import 'package:flutter_test/flutter_test.dart';
import 'package:push_notifications_domain/push_notifications_domain.dart';
import 'package:push_notifications_domain/src/behaviors/resolve_push_destination_behavior.dart';

void main() {
  const resolve = ResolvePushDestinationBehavior();

  // A newer server may send what this build has never heard of; the tap must
  // still open the app.
  test('every push leads home, whatever it carries', () {
    for (final data in [
      <String, String>{},
      {'itemId': '7'},
      {'anything': 'else'},
    ]) {
      expect(resolve(data), const PushDestination.home(), reason: '$data');
    }
  });
}
