import 'package:game_domain/game_domain.dart';
import 'package:shared_domain/shared_domain.dart';

export 'fake_best_scores.dart';

/// A clock at [current], which a test may move.
final class FakeClock implements Clock {
  FakeClock(this.current);

  DateTime current;

  @override
  DateTime now() => current;
}

/// Rules whose daily seed is the date as `yyyymmdd` plus one, so a test can
/// tell a seed from a day. Nothing else is called.
final class DailySeedRules implements GameRules {
  const DailySeedRules();

  @override
  int dailySeed({required int day, required int month, required int year}) =>
      year * 10000 + month * 100 + day + 1;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
