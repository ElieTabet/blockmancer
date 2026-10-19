// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Completes once the game has finished with its last move: played back, and
/// its run, progression and run-end count written. At once with no game on
/// screen.

@ProviderFor(whenGameSettled)
final whenGameSettledProvider = WhenGameSettledProvider._();

/// Completes once the game has finished with its last move: played back, and
/// its run, progression and run-end count written. At once with no game on
/// screen.

final class WhenGameSettledProvider
    extends
        $FunctionalProvider<
          WhenGameSettledFun,
          WhenGameSettledFun,
          WhenGameSettledFun
        >
    with $Provider<WhenGameSettledFun> {
  /// Completes once the game has finished with its last move: played back, and
  /// its run, progression and run-end count written. At once with no game on
  /// screen.
  WhenGameSettledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'whenGameSettledProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$whenGameSettledHash();

  @$internal
  @override
  $ProviderElement<WhenGameSettledFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WhenGameSettledFun create(Ref ref) {
    return whenGameSettled(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WhenGameSettledFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WhenGameSettledFun>(value),
    );
  }
}

String _$whenGameSettledHash() => r'a28fe485f967dd717eb4453129bc160fa871b320';
