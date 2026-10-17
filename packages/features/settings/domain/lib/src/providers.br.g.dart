// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The language the player chose. A future, so the app can be put in it
/// before its first frame rather than switch after.

@ProviderFor(appLanguage)
final appLanguageProvider = AppLanguageProvider._();

/// The language the player chose. A future, so the app can be put in it
/// before its first frame rather than switch after.

final class AppLanguageProvider
    extends
        $FunctionalProvider<
          AsyncValue<AppLanguage>,
          AppLanguage,
          FutureOr<AppLanguage>
        >
    with $FutureModifier<AppLanguage>, $FutureProvider<AppLanguage> {
  /// The language the player chose. A future, so the app can be put in it
  /// before its first frame rather than switch after.
  AppLanguageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLanguageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLanguageHash();

  @$internal
  @override
  $FutureProviderElement<AppLanguage> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AppLanguage> create(Ref ref) {
    return appLanguage(ref);
  }
}

String _$appLanguageHash() => r'1d56107601c693f4a605d19040dbce932f6823a3';

@ProviderFor(hapticsOn)
final hapticsOnProvider = HapticsOnProvider._();

final class HapticsOnProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  HapticsOnProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hapticsOnProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hapticsOnHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return hapticsOn(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$hapticsOnHash() => r'3bd85ff52d89838dc2d75fecad3103093f2ce3ed';

@ProviderFor(reduceMotionOn)
final reduceMotionOnProvider = ReduceMotionOnProvider._();

final class ReduceMotionOnProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  ReduceMotionOnProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reduceMotionOnProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reduceMotionOnHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return reduceMotionOn(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$reduceMotionOnHash() => r'52d21460dc6e618504e934b0ddd7d0cfe9a0c421';

/// See [ResetProgressBehavior].

@ProviderFor(resetProgress)
final resetProgressProvider = ResetProgressProvider._();

/// See [ResetProgressBehavior].

final class ResetProgressProvider
    extends
        $FunctionalProvider<
          ResetProgressFun,
          ResetProgressFun,
          ResetProgressFun
        >
    with $Provider<ResetProgressFun> {
  /// See [ResetProgressBehavior].
  ResetProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resetProgressProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resetProgressHash();

  @$internal
  @override
  $ProviderElement<ResetProgressFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ResetProgressFun create(Ref ref) {
    return resetProgress(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResetProgressFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResetProgressFun>(value),
    );
  }
}

String _$resetProgressHash() => r'eb8209e70a22991acc5fa3809a3389022f2a94bd';

@ProviderFor(soundOn)
final soundOnProvider = SoundOnProvider._();

final class SoundOnProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  SoundOnProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'soundOnProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$soundOnHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return soundOn(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$soundOnHash() => r'e36a0ce920ad6349d10a1aa9b59033f966e15178';

/// Whether the player has been through the tutorial. A future, so a launch
/// waits for the stored answer instead of showing the tutorial on a default.

@ProviderFor(tutorialSeen)
final tutorialSeenProvider = TutorialSeenProvider._();

/// Whether the player has been through the tutorial. A future, so a launch
/// waits for the stored answer instead of showing the tutorial on a default.

final class TutorialSeenProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether the player has been through the tutorial. A future, so a launch
  /// waits for the stored answer instead of showing the tutorial on a default.
  TutorialSeenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tutorialSeenProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tutorialSeenHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return tutorialSeen(ref);
  }
}

String _$tutorialSeenHash() => r'fa8912d515ce54cdff56c73f892d59023b901a66';
