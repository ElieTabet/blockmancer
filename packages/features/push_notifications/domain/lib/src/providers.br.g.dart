// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The permission prompt and the token report behind it. See
/// [AskForNotificationsBehavior] for why they go together, in that order.

@ProviderFor(askForNotifications)
final askForNotificationsProvider = AskForNotificationsProvider._();

/// The permission prompt and the token report behind it. See
/// [AskForNotificationsBehavior] for why they go together, in that order.

final class AskForNotificationsProvider
    extends
        $FunctionalProvider<
          AskForNotificationsFun,
          AskForNotificationsFun,
          AskForNotificationsFun
        >
    with $Provider<AskForNotificationsFun> {
  /// The permission prompt and the token report behind it. See
  /// [AskForNotificationsBehavior] for why they go together, in that order.
  AskForNotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'askForNotificationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$askForNotificationsHash();

  @$internal
  @override
  $ProviderElement<AskForNotificationsFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AskForNotificationsFun create(Ref ref) {
    return askForNotifications(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AskForNotificationsFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AskForNotificationsFun>(value),
    );
  }
}

String _$askForNotificationsHash() =>
    r'ee15952d2779a5652850fa970eed5e1c7098fbb8';

@ProviderFor(pushDestinations)
final pushDestinationsProvider = PushDestinationsProvider._();

final class PushDestinationsProvider
    extends
        $FunctionalProvider<
          PushDestinationsFun,
          PushDestinationsFun,
          PushDestinationsFun
        >
    with $Provider<PushDestinationsFun> {
  PushDestinationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushDestinationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushDestinationsHash();

  @$internal
  @override
  $ProviderElement<PushDestinationsFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PushDestinationsFun create(Ref ref) {
    return pushDestinations(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushDestinationsFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushDestinationsFun>(value),
    );
  }
}

String _$pushDestinationsHash() => r'9dbd0889e7ef94e767bb207086187bf592e2ad70';

/// Reports every token FCM mints after the first.
///
/// `keepAlive` is what makes "subscribes once" true rather than hopeful: a
/// second start — signing out prepares the device again — reads this same
/// instance instead of opening a second subscription, so no guard flag is
/// needed.
///
/// Nothing starts it but [startPushTokenSyncProvider], which `device` calls
/// only once registration has succeeded: a report before that could only 401.

@ProviderFor(pushTokenSync)
final pushTokenSyncProvider = PushTokenSyncProvider._();

/// Reports every token FCM mints after the first.
///
/// `keepAlive` is what makes "subscribes once" true rather than hopeful: a
/// second start — signing out prepares the device again — reads this same
/// instance instead of opening a second subscription, so no guard flag is
/// needed.
///
/// Nothing starts it but [startPushTokenSyncProvider], which `device` calls
/// only once registration has succeeded: a report before that could only 401.

final class PushTokenSyncProvider extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Reports every token FCM mints after the first.
  ///
  /// `keepAlive` is what makes "subscribes once" true rather than hopeful: a
  /// second start — signing out prepares the device again — reads this same
  /// instance instead of opening a second subscription, so no guard flag is
  /// needed.
  ///
  /// Nothing starts it but [startPushTokenSyncProvider], which `device` calls
  /// only once registration has succeeded: a report before that could only 401.
  PushTokenSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushTokenSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushTokenSyncHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return pushTokenSync(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$pushTokenSyncHash() => r'2b2fec83f5e37bb6b9813f446e5e977af3d20c07';

/// `keepAlive` because the caller holds the function across an await: an
/// auto-disposed provider could be gone by the time it is called, and its
/// `ref` with it.

@ProviderFor(startPushTokenSync)
final startPushTokenSyncProvider = StartPushTokenSyncProvider._();

/// `keepAlive` because the caller holds the function across an await: an
/// auto-disposed provider could be gone by the time it is called, and its
/// `ref` with it.

final class StartPushTokenSyncProvider
    extends
        $FunctionalProvider<
          StartPushTokenSyncFun,
          StartPushTokenSyncFun,
          StartPushTokenSyncFun
        >
    with $Provider<StartPushTokenSyncFun> {
  /// `keepAlive` because the caller holds the function across an await: an
  /// auto-disposed provider could be gone by the time it is called, and its
  /// `ref` with it.
  StartPushTokenSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'startPushTokenSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$startPushTokenSyncHash();

  @$internal
  @override
  $ProviderElement<StartPushTokenSyncFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StartPushTokenSyncFun create(Ref ref) {
    return startPushTokenSync(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StartPushTokenSyncFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StartPushTokenSyncFun>(value),
    );
  }
}

String _$startPushTokenSyncHash() =>
    r'fc6edc52a175c19789bd0babae8a886e5704ecad';
