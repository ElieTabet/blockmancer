import 'package:game_domain/src/contracts/progression_store.dart';

/// Counts every unlocked joker as seen, once the Spellbook has shown them:
/// their NEW badges don't show again.
class MarkSpellbookSeenBehavior {
  final ProgressionStore _store;

  const MarkSpellbookSeenBehavior({required ProgressionStore store})
    : _store = store;

  Future<void> call() async {
    final progression = await _store.load();
    final seen = {...progression.spellbookSeen, ...progression.unlockedJokers};

    if (seen.length == progression.spellbookSeen.length) return;

    await _store.save(progression.copyWith(spellbookSeen: seen));
  }
}
