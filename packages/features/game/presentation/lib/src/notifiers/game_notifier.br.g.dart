// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_notifier.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The run on screen. Every rule is [GameRules]': this only forwards the
/// player's actions and keeps what each one did.

@ProviderFor(GameNotifier)
final gameProvider = GameNotifierProvider._();

/// The run on screen. Every rule is [GameRules]': this only forwards the
/// player's actions and keeps what each one did.
final class GameNotifierProvider
    extends $NotifierProvider<GameNotifier, GameUiState> {
  /// The run on screen. Every rule is [GameRules]': this only forwards the
  /// player's actions and keeps what each one did.
  GameNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[gameLaunchProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          GameNotifierProvider.$allTransitiveDependencies0,
        ],
      );

  static final $allTransitiveDependencies0 = gameLaunchProvider;

  @override
  String debugGetCreateSourceHash() => _$gameNotifierHash();

  @$internal
  @override
  GameNotifier create() => GameNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameUiState>(value),
    );
  }
}

String _$gameNotifierHash() => r'becf754c34fb6be7a8de26ae11d43c2c2cd74875';

/// The run on screen. Every rule is [GameRules]': this only forwards the
/// player's actions and keeps what each one did.

abstract class _$GameNotifier extends $Notifier<GameUiState> {
  GameUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<GameUiState, GameUiState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GameUiState, GameUiState>,
              GameUiState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
