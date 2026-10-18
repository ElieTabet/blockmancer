import 'package:game_domain/src/contracts/progression_store.dart';
import 'package:shared_domain/shared_domain.dart';

/// Remembers that [WorldId]'s boss card has been shown, so it shows only the
/// first time.
class MarkBossCardSeenBehavior {
  final ProgressionStore _store;

  const MarkBossCardSeenBehavior({required ProgressionStore store})
    : _store = store;

  Future<void> call(WorldId world) async {
    final progression = await _store.load();

    if (progression.bossCardsSeen.contains(world)) return;

    await _store.save(
      progression.copyWith(
        bossCardsSeen: {...progression.bossCardsSeen, world},
      ),
    );
  }
}
