import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:telemetry/telemetry.dart';

class _MockAnalytics extends Mock implements FirebaseAnalytics {}

final class _RecordingSink implements AnalyticsSink {
  final events = <AnalyticsEvent>[];

  @override
  void log(AnalyticsEvent event) => events.add(event);
}

void main() {
  void expectMapped(
    AnalyticsEvent event,
    String name,
    Map<String, Object> parameters,
  ) {
    final (mappedName, mappedParameters) = firebaseEventOf(event);

    expect(mappedName, name);
    expect(mappedParameters, parameters);
  }

  test('Given each event, When mapped for Firebase, Then it has a snake_case '
      'name and only text and number parameters', () {
    expectMapped(
      const .jokerPick(id: .twin, offered: [.twin, .combo]),
      'joker_pick',
      {'id': 'twin', 'offered': 'twin,combo'},
    );
    expectMapped(const .revive(), 'revive', {});
    expectMapped(const .adShown(kind: .interstitial), 'ad_shown', {
      'type': 'interstitial',
    });
    expectMapped(const .adRewardEarned(), 'ad_reward_earned', {});
    expectMapped(
      const .purchaseStarted(product: 'remove_ads'),
      'purchase_started',
      {'product': 'remove_ads'},
    );
    expectMapped(
      const .purchaseCompleted(product: 'remove_ads'),
      'purchase_completed',
      {'product': 'remove_ads'},
    );
    expectMapped(
      const .purchaseRestored(product: 'remove_ads'),
      'purchase_restored',
      {'product': 'remove_ads'},
    );
    expectMapped(
      const .purchaseFailed(code: 'canceled', product: 'remove_ads'),
      'purchase_failed',
      {'code': 'canceled', 'product': 'remove_ads'},
    );
    expectMapped(const .adFailed(code: '3', kind: .rewarded), 'ad_failed', {
      'code': '3',
      'type': 'rewarded',
    });
    expectMapped(
      const .roundEnd(round: 3, score: 900, won: true),
      'round_end',
      {'round': 3, 'score': 900, 'won': 1},
    );
    expectMapped(
      const .runEnd(starsEarned: 2, total: 9000, won: false),
      'run_end',
      {'stars_earned': 2, 'total': 9000, 'won': 0},
    );
    expectMapped(const .runStart(mode: .world, world: .fog), 'run_start', {
      'mode': 'world',
      'world': 'fog',
    });
    expectMapped(const .worldUnlock(world: .tide), 'world_unlock', {
      'world': 'tide',
    });
  });

  test('Given Analytics failing, When an event is logged, Then nothing '
      'throws', () async {
    // Given
    final analytics = _MockAnalytics();
    when(
      () => analytics.logEvent(
        name: any(named: 'name'),
        parameters: any(named: 'parameters'),
      ),
    ).thenThrow(Exception('not initialised'));

    // When / Then
    FirebaseAnalyticsSink(analytics: analytics).log(const .revive());
    await Future<void>.delayed(Duration.zero);
  });

  test('Given two sinks, When an event is logged, Then each gets it', () {
    // Given
    final device = _RecordingSink();
    final firebase = _RecordingSink();

    // When
    CompositeAnalyticsSink([device, firebase]).log(const .revive());

    // Then
    expect(device.events, [const AnalyticsEvent.revive()]);
    expect(firebase.events, [const AnalyticsEvent.revive()]);
  });
}
