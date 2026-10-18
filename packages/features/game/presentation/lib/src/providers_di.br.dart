import 'dart:ui';

import 'package:game_presentation/src/entities/game_sound.dart';
import 'package:game_presentation/src/routing/game_routing.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

part 'providers_di.br.g.dart';

// game_presentation — inbound dependency-injection slots. Each throws until
// the composition layer overrides it.

/// Keeps it that the player has been through the tutorial, so it isn't
/// offered again.
typedef MarkTutorialSeenFun = Future<void> Function();

/// Plays [GameSound] [semitones] above its own pitch (12 is an octave), nudged
/// by a random factor within ±[variance]. Never throws; a sound that isn't
/// loaded yet is skipped.
typedef PlaySoundFun =
    void Function(GameSound sound, {double semitones, double variance});

/// Shows the rewarded ad a revive costs, and says what came of it: earned,
/// closed before its reward, or not shown. Never throws.
typedef RewardedActionFun = Future<AdResult> Function();

@riverpod
GameRouting gameRouting(Ref ref) => throw UnimplementedError(
  'gameRoutingProvider must be overridden by the composition layer (app_router)',
);

/// Whether the player left haptics on in the app's settings.
@riverpod
bool hapticsOnSetting(Ref ref) => throw UnimplementedError(
  'hapticsOnSettingProvider must be overridden by the composition layer',
);

@riverpod
MarkTutorialSeenFun markTutorialSeen(Ref ref) => throw UnimplementedError(
  'markTutorialSeenProvider must be overridden by the composition layer',
);

@riverpod
PlaySoundFun playSound(Ref ref) => throw UnimplementedError(
  'playSoundProvider must be overridden by the composition layer',
);

/// Whether the player turned reduce motion on in the app's settings. The
/// platform's own setting is read by the game screen itself.
@riverpod
bool reduceMotionSetting(Ref ref) => throw UnimplementedError(
  'reduceMotionSettingProvider must be overridden by the composition layer',
);

/// Loads the run's ads ahead, so neither a revive nor a run's end waits on
/// the network. Idempotent.
@riverpod
VoidCallback preloadAds(Ref ref) => throw UnimplementedError(
  'preloadAdsProvider must be overridden by the composition layer',
);

@riverpod
RewardedActionFun rewardedAction(Ref ref) => throw UnimplementedError(
  'rewardedActionProvider must be overridden by the composition layer',
);

/// Whether a rewarded ad is loaded, as it changes: a revive with none says
/// so rather than wait.
@riverpod
Stream<bool> rewardedAdReady(Ref ref) => throw UnimplementedError(
  'rewardedAdReadyProvider must be overridden by the composition layer',
);

/// Whether the player left sound on in the app's settings.
@riverpod
bool soundOnSetting(Ref ref) => throw UnimplementedError(
  'soundOnSettingProvider must be overridden by the composition layer',
);
