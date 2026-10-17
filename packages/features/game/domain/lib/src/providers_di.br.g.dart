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

@ProviderFor(clock)
final clockProvider = ClockProvider._();

final class ClockProvider extends $FunctionalProvider<Clock, Clock, Clock>
    with $Provider<Clock> {
  ClockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clockProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clockHash();

  @$internal
  @override
  $ProviderElement<Clock> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Clock create(Ref ref) {
    return clock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Clock value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Clock>(value),
    );
  }
}

String _$clockHash() => r'b653369ba50137730cd13dc493ff7ddd9dc8b9b6';

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

@ProviderFor(runStore)
final runStoreProvider = RunStoreProvider._();

final class RunStoreProvider
    extends $FunctionalProvider<RunStore, RunStore, RunStore>
    with $Provider<RunStore> {
  RunStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'runStoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$runStoreHash();

  @$internal
  @override
  $ProviderElement<RunStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RunStore create(Ref ref) {
    return runStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RunStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RunStore>(value),
    );
  }
}

String _$runStoreHash() => r'812affa06697708f46f9b20eec5dc0fedf0be838';
