import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:settings_domain/settings_domain.dart';

import '../fake_settings_store.dart';
import '../settings_container.dart';

void main() {
  test('Given play stats, When the summary is built, Then it holds them with '
      'the build they came from, and no device or OS', () async {
    // Given
    final container = launchWith(
      FakeSettingsStore(),
      playStats: '{"daysPlayed":3,"installId":"ab12","schema":1}',
    );

    // When
    final summary = await container.read(testStatsSummaryProvider)();

    // Then
    expect(jsonDecode(summary), {
      'app': {'build': '2', 'version': '1.0.0'},
      'daysPlayed': 3,
      'installId': 'ab12',
      'schema': 1,
    });
    expect(summary, isNot(contains('iPhone')));
    expect(summary, isNot(contains('iOS')));
  });
}
