import 'package:game_domain/game_domain.dart';
import 'package:shared_domain/shared_domain.dart';

/// The progression kept in memory, from [saved].
final class FakeProgressionStore implements ProgressionStore {
  Progression saved;

  FakeProgressionStore(this.saved);

  @override
  Future<Progression> load() async => saved;

  @override
  Future<void> save(Progression progression) async => saved = progression;
}
