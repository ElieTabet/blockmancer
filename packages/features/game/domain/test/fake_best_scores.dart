import 'package:game_domain/game_domain.dart';

/// Best scores kept in memory, per mode.
final class FakeBestScores implements BestScores {
  final saved = <GameMode, int>{};

  @override
  Future<int?> best(GameMode mode) async => saved[mode];

  @override
  Future<Set<int>> dailyDays() async => {
    for (final mode in saved.keys)
      if (mode case DailyMode(:final day)) day,
  };

  @override
  Future<void> clearAll() async => saved.clear();

  @override
  Future<void> save(GameMode mode, int total) async => saved[mode] = total;
}
