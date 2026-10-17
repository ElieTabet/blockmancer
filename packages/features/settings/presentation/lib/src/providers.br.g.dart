// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Shows the app in the language the player chose. Startup awaits it before
/// the first frame, so a chosen language never flashes the phone's first.

@ProviderFor(applyStoredLanguage)
final applyStoredLanguageProvider = ApplyStoredLanguageProvider._();

/// Shows the app in the language the player chose. Startup awaits it before
/// the first frame, so a chosen language never flashes the phone's first.

final class ApplyStoredLanguageProvider
    extends
        $FunctionalProvider<
          ApplyStoredLanguageFun,
          ApplyStoredLanguageFun,
          ApplyStoredLanguageFun
        >
    with $Provider<ApplyStoredLanguageFun> {
  /// Shows the app in the language the player chose. Startup awaits it before
  /// the first frame, so a chosen language never flashes the phone's first.
  ApplyStoredLanguageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'applyStoredLanguageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$applyStoredLanguageHash();

  @$internal
  @override
  $ProviderElement<ApplyStoredLanguageFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ApplyStoredLanguageFun create(Ref ref) {
    return applyStoredLanguage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApplyStoredLanguageFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApplyStoredLanguageFun>(value),
    );
  }
}

String _$applyStoredLanguageHash() =>
    r'a1082437fc9fef197dfc6fb9068de19724f5bca3';
