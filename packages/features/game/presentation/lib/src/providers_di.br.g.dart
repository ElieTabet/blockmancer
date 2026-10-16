// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_di.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The game's rules. Composition binds the engine; this package never imports
/// it, so the screen can only draw what the rules say.

@ProviderFor(gameRules)
final gameRulesProvider = GameRulesProvider._();

/// The game's rules. Composition binds the engine; this package never imports
/// it, so the screen can only draw what the rules say.

final class GameRulesProvider
    extends $FunctionalProvider<GameRules, GameRules, GameRules>
    with $Provider<GameRules> {
  /// The game's rules. Composition binds the engine; this package never imports
  /// it, so the screen can only draw what the rules say.
  GameRulesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameRulesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameRulesHash();

  @$internal
  @override
  $ProviderElement<GameRules> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GameRules create(Ref ref) {
    return gameRules(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameRules value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameRules>(value),
    );
  }
}

String _$gameRulesHash() => r'aedb42ba0debe7407ed8cfe4af33bf6cc721b26f';
