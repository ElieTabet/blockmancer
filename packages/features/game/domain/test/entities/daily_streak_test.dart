import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/src/entities/daily_streak.dart';

final _today = DateTime.utc(2026, 10, 18);

void main() {
  test('Given daily runs on each of the last three days, today included, When '
      'the streak is read, Then it is 3', () {
    expect(
      dailyStreakOf(days: {20261016, 20261017, 20261018}, today: _today),
      3,
    );
  });

  test("Given daily runs until yesterday and none yet today, When the streak "
      'is read, Then it still counts: today has time left', () {
    expect(dailyStreakOf(days: {20261016, 20261017}, today: _today), 2);
  });

  test('Given a missed UTC day before today, When the streak is read, Then '
      'only the days since count', () {
    expect(
      dailyStreakOf(
        days: {20261014, 20261015, 20261017, 20261018},
        today: _today,
      ),
      2,
    );
  });

  test('Given no daily run yesterday or today, When the streak is read, Then '
      'it is broken', () {
    expect(dailyStreakOf(days: {20261015, 20261016}, today: _today), 0);
  });

  test('Given daily runs across a month end, When the streak is read, Then '
      'the days run on', () {
    expect(
      dailyStreakOf(
        days: {20260930, 20261001, 20261002},
        today: DateTime.utc(2026, 10, 2),
      ),
      3,
    );
  });
}
