import 'package:game_domain/src/entities/game_mode.br.dart';

/// The best run total kept for each mode, on this device.
abstract interface class BestScores {
  /// Null until a run of [mode] has ended.
  Future<int?> best(GameMode mode);

  /// The UTC days (`yyyymmdd`) on which a daily run was played to its end:
  /// those its best is kept for.
  Future<Set<int>> dailyDays();

  /// Forgets the best of every mode.
  Future<void> clearAll();

  Future<void> save(GameMode mode, int total);
}
