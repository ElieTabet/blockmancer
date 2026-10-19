// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_di.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(analyticsSink)
final analyticsSinkProvider = AnalyticsSinkProvider._();

final class AnalyticsSinkProvider
    extends $FunctionalProvider<AnalyticsSink, AnalyticsSink, AnalyticsSink>
    with $Provider<AnalyticsSink> {
  AnalyticsSinkProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsSinkProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analyticsSinkHash();

  @$internal
  @override
  $ProviderElement<AnalyticsSink> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AnalyticsSink create(Ref ref) {
    return analyticsSink(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalyticsSink value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalyticsSink>(value),
    );
  }
}

String _$analyticsSinkHash() => r'0c3ecec390e77acb21ab1c90e5a089e918fd2c63';

@ProviderFor(cancelDailyReminder)
final cancelDailyReminderProvider = CancelDailyReminderProvider._();

final class CancelDailyReminderProvider
    extends
        $FunctionalProvider<
          CancelDailyReminderFun,
          CancelDailyReminderFun,
          CancelDailyReminderFun
        >
    with $Provider<CancelDailyReminderFun> {
  CancelDailyReminderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cancelDailyReminderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cancelDailyReminderHash();

  @$internal
  @override
  $ProviderElement<CancelDailyReminderFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CancelDailyReminderFun create(Ref ref) {
    return cancelDailyReminder(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CancelDailyReminderFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CancelDailyReminderFun>(value),
    );
  }
}

String _$cancelDailyReminderHash() =>
    r'65cb43c43fe116df90b3c763096738624d61ecbf';

/// Whether the player wants the daily reminder (Settings).

@ProviderFor(dailyReminderEnabled)
final dailyReminderEnabledProvider = DailyReminderEnabledProvider._();

/// Whether the player wants the daily reminder (Settings).

final class DailyReminderEnabledProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether the player wants the daily reminder (Settings).
  DailyReminderEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyReminderEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyReminderEnabledHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return dailyReminderEnabled(ref);
  }
}

String _$dailyReminderEnabledHash() =>
    r'86cddef77da9a317984a57f9805f0e0f49f324d6';

@ProviderFor(dailyStanding)
final dailyStandingProvider = DailyStandingProvider._();

final class DailyStandingProvider
    extends
        $FunctionalProvider<
          DailyStandingFun,
          DailyStandingFun,
          DailyStandingFun
        >
    with $Provider<DailyStandingFun> {
  DailyStandingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyStandingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyStandingHash();

  @$internal
  @override
  $ProviderElement<DailyStandingFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DailyStandingFun create(Ref ref) {
    return dailyStanding(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DailyStandingFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DailyStandingFun>(value),
    );
  }
}

String _$dailyStandingHash() => r'4991def7b697eda2e2a664096c901cd44df13509';

/// The language the app shows (`en`, `fr`), now and on every change.

@ProviderFor(displayLanguage)
final displayLanguageProvider = DisplayLanguageProvider._();

/// The language the app shows (`en`, `fr`), now and on every change.

final class DisplayLanguageProvider
    extends $FunctionalProvider<AsyncValue<String>, String, Stream<String>>
    with $FutureModifier<String>, $StreamProvider<String> {
  /// The language the app shows (`en`, `fr`), now and on every change.
  DisplayLanguageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'displayLanguageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$displayLanguageHash();

  @$internal
  @override
  $StreamProviderElement<String> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<String> create(Ref ref) {
    return displayLanguage(ref);
  }
}

String _$displayLanguageHash() => r'8cf3e5616e6fbba9e6577833ae699c9560cf973f';

@ProviderFor(hasCompletedRun)
final hasCompletedRunProvider = HasCompletedRunProvider._();

final class HasCompletedRunProvider
    extends
        $FunctionalProvider<
          HasCompletedRunFun,
          HasCompletedRunFun,
          HasCompletedRunFun
        >
    with $Provider<HasCompletedRunFun> {
  HasCompletedRunProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasCompletedRunProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hasCompletedRunHash();

  @$internal
  @override
  $ProviderElement<HasCompletedRunFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HasCompletedRunFun create(Ref ref) {
    return hasCompletedRun(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HasCompletedRunFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HasCompletedRunFun>(value),
    );
  }
}

