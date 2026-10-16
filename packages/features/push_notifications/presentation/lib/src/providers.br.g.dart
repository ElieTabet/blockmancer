// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The one push step boot takes, once per launch.
///
/// Messaging first, then the taps: Android's taps on what the app drew itself
/// are only reported once `push` has initialized the plugin that drew them.
///
/// Never throws. Boot awaits this before `runApp`, so a failure here — an icon
/// the OS can't resolve, no Play services — would leave the app on its splash
/// for good. The app launches without push that session instead, and the
/// failure goes to the crash reporter as non-fatal.

@ProviderFor(initializePushNotifications)
final initializePushNotificationsProvider =
    InitializePushNotificationsProvider._();

/// The one push step boot takes, once per launch.
///
/// Messaging first, then the taps: Android's taps on what the app drew itself
/// are only reported once `push` has initialized the plugin that drew them.
///
/// Never throws. Boot awaits this before `runApp`, so a failure here — an icon
/// the OS can't resolve, no Play services — would leave the app on its splash
/// for good. The app launches without push that session instead, and the
/// failure goes to the crash reporter as non-fatal.

final class InitializePushNotificationsProvider
    extends
        $FunctionalProvider<
          InitializePushNotificationsFun,
          InitializePushNotificationsFun,
          InitializePushNotificationsFun
        >
    with $Provider<InitializePushNotificationsFun> {
  /// The one push step boot takes, once per launch.
  ///
  /// Messaging first, then the taps: Android's taps on what the app drew itself
  /// are only reported once `push` has initialized the plugin that drew them.
  ///
  /// Never throws. Boot awaits this before `runApp`, so a failure here — an icon
  /// the OS can't resolve, no Play services — would leave the app on its splash
  /// for good. The app launches without push that session instead, and the
  /// failure goes to the crash reporter as non-fatal.
  InitializePushNotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'initializePushNotificationsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$initializePushNotificationsHash();

  @$internal
  @override
  $ProviderElement<InitializePushNotificationsFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InitializePushNotificationsFun create(Ref ref) {
    return initializePushNotifications(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InitializePushNotificationsFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InitializePushNotificationsFun>(
        value,
      ),
    );
  }
}

String _$initializePushNotificationsHash() =>
    r'aeeb90add4eced06c3256ffd7afeae9563da1eec';
