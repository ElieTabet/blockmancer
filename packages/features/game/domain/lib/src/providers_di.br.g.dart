// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_di.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Where what players do is counted: the testers' log today, Firebase
/// Analytics later.
/// Whether the player bought Remove ads: no interstitial, ever.

@ProviderFor(adsRemoved)
final adsRemovedProvider = AdsRemovedProvider._();

/// Where what players do is counted: the testers' log today, Firebase
/// Analytics later.
/// Whether the player bought Remove ads: no interstitial, ever.

final class AdsRemovedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Where what players do is counted: the testers' log today, Firebase
  /// Analytics later.
  /// Whether the player bought Remove ads: no interstitial, ever.
  AdsRemovedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adsRemovedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adsRemovedHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return adsRemoved(ref);
  }
}

String _$adsRemovedHash() => r'2d95911321547276c5ca592eca3b0ae66b9bcd5a';

/// This build's version (`1.0.0`): the rating prompt asks once per version.

@ProviderFor(appVersion)
final appVersionProvider = AppVersionProvider._();

/// This build's version (`1.0.0`): the rating prompt asks once per version.

final class AppVersionProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// This build's version (`1.0.0`): the rating prompt asks once per version.
  AppVersionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appVersionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appVersionHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return appVersion(ref);
  }
}

String _$appVersionHash() => r'2033e49eec6555757226a5c67f3c984b8dc77554';

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

@ProviderFor(bestScores)
final bestScoresProvider = BestScoresProvider._();

final class BestScoresProvider
    extends $FunctionalProvider<BestScores, BestScores, BestScores>
    with $Provider<BestScores> {
  BestScoresProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bestScoresProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bestScoresHash();

  @$internal
  @override
  $ProviderElement<BestScores> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BestScores create(Ref ref) {
    return bestScores(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BestScores value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BestScores>(value),
    );
  }
}

String _$bestScoresHash() => r'7cdda2be00059baacd975dd0f072dae92c2472d6';

@ProviderFor(clock)
final clockProvider = ClockProvider._();

final class ClockProvider extends $FunctionalProvider<Clock, Clock, Clock>
    with $Provider<Clock> {
  ClockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clockProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clockHash();

  @$internal
  @override
  $ProviderElement<Clock> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Clock create(Ref ref) {
    return clock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Clock value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Clock>(value),
    );
  }
}

String _$clockHash() => r'b653369ba50137730cd13dc493ff7ddd9dc8b9b6';

/// The game's rules. Composition binds the engine; the game never imports it,
/// so its screens can only draw what the rules say. Here rather than in
/// presentation because the domain decides each mode's seed with them.

@ProviderFor(gameRules)
final gameRulesProvider = GameRulesProvider._();

/// The game's rules. Composition binds the engine; the game never imports it,
/// so its screens can only draw what the rules say. Here rather than in
/// presentation because the domain decides each mode's seed with them.

final class GameRulesProvider
    extends $FunctionalProvider<GameRules, GameRules, GameRules>
    with $Provider<GameRules> {
  /// The game's rules. Composition binds the engine; the game never imports it,
  /// so its screens can only draw what the rules say. Here rather than in
  /// presentation because the domain decides each mode's seed with them.
  GameRulesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameRulesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameRulesHash();

  @$internal
  @override
  $ProviderElement<GameRules> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GameRules create(Ref ref) {
    return gameRules(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameRules value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameRules>(value),
    );
  }
}

String _$gameRulesHash() => r'aedb42ba0debe7407ed8cfe4af33bf6cc721b26f';

@ProviderFor(engagementStore)
final engagementStoreProvider = EngagementStoreProvider._();

final class EngagementStoreProvider
    extends
        $FunctionalProvider<EngagementStore, EngagementStore, EngagementStore>
    with $Provider<EngagementStore> {
  EngagementStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'engagementStoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$engagementStoreHash();

  @$internal
  @override
  $ProviderElement<EngagementStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EngagementStore create(Ref ref) {
    return engagementStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EngagementStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EngagementStore>(value),
    );
  }
}

String _$engagementStoreHash() => r'14885e05621a62df35ee05d9bc86de0964904e2d';

@ProviderFor(progressionStore)
final progressionStoreProvider = ProgressionStoreProvider._();

final class ProgressionStoreProvider
    extends
        $FunctionalProvider<
          ProgressionStore,
          ProgressionStore,
          ProgressionStore
        >
    with $Provider<ProgressionStore> {
  ProgressionStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'progressionStoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$progressionStoreHash();

  @$internal
  @override
  $ProviderElement<ProgressionStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ProgressionStore create(Ref ref) {
    return progressionStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProgressionStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProgressionStore>(value),
    );
  }
}

String _$progressionStoreHash() => r'7559444db90e56c507ff5f951b02998f0e0ddb45';

/// What Remote Config publishes, read by key: the numbers a new run is
/// tuned with (see `tuned`).

@ProviderFor(remoteValue)
final remoteValueProvider = RemoteValueProvider._();

