import 'package:game_domain/game_domain.dart';

/// The saved run kept in memory.
class FakeRunStore implements RunStore {
  SavedRun? saved;

  @override
  Future<void> clear() async => saved = null;

  @override
  Future<SavedRun?> load() async => saved;

  @override
  Future<void> save(SavedRun run) async => saved = run;
}
