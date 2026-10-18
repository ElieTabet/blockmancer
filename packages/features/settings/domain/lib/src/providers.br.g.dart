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

@ProviderFor(dailyReminderOn)
final dailyReminderOnProvider = DailyReminderOnProvider._();

final class DailyReminderOnProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  DailyReminderOnProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyReminderOnProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyReminderOnHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return dailyReminderOn(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$dailyReminderOnHash() => r'92ab722ed11584eb5908c09f24417e79144705ee';

/// Whether the player wants the daily reminder. A future, so the reminder is
/// never scheduled, or cancelled, on a default before the stored answer.

@ProviderFor(dailyReminderEnabled)
final dailyReminderEnabledProvider = DailyReminderEnabledProvider._();

/// Whether the player wants the daily reminder. A future, so the reminder is
/// never scheduled, or cancelled, on a default before the stored answer.

final class DailyReminderEnabledProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Whether the player wants the daily reminder. A future, so the reminder is
  /// never scheduled, or cancelled, on a default before the stored answer.
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
    r'e45cbdeeb23b2579bfe02456d5e8806d0ce30e21';

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

/// See [SendFeedbackBehavior].

@ProviderFor(sendFeedback)
final sendFeedbackProvider = SendFeedbackProvider._();

/// See [SendFeedbackBehavior].

final class SendFeedbackProvider
    extends
        $FunctionalProvider<SendFeedbackFun, SendFeedbackFun, SendFeedbackFun>
    with $Provider<SendFeedbackFun> {
  /// See [SendFeedbackBehavior].
  SendFeedbackProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendFeedbackProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sendFeedbackHash();

  @$internal
  @override
  $ProviderElement<SendFeedbackFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SendFeedbackFun create(Ref ref) {
    return sendFeedback(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SendFeedbackFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SendFeedbackFun>(value),
    );
  }
}

String _$sendFeedbackHash() => r'6b4eb90394b83e8fd2ff6f9f4c3cbaef876f9116';

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

@ProviderFor(testStatsSummary)
final testStatsSummaryProvider = TestStatsSummaryProvider._();

final class TestStatsSummaryProvider
    extends
        $FunctionalProvider<
          TestStatsSummaryFun,
          TestStatsSummaryFun,
          TestStatsSummaryFun
        >
    with $Provider<TestStatsSummaryFun> {
  TestStatsSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'testStatsSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$testStatsSummaryHash();

  @$internal
  @override
  $ProviderElement<TestStatsSummaryFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TestStatsSummaryFun create(Ref ref) {
    return testStatsSummary(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TestStatsSummaryFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TestStatsSummaryFun>(value),
    );
  }
}

String _$testStatsSummaryHash() => r'1b194efa11b1c7b8d755e43d2884f4d0363b253b';

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

/// Whether Settings offers "Privacy choices": only where the consent form
/// says the player must be able to change their answer.

@ProviderFor(privacyChoicesRequired)
final privacyChoicesRequiredProvider = PrivacyChoicesRequiredProvider._();

/// Whether Settings offers "Privacy choices": only where the consent form
/// says the player must be able to change their answer.

final class PrivacyChoicesRequiredProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether Settings offers "Privacy choices": only where the consent form
  /// says the player must be able to change their answer.
  PrivacyChoicesRequiredProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'privacyChoicesRequiredProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$privacyChoicesRequiredHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return privacyChoicesRequired(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$privacyChoicesRequiredHash() =>
    r'1e35ce0834ff63c161e06ad84e2ddc021d98340a';

@ProviderFor(openLegalNotice)
final openLegalNoticeProvider = OpenLegalNoticeProvider._();

final class OpenLegalNoticeProvider
    extends $FunctionalProvider<OpenLinkFun, OpenLinkFun, OpenLinkFun>
    with $Provider<OpenLinkFun> {
  OpenLegalNoticeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openLegalNoticeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openLegalNoticeHash();

  @$internal
  @override
  $ProviderElement<OpenLinkFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OpenLinkFun create(Ref ref) {
    return openLegalNotice(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OpenLinkFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OpenLinkFun>(value),
    );
  }
}

String _$openLegalNoticeHash() => r'6e92bc125d1338c02cab1e03cc14ccc5e857ce12';

@ProviderFor(openPrivacyPolicy)
final openPrivacyPolicyProvider = OpenPrivacyPolicyProvider._();

final class OpenPrivacyPolicyProvider
    extends $FunctionalProvider<OpenLinkFun, OpenLinkFun, OpenLinkFun>
    with $Provider<OpenLinkFun> {
  OpenPrivacyPolicyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openPrivacyPolicyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openPrivacyPolicyHash();

  @$internal
  @override
  $ProviderElement<OpenLinkFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OpenLinkFun create(Ref ref) {
    return openPrivacyPolicy(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OpenLinkFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OpenLinkFun>(value),
    );
  }
}

String _$openPrivacyPolicyHash() => r'ffcdd198e6a4288fa03cda46b79b2ce351993cd8';

@ProviderFor(openSupport)
final openSupportProvider = OpenSupportProvider._();

final class OpenSupportProvider
    extends $FunctionalProvider<OpenLinkFun, OpenLinkFun, OpenLinkFun>
    with $Provider<OpenLinkFun> {
  OpenSupportProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openSupportProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openSupportHash();

  @$internal
  @override
  $ProviderElement<OpenLinkFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OpenLinkFun create(Ref ref) {
    return openSupport(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OpenLinkFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OpenLinkFun>(value),
    );
  }
}

String _$openSupportHash() => r'b2fa836479f5dea4821227a81b3ffd2b74f97cee';