/// What Remote Config publishes, read by key: the numbers a new run is
/// tuned with (see `tuned`).

final class RemoteValueProvider
    extends $FunctionalProvider<RemoteValueFun, RemoteValueFun, RemoteValueFun>
    with $Provider<RemoteValueFun> {
  /// What Remote Config publishes, read by key: the numbers a new run is
  /// tuned with (see `tuned`).
  RemoteValueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remoteValueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remoteValueHash();

  @$internal
  @override
  $ProviderElement<RemoteValueFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RemoteValueFun create(Ref ref) {
    return remoteValue(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RemoteValueFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RemoteValueFun>(value),
    );
  }
}

String _$remoteValueHash() => r'fbb114e2b7619ca4e1415339f8708000819c098a';

@ProviderFor(runStore)
final runStoreProvider = RunStoreProvider._();

final class RunStoreProvider
    extends $FunctionalProvider<RunStore, RunStore, RunStore>
    with $Provider<RunStore> {
  RunStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'runStoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$runStoreHash();

  @$internal
  @override
  $ProviderElement<RunStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RunStore create(Ref ref) {
    return runStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RunStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RunStore>(value),
    );
  }
}

String _$runStoreHash() => r'812affa06697708f46f9b20eec5dc0fedf0be838';

@ProviderFor(showInterstitial)
final showInterstitialProvider = ShowInterstitialProvider._();

final class ShowInterstitialProvider
    extends $FunctionalProvider<ShowAdFun, ShowAdFun, ShowAdFun>
    with $Provider<ShowAdFun> {
  ShowInterstitialProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showInterstitialProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showInterstitialHash();

  @$internal
  @override
  $ProviderElement<ShowAdFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ShowAdFun create(Ref ref) {
    return showInterstitial(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShowAdFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShowAdFun>(value),
    );
  }
}

String _$showInterstitialHash() => r'e8ce7656a04ce27dc2a8c548656b1ce3a90b9ef5';

@ProviderFor(requestReview)
final requestReviewProvider = RequestReviewProvider._();

final class RequestReviewProvider
    extends
        $FunctionalProvider<
          RequestReviewFun,
          RequestReviewFun,
          RequestReviewFun
        >
    with $Provider<RequestReviewFun> {
  RequestReviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'requestReviewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$requestReviewHash();

  @$internal
  @override
  $ProviderElement<RequestReviewFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RequestReviewFun create(Ref ref) {
    return requestReview(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestReviewFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestReviewFun>(value),
    );
  }
}

String _$requestReviewHash() => r'e3dcae0d9f2d931b14df939289b25237e456885b';

@ProviderFor(sessionHadError)
final sessionHadErrorProvider = SessionHadErrorProvider._();

final class SessionHadErrorProvider
    extends
        $FunctionalProvider<
          SessionHadErrorFun,
          SessionHadErrorFun,
          SessionHadErrorFun
        >
    with $Provider<SessionHadErrorFun> {
  SessionHadErrorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionHadErrorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionHadErrorHash();

  @$internal
  @override
  $ProviderElement<SessionHadErrorFun> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SessionHadErrorFun create(Ref ref) {
    return sessionHadError(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionHadErrorFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionHadErrorFun>(value),
    );
  }
}

String _$sessionHadErrorHash() => r'683e412e2b0b515f76d10ab8dc885bc684849949';

/// The all-time board: every run's total.

@ProviderFor(submitBestScore)
final submitBestScoreProvider = SubmitBestScoreProvider._();

/// The all-time board: every run's total.

final class SubmitBestScoreProvider
    extends $FunctionalProvider<SubmitScoreFun, SubmitScoreFun, SubmitScoreFun>
    with $Provider<SubmitScoreFun> {
  /// The all-time board: every run's total.
  SubmitBestScoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'submitBestScoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$submitBestScoreHash();

  @$internal
  @override
  $ProviderElement<SubmitScoreFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SubmitScoreFun create(Ref ref) {
    return submitBestScore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubmitScoreFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SubmitScoreFun>(value),
    );
  }
}

String _$submitBestScoreHash() => r'2dd3f1f9b87447707dfcaf917adf7fe9ec356ad2';

/// The day's board, which the platform resets every day at 00:00 UTC.

@ProviderFor(submitDailyScore)
final submitDailyScoreProvider = SubmitDailyScoreProvider._();

/// The day's board, which the platform resets every day at 00:00 UTC.

final class SubmitDailyScoreProvider
    extends $FunctionalProvider<SubmitScoreFun, SubmitScoreFun, SubmitScoreFun>
    with $Provider<SubmitScoreFun> {
  /// The day's board, which the platform resets every day at 00:00 UTC.
  SubmitDailyScoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'submitDailyScoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$submitDailyScoreHash();

  @$internal
  @override
  $ProviderElement<SubmitScoreFun> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SubmitScoreFun create(Ref ref) {
    return submitDailyScore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubmitScoreFun value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SubmitScoreFun>(value),
    );
  }
}

String _$submitDailyScoreHash() => r'2da033c7846a194441d0230df0858a6e9a0b21e9';