String _$hasCompletedRunHash() => r'346d399c25460b59048b472ba108383f05231577';

@ProviderFor(launchMessage)
final launchMessageProvider = LaunchMessageProvider._();

final class LaunchMessageProvider
    extends
        $FunctionalProvider<
          LaunchMessageFun,
          LaunchMessageFun,
          LaunchMessageFun
        >
    with $Provider<LaunchMessageFun> {
  LaunchMessageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'launchMessageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$launchMessageHash();

  @$internal
  @override
  $ProviderElement<LaunchMessageFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LaunchMessageFun create(Ref ref) {
    return launchMessage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LaunchMessageFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LaunchMessageFun>(value),
    );
  }
}

String _$launchMessageHash() => r'97249ce3894c6c4c4710647b435502992bfc91ae';

@ProviderFor(now)
final nowProvider = NowProvider._();

final class NowProvider extends $FunctionalProvider<NowFun, NowFun, NowFun>
    with $Provider<NowFun> {
  NowProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nowProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nowHash();

  @$internal
  @override
  $ProviderElement<NowFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NowFun create(Ref ref) {
    return now(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NowFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NowFun>(value),
    );
  }
}

String _$nowHash() => r'3f98f48522fb3cdf4fc7a045b74ba2ce21052b6c';

@ProviderFor(openedMessages)
final openedMessagesProvider = OpenedMessagesProvider._();

final class OpenedMessagesProvider
    extends
        $FunctionalProvider<
          OpenedMessagesFun,
          OpenedMessagesFun,
          OpenedMessagesFun
        >
    with $Provider<OpenedMessagesFun> {
  OpenedMessagesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openedMessagesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openedMessagesHash();

  @$internal
  @override
  $ProviderElement<OpenedMessagesFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OpenedMessagesFun create(Ref ref) {
    return openedMessages(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OpenedMessagesFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OpenedMessagesFun>(value),
    );
  }
}

String _$openedMessagesHash() => r'84b64396a0311ce77db3e63264d6ce320bdcc704';

@ProviderFor(pushTokenChanges)
final pushTokenChangesProvider = PushTokenChangesProvider._();

final class PushTokenChangesProvider
    extends
        $FunctionalProvider<
          PushTokenChangesFun,
          PushTokenChangesFun,
          PushTokenChangesFun
        >
    with $Provider<PushTokenChangesFun> {
  PushTokenChangesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushTokenChangesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushTokenChangesHash();

  @$internal
  @override
  $ProviderElement<PushTokenChangesFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PushTokenChangesFun create(Ref ref) {
    return pushTokenChanges(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushTokenChangesFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushTokenChangesFun>(value),
    );
  }
}

String _$pushTokenChangesHash() => r'1fe2be838831601071a2f664748560e08871c703';

@ProviderFor(readPushToken)
final readPushTokenProvider = ReadPushTokenProvider._();

final class ReadPushTokenProvider
    extends
        $FunctionalProvider<
          ReadPushTokenFun,
          ReadPushTokenFun,
          ReadPushTokenFun
        >
    with $Provider<ReadPushTokenFun> {
  ReadPushTokenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readPushTokenProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readPushTokenHash();

  @$internal
  @override
  $ProviderElement<ReadPushTokenFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ReadPushTokenFun create(Ref ref) {
    return readPushToken(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReadPushTokenFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReadPushTokenFun>(value),
    );
  }
}

String _$readPushTokenHash() => r'cb92c7f70ac3ce680d18cd572eaed9cadb35b50b';

@ProviderFor(reminderLogStore)
final reminderLogStoreProvider = ReminderLogStoreProvider._();

final class ReminderLogStoreProvider
    extends
        $FunctionalProvider<
          ReminderLogStore,
          ReminderLogStore,
          ReminderLogStore
        >
    with $Provider<ReminderLogStore> {
  ReminderLogStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderLogStoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderLogStoreHash();

  @$internal
  @override
  $ProviderElement<ReminderLogStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ReminderLogStore create(Ref ref) {
    return reminderLogStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReminderLogStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReminderLogStore>(value),
    );
  }
}

