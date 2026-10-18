// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_di.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(gameRouting)
final gameRoutingProvider = GameRoutingProvider._();

final class GameRoutingProvider
    extends $FunctionalProvider<GameRouting, GameRouting, GameRouting>
    with $Provider<GameRouting> {
  GameRoutingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameRoutingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameRoutingHash();

  @$internal
  @override
  $ProviderElement<GameRouting> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GameRouting create(Ref ref) {
    return gameRouting(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameRouting value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameRouting>(value),
    );
  }
}

String _$gameRoutingHash() => r'b54899885c31e5c3abea069839fa822487bbd9a6';

/// Whether the player left haptics on in the app's settings.

@ProviderFor(hapticsOnSetting)
final hapticsOnSettingProvider = HapticsOnSettingProvider._();

/// Whether the player left haptics on in the app's settings.

final class HapticsOnSettingProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether the player left haptics on in the app's settings.
  HapticsOnSettingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hapticsOnSettingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hapticsOnSettingHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return hapticsOnSetting(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$hapticsOnSettingHash() => r'e580e748a8e710f10a774b373bf9ab60c594e9c8';

@ProviderFor(markTutorialSeen)
final markTutorialSeenProvider = MarkTutorialSeenProvider._();

final class MarkTutorialSeenProvider
    extends
        $FunctionalProvider<
          MarkTutorialSeenFun,
          MarkTutorialSeenFun,
          MarkTutorialSeenFun
        >
    with $Provider<MarkTutorialSeenFun> {
  MarkTutorialSeenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'markTutorialSeenProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$markTutorialSeenHash();

  @$internal
  @override
  $ProviderElement<MarkTutorialSeenFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MarkTutorialSeenFun create(Ref ref) {
    return markTutorialSeen(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MarkTutorialSeenFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MarkTutorialSeenFun>(value),
    );
  }
}

String _$markTutorialSeenHash() => r'00e38ec152a45070bf01e9ec0d0501f6a9dfc14b';

@ProviderFor(playSound)
final playSoundProvider = PlaySoundProvider._();

final class PlaySoundProvider
    extends $FunctionalProvider<PlaySoundFun, PlaySoundFun, PlaySoundFun>
    with $Provider<PlaySoundFun> {
  PlaySoundProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playSoundProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playSoundHash();

  @$internal
  @override
  $ProviderElement<PlaySoundFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PlaySoundFun create(Ref ref) {
    return playSound(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlaySoundFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlaySoundFun>(value),
    );
  }
}

String _$playSoundHash() => r'e4b1dd5dbc1e6ec52c03ca3f2b4dd2e6eb06493e';

/// Whether the player turned reduce motion on in the app's settings. The
/// platform's own setting is read by the game screen itself.

@ProviderFor(reduceMotionSetting)
final reduceMotionSettingProvider = ReduceMotionSettingProvider._();

/// Whether the player turned reduce motion on in the app's settings. The
/// platform's own setting is read by the game screen itself.

final class ReduceMotionSettingProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether the player turned reduce motion on in the app's settings. The
  /// platform's own setting is read by the game screen itself.
  ReduceMotionSettingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reduceMotionSettingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reduceMotionSettingHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return reduceMotionSetting(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$reduceMotionSettingHash() =>
    r'288b31179f7651dc7a5cf694da8d5fe3420ec312';

/// Loads the run's ads ahead, so neither a revive nor a run's end waits on
/// the network. Idempotent.

@ProviderFor(preloadAds)
final preloadAdsProvider = PreloadAdsProvider._();

/// Loads the run's ads ahead, so neither a revive nor a run's end waits on
/// the network. Idempotent.

final class PreloadAdsProvider
    extends $FunctionalProvider<VoidCallback, VoidCallback, VoidCallback>
    with $Provider<VoidCallback> {
  /// Loads the run's ads ahead, so neither a revive nor a run's end waits on
  /// the network. Idempotent.
  PreloadAdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'preloadAdsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$preloadAdsHash();

  @$internal
  @override
  $ProviderElement<VoidCallback> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VoidCallback create(Ref ref) {
    return preloadAds(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VoidCallback value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VoidCallback>(value),
    );
  }
}

String _$preloadAdsHash() => r'c8baae13507d385698c84eb7b096242a1214502d';

@ProviderFor(rewardedAction)
final rewardedActionProvider = RewardedActionProvider._();

final class RewardedActionProvider
    extends
        $FunctionalProvider<
          RewardedActionFun,
          RewardedActionFun,
          RewardedActionFun
        >
    with $Provider<RewardedActionFun> {
  RewardedActionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rewardedActionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rewardedActionHash();

  @$internal
  @override
  $ProviderElement<RewardedActionFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RewardedActionFun create(Ref ref) {
    return rewardedAction(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RewardedActionFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RewardedActionFun>(value),
    );
  }
}

String _$rewardedActionHash() => r'c4f7bf56c8fa99168fcfbdc5ef1d77d0373e28c1';

/// Whether a rewarded ad is loaded, as it changes: a revive with none says
/// so rather than wait.

@ProviderFor(rewardedAdReady)
final rewardedAdReadyProvider = RewardedAdReadyProvider._();

/// Whether a rewarded ad is loaded, as it changes: a revive with none says
/// so rather than wait.

final class RewardedAdReadyProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// Whether a rewarded ad is loaded, as it changes: a revive with none says
  /// so rather than wait.
  RewardedAdReadyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rewardedAdReadyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rewardedAdReadyHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return rewardedAdReady(ref);
  }
}

String _$rewardedAdReadyHash() => r'6de78c2b8ee2be51fe89c6488613fef2ad8902d6';

/// Whether the player left sound on in the app's settings.

@ProviderFor(soundOnSetting)
final soundOnSettingProvider = SoundOnSettingProvider._();

/// Whether the player left sound on in the app's settings.

final class SoundOnSettingProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether the player left sound on in the app's settings.
  SoundOnSettingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soundOnSettingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$soundOnSettingHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return soundOnSetting(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$soundOnSettingHash() => r'be15b45bfe3934a94232747d9ac88578e92e1423';
