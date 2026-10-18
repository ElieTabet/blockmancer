// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consent_notifier.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The player's consent, asked at launch where the law requires it, and
/// Analytics told the answer: granted only when ads may be requested, the
/// purpose-by-purpose detail being the consent string the form writes for
/// the SDKs. Null until it has been asked.

@ProviderFor(ConsentNotifier)
final consentProvider = ConsentNotifierProvider._();

/// The player's consent, asked at launch where the law requires it, and
/// Analytics told the answer: granted only when ads may be requested, the
/// purpose-by-purpose detail being the consent string the form writes for
/// the SDKs. Null until it has been asked.
final class ConsentNotifierProvider
    extends $NotifierProvider<ConsentNotifier, di.ConsentAnswer?> {
  /// The player's consent, asked at launch where the law requires it, and
  /// Analytics told the answer: granted only when ads may be requested, the
  /// purpose-by-purpose detail being the consent string the form writes for
  /// the SDKs. Null until it has been asked.
  ConsentNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'consentProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$consentNotifierHash();

  @$internal
  @override
  ConsentNotifier create() => ConsentNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(di.ConsentAnswer? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<di.ConsentAnswer?>(value),
    );
  }
}

String _$consentNotifierHash() => r'400096b0ead92646608f70b89fe8b47c4538b05a';

/// The player's consent, asked at launch where the law requires it, and
/// Analytics told the answer: granted only when ads may be requested, the
/// purpose-by-purpose detail being the consent string the form writes for
/// the SDKs. Null until it has been asked.

abstract class _$ConsentNotifier extends $Notifier<di.ConsentAnswer?> {
  di.ConsentAnswer? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<di.ConsentAnswer?, di.ConsentAnswer?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<di.ConsentAnswer?, di.ConsentAnswer?>,
              di.ConsentAnswer?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
