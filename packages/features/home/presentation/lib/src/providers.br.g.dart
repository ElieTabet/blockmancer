// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Scrolls Home back to the daily run's card, if Home is up: where a tapped
/// daily reminder lands.

@ProviderFor(revealDailyCard)
final revealDailyCardProvider = RevealDailyCardProvider._();

/// Scrolls Home back to the daily run's card, if Home is up: where a tapped
/// daily reminder lands.

final class RevealDailyCardProvider
    extends
        $FunctionalProvider<
          RevealDailyCardFun,
          RevealDailyCardFun,
          RevealDailyCardFun
        >
    with $Provider<RevealDailyCardFun> {
  /// Scrolls Home back to the daily run's card, if Home is up: where a tapped
  /// daily reminder lands.
  RevealDailyCardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'revealDailyCardProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$revealDailyCardHash();

  @$internal
  @override
  $ProviderElement<RevealDailyCardFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RevealDailyCardFun create(Ref ref) {
    return revealDailyCard(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RevealDailyCardFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RevealDailyCardFun>(value),
    );
  }
}

String _$revealDailyCardHash() => r'0baaf868a63e9a81ce13367f0ebbf830e9927b84';
