import 'package:game_presentation/src/entities/game_sound.dart';
import 'package:game_presentation/src/routing/game_routing.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers_di.br.g.dart';

// game_presentation — inbound dependency-injection slots. Each throws until
// the composition layer overrides it.

/// Plays [GameSound] [semitones] above its own pitch (12 is an octave), nudged
/// by a random factor within ±[variance]. Never throws; a sound that isn't
/// loaded yet is skipped.
typedef PlaySoundFun =
    void Function(GameSound sound, {double semitones, double variance});

/// Shows the reward a revive costs; true once it has been earned. A reward
/// that couldn't be shown is false, never an error.
typedef RewardedActionFun = Future<bool> Function();

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
PlaySoundFun playSound(Ref ref) => throw UnimplementedError(
  'playSoundProvider must be overridden by the composition layer',
);

/// Whether the player turned reduce motion on in the app's settings. The
/// platform's own setting is read by the game screen itself.
@riverpod
bool reduceMotionSetting(Ref ref) => throw UnimplementedError(
  'reduceMotionSettingProvider must be overridden by the composition layer',
);

@riverpod
RewardedActionFun rewardedAction(Ref ref) => throw UnimplementedError(
  'rewardedActionProvider must be overridden by the composition layer',
);

/// Whether the player left sound on in the app's settings.
@riverpod
bool soundOnSetting(Ref ref) => throw UnimplementedError(
  'soundOnSettingProvider must be overridden by the composition layer',
);
