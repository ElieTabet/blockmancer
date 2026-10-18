import 'package:flutter_test/flutter_test.dart';
import 'package:game_data/game_data.dart';
import 'package:game_domain/game_domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('Given nothing kept, Then nothing has been played', () async {
    expect(
      await const SharedPreferencesEngagementStore().load(),
      const Engagement(),
    );
  });

  test('Given an engagement kept, When the app relaunches, Then it reads back '
      'the same', () async {
    // Given
    final engagement = Engagement(
      completedRuns: 4,
      daysOpened: 2,
      firstOpenedOn: 20261017,
      lastInterstitialAt: DateTime.utc(2026, 10, 18, 12, 30),
      lastOpenedOn: 20261018,
      runEndsSinceInterstitial: 1,
    );

    // When
    await const SharedPreferencesEngagementStore().save(engagement);

    // Then
    expect(await const SharedPreferencesEngagementStore().load(), engagement);
  });

  test('Given a kept engagement that can no longer be read, Then it starts '
      'afresh', () async {
    // Given
    SharedPreferences.setMockInitialValues({'engagement': '{"completedRuns":'});

    // When / Then
    expect(
      await const SharedPreferencesEngagementStore().load(),
      const Engagement(),
    );
  });
}
