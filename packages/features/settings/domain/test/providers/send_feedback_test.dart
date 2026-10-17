import 'package:flutter_test/flutter_test.dart';
import 'package:settings_domain/settings_domain.dart';

import '../fake_mail_app.dart';
import '../fake_settings_store.dart';
import '../settings_container.dart';

void main() {
  test(
    'Given a mail app, When feedback is sent, Then a draft to support opens with the build and the phone',
    () async {
      // Given
      final mailApp = FakeMailApp();
      final container = launchWith(FakeSettingsStore(), mailApp: mailApp);

      // When
      final opened = await container.read(sendFeedbackProvider)();

      // Then
      expect(opened, isTrue);
      final draft = mailApp.drafts.single;
      expect(draft.scheme, 'mailto');
      expect(draft.path, 'support@elietabet.com');
      expect(draft.queryParameters['subject'], 'Blockmancer feedback');
      expect(
        draft.queryParameters['body'],
        '\n\n---\n'
        'Version: 1.0.0 (2)\n'
        'Device: iPhone 15 Pro\n'
        'OS: iOS 18.1',
      );
    },
  );

  test(
    'Given a mail app, When feedback is sent, Then spaces are encoded as %20 rather than +',
    () async {
      // Given
      final mailApp = FakeMailApp();
      final container = launchWith(FakeSettingsStore(), mailApp: mailApp);

      // When
      await container.read(sendFeedbackProvider)();

      // Then
      expect(mailApp.drafts.single.query, contains('Blockmancer%20feedback'));
      expect(mailApp.drafts.single.query, isNot(contains('+')));
    },
  );

  for (final device in ["Élie's Pixel 7 Pro & co #1 +=?%", '日本']) {
    test(
      'Given a phone named "$device", When feedback is sent, Then the draft names it exactly',
      () async {
        // Given
        final mailApp = FakeMailApp();
        final container = launchWith(
          FakeSettingsStore(),
          appDetails: testAppDetails.copyWith(device: device),
          mailApp: mailApp,
        );

        // When
        await container.read(sendFeedbackProvider)();

        // Then
        final sent = Uri.parse(mailApp.drafts.single.toString());
        expect(sent.queryParameters['body'], contains('Device: $device\n'));
        expect(sent.queryParameters['subject'], 'Blockmancer feedback');
      },
    );
  }

  test(
    'Given no mail app, When feedback is sent, Then it answers that nothing opened',
    () async {
      // Given
      final container = launchWith(
        FakeSettingsStore(),
        mailApp: FakeMailApp(installed: false),
      );

      // When
      final opened = await container.read(sendFeedbackProvider)();

      // Then
      expect(opened, isFalse);
    },
  );
}
