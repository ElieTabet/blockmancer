import 'package:game_domain/src/contracts/progression_store.dart';
import 'package:shared_domain/shared_domain.dart';

/// Counts a joker picked, the starting pick included, as it is picked: a run
/// left before its end still counts its picks.
class RecordPickBehavior {
  final ProgressionStore _store;

  const RecordPickBehavior({required ProgressionStore store}) : _store = store;

  Future<void> call(JokerId joker) async {
    final progression = await _store.load();
    final stats = progression.jokerStats[joker] ?? .none;

    await _store.save(
      progression.copyWith(
        jokerStats: {
          ...progression.jokerStats,
          joker: stats.copyWith(timesPicked: stats.timesPicked + 1),
        },
      ),
    );
  }
}
