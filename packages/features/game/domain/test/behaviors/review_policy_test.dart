import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:game_domain/src/behaviors/review_policy.dart';

final _now = DateTime.utc(2026, 12, 20, 12);

/// Three runs finished, over two days, never asked.
const _eligible = Engagement(completedRuns: 3, daysOpened: 2);

bool _due(
  Engagement engagement, {
  bool bossBeaten = true,
  bool hadError = false,
  bool newStar = false,
}) => reviewDue(
  appVersion: '1.0.0',
  bossBeaten: bossBeaten,
  cooldown: reviewCooldownOf((_) => null),
  engagement: engagement,
  hadError: hadError,
  newStar: newStar,
  now: _now,
);

void main() {
  test('Given a boss beaten by a player of 3 runs over 2 days, Then the '
      'prompt is asked for', () {
    expect(_due(_eligible), isTrue);
  });

  test('Given a newly earned star with no boss beaten, Then it is asked for '
      'too', () {
    expect(_due(_eligible, bossBeaten: false, newStar: true), isTrue);
  });

  test(
    'Given too early a player (2 runs, or a single day), Then it is not',
    () {
      expect(_due(_eligible.copyWith(completedRuns: 2)), isFalse);
      expect(_due(_eligible.copyWith(daysOpened: 1)), isFalse);
    },
  );

  test('Given a loss, with no boss beaten and no new star, Then it is not', () {
    expect(_due(_eligible, bossBeaten: false), isFalse);
  });

  test('Given a session that hit an error, Then it is not', () {
    expect(_due(_eligible, hadError: true), isFalse);
  });

  test('Given a prompt already asked for in this version, Then it is not, '
      'however long ago', () {
    expect(
      _due(
        _eligible.copyWith(
          reviewAskedAt: _now.subtract(const Duration(days: 400)),
          reviewAskedVersion: '1.0.0',
        ),
      ),
      isFalse,
    );
  });

  test('Given a prompt asked for in an older version 59 days ago, Then it is '
      'not; 60 days ago, it is', () {
    Engagement askedDaysAgo(int days) => _eligible.copyWith(
      reviewAskedAt: _now.subtract(Duration(days: days)),
      reviewAskedVersion: '0.9.0',
    );

    expect(_due(askedDaysAgo(59)), isFalse);
    expect(_due(askedDaysAgo(60)), isTrue);
  });

  test('Given a cooldown published in Remote Config, Then it applies; a bad '
      'one keeps 60 days', () {
    expect(reviewCooldownOf((_) => '30'), const Duration(days: 30));
    expect(reviewCooldownOf((_) => '-1'), const Duration(days: 60));
  });
}
