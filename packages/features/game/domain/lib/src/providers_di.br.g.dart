// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_di.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bestScores)
final bestScoresProvider = BestScoresProvider._();

final class BestScoresProvider
    extends $FunctionalProvider<BestScores, BestScores, BestScores>
    with $Provider<BestScores> {
  BestScoresProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bestScoresProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bestScoresHash();

  @$internal
  @override
  $ProviderElement<BestScores> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BestScores create(Ref ref) {
    return bestScores(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BestScores value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BestScores>(value),
    );
  }
}

String _$bestScoresHash() => r'7cdda2be00059baacd975dd0f072dae92c2472d6';

/// The game's rules. Composition binds the engine; the game never imports it,
/// so its screens can only draw what the rules say. Here rather than in
/// presentation because the domain decides each mode's seed with them.

@ProviderFor(gameRules)
final gameRulesProvider = GameRulesProvider._();

/// The game's rules. Composition binds the engine; the game never imports it,
/// so its screens can only draw what the rules say. Here rather than in
/// presentation because the domain decides each mode's seed with them.

final class GameRulesProvider
    extends $FunctionalProvider<GameRules, GameRules, GameRules>
    with $Provider<GameRules> {
  /// The game's rules. Composition binds the engine; the game never imports it,
  /// so its screens can only draw what the rules say. Here rather than in
  /// presentation because the domain decides each mode's seed with them.
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
