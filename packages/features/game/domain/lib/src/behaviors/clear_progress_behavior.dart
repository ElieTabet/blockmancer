import 'package:game_domain/src/contracts/best_scores.dart';
import 'package:game_domain/src/contracts/progression_store.dart';
import 'package:game_domain/src/contracts/run_store.dart';
import 'package:shared_domain/shared_domain.dart';

/// Forgets everything the player has achieved on this device: every mode's
/// best, the run saved to resume, and the map, back to where a new player
/// starts.
class ClearProgressBehavior {
  final ProgressionStore _progression;
  final BestScores _scores;
  final Progression _startingProgression;
  final RunStore _store;

  const ClearProgressBehavior({
    required ProgressionStore progression,
    required BestScores scores,
    required Progression startingProgression,
    required RunStore store,
  }) : _progression = progression,
       _scores = scores,
       _startingProgression = startingProgression,
       _store = store;

  Future<void> call() async {
    await _scores.clearAll();
    await _store.clear();
    await _progression.save(_startingProgression);
  }
}
