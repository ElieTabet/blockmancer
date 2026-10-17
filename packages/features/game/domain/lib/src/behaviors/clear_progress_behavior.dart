import 'package:game_domain/src/contracts/best_scores.dart';
import 'package:game_domain/src/contracts/run_store.dart';

/// Forgets everything the player has achieved on this device: every mode's
/// best, and the run saved to resume.
class ClearProgressBehavior {
  final BestScores _scores;
  final RunStore _store;

  const ClearProgressBehavior({
    required BestScores scores,
    required RunStore store,
  }) : _scores = scores,
       _store = store;

  Future<void> call() async {
    await _scores.clearAll();
    await _store.clear();
  }
}
