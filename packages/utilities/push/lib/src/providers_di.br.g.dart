// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_di.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// `keepAlive` because the implementation owns a stream subscription: an
/// auto-disposed slot would hand out a fresh instance after every idle moment
/// and leak the foreground listener the previous one installed.

@ProviderFor(pushMessaging)
final pushMessagingProvider = PushMessagingProvider._();

/// `keepAlive` because the implementation owns a stream subscription: an
/// auto-disposed slot would hand out a fresh instance after every idle moment
/// and leak the foreground listener the previous one installed.

final class PushMessagingProvider
    extends $FunctionalProvider<PushMessaging, PushMessaging, PushMessaging>
    with $Provider<PushMessaging> {
  /// `keepAlive` because the implementation owns a stream subscription: an
  /// auto-disposed slot would hand out a fresh instance after every idle moment
  /// and leak the foreground listener the previous one installed.
  PushMessagingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushMessagingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushMessagingHash();

  @$internal
  @override
  $ProviderElement<PushMessaging> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PushMessaging create(Ref ref) {
    return pushMessaging(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushMessaging value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushMessaging>(value),
    );
  }
}

String _$pushMessagingHash() => r'c43d2128c93e56beef3110dfb7add2fca48a3135';
