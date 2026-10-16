// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_di.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Asks for notification permission and reports the token, whatever the
/// answer. Home only says when.

@ProviderFor(askForNotifications)
final askForNotificationsProvider = AskForNotificationsProvider._();

/// Asks for notification permission and reports the token, whatever the
/// answer. Home only says when.

final class AskForNotificationsProvider
    extends
        $FunctionalProvider<
          AskForNotificationsFun,
          AskForNotificationsFun,
          AskForNotificationsFun
        >
    with $Provider<AskForNotificationsFun> {
  /// Asks for notification permission and reports the token, whatever the
  /// answer. Home only says when.
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
    r'f7f6cca65ba461e21c01455ff5ad4fd93e6da97f';
