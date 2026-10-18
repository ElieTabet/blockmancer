import 'package:app_providers/src/providers_internal.br.dart';
import 'package:game_domain/game_domain.dart' as game;
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Counts this launch (whether it is the device's first, when no
/// interstitial may interrupt) and starts loading both ads, which wait for
/// consent before their first request.
Future<void> startAds(ProviderContainer container) async {
  container.read(interstitialAdsProvider).preload();
  container.read(rewardedAdsProvider).preload();
  await container.read(game.firstSessionProvider.future);
}
