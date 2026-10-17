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
