import 'package:game_domain/src/contracts/best_scores.dart';
import 'package:game_domain/src/entities/game_mode.br.dart';
import 'package:game_domain/src/entities/run_end_record.br.dart';

/// Measures a finished run against its mode's best, keeping it if it beats it.
class RecordRunEndBehavior {
  final BestScores _scores;

  const RecordRunEndBehavior({required BestScores scores}) : _scores = scores;

  Future<RunEndRecord> call(GameMode mode, int total) async {
    final previous = await _scores.best(mode);

    if (previous != null && total <= previous) {
      return RunEndRecord(best: previous, isNewBest: false);
    }

    await _scores.save(mode, total);

    return RunEndRecord(best: total, isNewBest: true);
  }
}
