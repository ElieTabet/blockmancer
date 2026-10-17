import 'package:game_domain/src/entities/game_mode.br.dart';

/// The best run total kept for each mode, on this device.
abstract interface class BestScores {
  /// Null until a run of [mode] has ended.
  Future<int?> best(GameMode mode);

  Future<void> save(GameMode mode, int total);
}
