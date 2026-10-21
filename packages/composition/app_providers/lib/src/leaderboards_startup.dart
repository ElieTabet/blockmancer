import 'package:app_providers/src/providers_internal.br.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Picks the player's leaderboard sign-in up, once the consent form has had
/// the screen: Game Center's sheet, the only one launch may show, never covers
/// it, and a refusal or a failure only leaves the boards empty.
Future<void> restoreLeaderboardsSignIn(ProviderContainer container) =>
    container.read(leaderboardsProvider).restoreSignIn();