String _$reminderLogStoreHash() => r'33eaddd8ea83664bb4858ab489f76eaa72ade099';

@ProviderFor(reminderTexts)
final reminderTextsProvider = ReminderTextsProvider._();

final class ReminderTextsProvider
    extends
        $FunctionalProvider<
          ReminderTextsFun,
          ReminderTextsFun,
          ReminderTextsFun
        >
    with $Provider<ReminderTextsFun> {
  ReminderTextsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderTextsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderTextsHash();

  @$internal
  @override
  $ProviderElement<ReminderTextsFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ReminderTextsFun create(Ref ref) {
    return reminderTexts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReminderTextsFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReminderTextsFun>(value),
    );
  }
}

String _$reminderTextsHash() => r'c77c0f30ee5d376e781ae4cfc04243b866b422bf';

@ProviderFor(reminderTimes)
final reminderTimesProvider = ReminderTimesProvider._();

final class ReminderTimesProvider
    extends
        $FunctionalProvider<
          ReminderTimesFun,
          ReminderTimesFun,
          ReminderTimesFun
        >
    with $Provider<ReminderTimesFun> {
  ReminderTimesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderTimesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderTimesHash();

  @$internal
  @override
  $ProviderElement<ReminderTimesFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ReminderTimesFun create(Ref ref) {
    return reminderTimes(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReminderTimesFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReminderTimesFun>(value),
    );
  }
}

String _$reminderTimesHash() => r'9385554bc8b8228883db46ce4bef015535b7c365';

@ProviderFor(replaceReminders)
final replaceRemindersProvider = ReplaceRemindersProvider._();

final class ReplaceRemindersProvider
    extends
        $FunctionalProvider<
          ReplaceRemindersFun,
          ReplaceRemindersFun,
          ReplaceRemindersFun
        >
    with $Provider<ReplaceRemindersFun> {
  ReplaceRemindersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'replaceRemindersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$replaceRemindersHash();

  @$internal
  @override
  $ProviderElement<ReplaceRemindersFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReplaceRemindersFun create(Ref ref) {
    return replaceReminders(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReplaceRemindersFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReplaceRemindersFun>(value),
    );
  }
}

String _$replaceRemindersHash() => r'f6becc560a0db4541dc1cc27551bd9ef4f688744';

@ProviderFor(reportPushToken)
final reportPushTokenProvider = ReportPushTokenProvider._();

final class ReportPushTokenProvider
    extends
        $FunctionalProvider<
          ReportPushTokenFun,
          ReportPushTokenFun,
          ReportPushTokenFun
        >
    with $Provider<ReportPushTokenFun> {
  ReportPushTokenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportPushTokenProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportPushTokenHash();

  @$internal
  @override
  $ProviderElement<ReportPushTokenFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReportPushTokenFun create(Ref ref) {
    return reportPushToken(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReportPushTokenFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReportPushTokenFun>(value),
    );
  }
}

String _$reportPushTokenHash() => r'106d1bedd00ee2e554b3579249ee50b3b5bb457c';

@ProviderFor(requestPushPermission)
final requestPushPermissionProvider = RequestPushPermissionProvider._();

final class RequestPushPermissionProvider
    extends
        $FunctionalProvider<
          RequestPushPermissionFun,
          RequestPushPermissionFun,
          RequestPushPermissionFun
        >
    with $Provider<RequestPushPermissionFun> {
  RequestPushPermissionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'requestPushPermissionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$requestPushPermissionHash();

  @$internal
  @override
  $ProviderElement<RequestPushPermissionFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RequestPushPermissionFun create(Ref ref) {
    return requestPushPermission(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestPushPermissionFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestPushPermissionFun>(value),
    );
  }
}

String _$requestPushPermissionHash() =>
    r'45fb9ca1691ba5084944215ffb70367b3a1a62c8';
