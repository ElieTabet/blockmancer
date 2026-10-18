import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_domain/src/behaviors/interstitial_policy.dart';
import 'package:game_domain/src/entities/interstitial_caps.dart';

final _now = DateTime.utc(2026, 10, 18, 12);

/// The default caps: from the 3rd completed run, every 2nd run end, 90 s
/// apart.
final _caps = interstitialCapsOf((_) => null);

bool _due(Engagement engagement, {bool firstSession = false}) =>
    interstitialDue(
      caps: _caps,
      engagement: engagement,
      firstSession: firstSession,
      now: _now,
    );

void main() {
  const third = Engagement(completedRuns: 3, runEndsSinceInterstitial: 2);

  test('Given the third completed run, the second run end since the last, '
      'Then an interstitial is due', () {
    expect(_due(third), isTrue);
  });

  test('Given only two completed runs, Then none is due', () {
    expect(_due(third.copyWith(completedRuns: 2)), isFalse);
  });

  test('Given a single run end since the last interstitial, Then none is due '
      'yet', () {
    expect(_due(third.copyWith(runEndsSinceInterstitial: 1)), isFalse);
  });

  test('Given an interstitial 89 s ago, Then none is due; at 90 s, it is', () {
    expect(
      _due(
        third.copyWith(
          lastInterstitialAt: _now.subtract(const Duration(seconds: 89)),
        ),
      ),
      isFalse,
    );
    expect(
      _due(
        third.copyWith(
          lastInterstitialAt: _now.subtract(const Duration(seconds: 90)),
        ),
      ),
      isTrue,
    );
  });

  test("Given the player's first session, Then none is due, whatever the "
      'runs', () {
    expect(
      _due(
        const Engagement(completedRuns: 20, runEndsSinceInterstitial: 20),
        firstSession: true,
      ),
      isFalse,
    );
  });

  test('Given caps published in Remote Config, Then they apply; malformed '
      'ones keep the defaults', () {
    // Given
    final published = interstitialCapsOf(
      (key) => switch (key) {
        'interstitial_every_n_run_ends' => '4',
        'interstitial_min_completed_runs' => 'many',
        'interstitial_min_seconds' => '5000',
        _ => null,
      },
    );

    // Then
    expect(published, (
      everyNthRunEnd: 4,
      minCompletedRuns: 3,
      minGap: const Duration(seconds: 90),
    ));
  });
}
