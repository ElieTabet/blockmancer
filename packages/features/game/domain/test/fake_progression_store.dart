import 'package:game_domain/game_domain.dart';
import 'package:shared_domain/shared_domain.dart';

/// The progression kept in memory, starting from nothing earned.
final class FakeProgressionStore implements ProgressionStore {
  Progression saved = const Progression(
    jokerStats: {},
    tutorialDone: false,
    unlockedJokers: {},
    worlds: {},
  );

  @override
  Future<Progression> load() async => saved;

  @override
  Future<void> save(Progression progression) async => saved = progression;
}
