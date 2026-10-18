import 'package:flutter_test/flutter_test.dart';
import 'package:settings_domain/settings_domain.dart';

import '../fake_settings_store.dart';
import '../settings_container.dart';

void main() {
  test('Given a player in the EEA who declines, When consent is gathered, '
      'Then Analytics is denied and Settings offers privacy choices', () async {
    // Given
    final calls = <String>[];
    final launch = launchWith(
      FakeSettingsStore(),
      calls: calls,
      consent: [(canRequestAds: false, privacyOptionsRequired: true)],
    );

    // When
    await launch.read(consentProvider.notifier).gather();

    // Then
    expect(calls, ['gather', 'analytics: false']);
    expect(launch.read(privacyChoicesRequiredProvider), isTrue);
  });

  test(
    'Given a player where no consent is required, When consent is '
    'gathered, Then Analytics is granted and no privacy choices show',
    () async {
      // Given
      final calls = <String>[];
      final launch = launchWith(FakeSettingsStore(), calls: calls);

      // When
      await launch.read(consentProvider.notifier).gather();

      // Then
      expect(calls, ['gather', 'analytics: true']);
      expect(launch.read(privacyChoicesRequiredProvider), isFalse);
    },
  );

  test('Given a player who reopens privacy choices and consents, Then the new '
      'answer reaches Analytics', () async {
    // Given
    final calls = <String>[];
    final launch = launchWith(
      FakeSettingsStore(),
      calls: calls,
      consent: [
        (canRequestAds: false, privacyOptionsRequired: true),
        (canRequestAds: true, privacyOptionsRequired: true),
      ],
    );
    await launch.read(consentProvider.notifier).gather();

    // When
    await launch.read(consentProvider.notifier).showPrivacyChoices();

    // Then
    expect(calls, [
      'gather',
      'analytics: false',
      'privacy options',
      'gather',
      'analytics: true',
    ]);
  });

  test('Given Settings, When the privacy policy and support are opened, Then '
      "each opens on the studio's site", () async {
    // Given
    final calls = <String>[];
    final launch = launchWith(FakeSettingsStore(), calls: calls);

    // When
    await launch.read(openPrivacyPolicyProvider)();
    await launch.read(openSupportProvider)();

    // Then
    expect(calls, [
      'open https://studio.elietabet.com/privacy',
      'open https://studio.elietabet.com/support',
    ]);
  });
}
