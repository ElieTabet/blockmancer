// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_di.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(screenHeaderRouting)
final screenHeaderRoutingProvider = ScreenHeaderRoutingProvider._();

final class ScreenHeaderRoutingProvider
    extends
        $FunctionalProvider<
          ScreenHeaderRouting,
          ScreenHeaderRouting,
          ScreenHeaderRouting
        >
    with $Provider<ScreenHeaderRouting> {
  ScreenHeaderRoutingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'screenHeaderRoutingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$screenHeaderRoutingHash();

  @$internal
  @override
  $ProviderElement<ScreenHeaderRouting> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ScreenHeaderRouting create(Ref ref) {
    return screenHeaderRouting(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScreenHeaderRouting value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScreenHeaderRouting>(value),
    );
  }
}

String _$screenHeaderRoutingHash() =>
    r'2b691477f7ca5e8477eff68923ac058f265a9d5d';

/// Whether a member is signed in, as opposed to a guest browsing public titles.
///
/// Watched rather than read, so the control follows the session: it re-emits on
/// a sign-in, a sign-out, and a session the server ended.

@ProviderFor(isAuthenticated)
final isAuthenticatedProvider = IsAuthenticatedProvider._();

/// Whether a member is signed in, as opposed to a guest browsing public titles.
///
/// Watched rather than read, so the control follows the session: it re-emits on
/// a sign-in, a sign-out, and a session the server ended.

final class IsAuthenticatedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether a member is signed in, as opposed to a guest browsing public titles.
  ///
  /// Watched rather than read, so the control follows the session: it re-emits on
  /// a sign-in, a sign-out, and a session the server ended.
  IsAuthenticatedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isAuthenticatedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isAuthenticatedHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return isAuthenticated(ref);
  }
}

String _$isAuthenticatedHash() => r'dfde49c264e4e555ce1e66cc9b1028157ea8d04d';

@ProviderFor(logout)
final logoutProvider = LogoutProvider._();

final class LogoutProvider
    extends $FunctionalProvider<LogoutFun, LogoutFun, LogoutFun>
    with $Provider<LogoutFun> {
  LogoutProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logoutProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logoutHash();

  @$internal
  @override
  $ProviderElement<LogoutFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LogoutFun create(Ref ref) {
    return logout(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LogoutFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LogoutFun>(value),
    );
  }
}

String _$logoutHash() => r'9fc63656107d8ce7d0a3273d28b68a44490e9555';

/// The organization's name, as the server last set it. Null until one is known,
/// and the header then has no second line.

@ProviderFor(organizationName)
final organizationNameProvider = OrganizationNameProvider._();

/// The organization's name, as the server last set it. Null until one is known,
/// and the header then has no second line.

final class OrganizationNameProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// The organization's name, as the server last set it. Null until one is known,
  /// and the header then has no second line.
  OrganizationNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'organizationNameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$organizationNameHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return organizationName(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$organizationNameHash() => r'cb1b1002cecfaa969985c135722a14d96677d46c';
