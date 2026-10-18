import 'package:app_providers/src/providers_internal.br.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Signs the player in to the platform's leaderboards, once the consent form
/// has had the screen: never in its way, and never in play's, since a refusal
/// or a failure only leaves the boards empty.
Future<void> signInToLeaderboards(ProviderContainer container) async {
  await container.read(leaderboardsProvider).signIn();
}
