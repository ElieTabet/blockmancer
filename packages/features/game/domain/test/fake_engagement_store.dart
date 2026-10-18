import 'package:game_domain/game_domain.dart';

/// The engagement kept in memory, starting from nothing played.
final class FakeEngagementStore implements EngagementStore {
  FakeEngagementStore([this.saved = const Engagement()]);

  Engagement saved;

  @override
  Future<Engagement> load() async => saved;

  @override
  Future<void> save(Engagement engagement) async => saved = engagement;
}
