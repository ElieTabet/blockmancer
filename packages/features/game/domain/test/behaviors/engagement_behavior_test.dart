import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_domain/src/behaviors/engagement_behavior.dart';

import '../fake_engagement_store.dart';
import '../fakes.dart';

void main() {
  test('Given a new device, When it launches twice on one day and once the '
      'next, Then only the first launch is its first session, and it was '
      'opened on two days', () async {
    // Given
    final store = FakeEngagementStore();
    final clock = FakeClock(DateTime(2026, 10, 18, 9));

    // When
    final first = await EngagementBehavior(
      clock: clock,
      store: store,
    ).recordLaunch();
    final sameDay = await EngagementBehavior(
      clock: clock,
      store: store,
    ).recordLaunch();
    clock.current = DateTime(2026, 10, 19, 9);
    final nextDay = await EngagementBehavior(
      clock: clock,
      store: store,
    ).recordLaunch();

    // Then
    expect([first, sameDay, nextDay], [true, false, false]);
    expect(store.saved.daysOpened, 2);
    expect(store.saved.firstOpenedOn, 20261018);
  });

  test('Given run ends and an interstitial, Then the run ends count up and '
      'the interstitial restarts their count', () async {
    // Given
    final store = FakeEngagementStore();
    final engagement = EngagementBehavior(
      clock: FakeClock(DateTime.utc(2026, 10, 18)),
      store: store,
    );

    // When
    await Future.wait([engagement.countRunEnd(), engagement.countRunEnd()]);
    await engagement.recordInterstitial(DateTime.utc(2026, 10, 18, 12));
    await engagement.countRunEnd();

    // Then
    expect(
      await engagement.read(),
      Engagement(
        completedRuns: 3,
        lastInterstitialAt: DateTime.utc(2026, 10, 18, 12),
        runEndsSinceInterstitial: 1,
      ),
    );
  });
}
