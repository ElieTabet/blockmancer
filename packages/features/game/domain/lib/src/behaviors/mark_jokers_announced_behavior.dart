import 'package:game_domain/src/contracts/progression_store.dart';

/// Forgets the jokers waiting to be announced, once the map has shown them.
class MarkJokersAnnouncedBehavior {
  final ProgressionStore _store;

  const MarkJokersAnnouncedBehavior({required ProgressionStore store})
    : _store = store;

  Future<void> call() async {
    final progression = await _store.load();

    if (progression.unannouncedJokers.isEmpty) return;

    await _store.save(progression.copyWith(unannouncedJokers: const {}));
  }
}
