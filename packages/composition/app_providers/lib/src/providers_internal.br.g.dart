// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers_internal.br.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One for the app's life, so the ad SDK starts once. A test build can show
/// the form as in the EEA from anywhere: `--dart-define=UMP_DEBUG_EEA=true`
/// with the device's id from the UMP log as `UMP_TEST_DEVICE_ID`.

@ProviderFor(consent)
final consentProvider = ConsentProvider._();

/// One for the app's life, so the ad SDK starts once. A test build can show
/// the form as in the EEA from anywhere: `--dart-define=UMP_DEBUG_EEA=true`
/// with the device's id from the UMP log as `UMP_TEST_DEVICE_ID`.

final class ConsentProvider
    extends $FunctionalProvider<Consent, Consent, Consent>
    with $Provider<Consent> {
  /// One for the app's life, so the ad SDK starts once. A test build can show
  /// the form as in the EEA from anywhere: `--dart-define=UMP_DEBUG_EEA=true`
  /// with the device's id from the UMP log as `UMP_TEST_DEVICE_ID`.
  ConsentProvider._()
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
  String debugGetCreateSourceHash() => _$consentHash();

  @$internal
  @override
  $ProviderElement<Consent> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Consent create(Ref ref) {
    return consent(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Consent value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Consent>(value),
    );
  }
}

String _$consentHash() => r'a2db4a5b87d2c373bdd0fca151086a9c89ec5d5d';

/// One for the app's life, kept loaded between runs.

@ProviderFor(interstitialAds)
final interstitialAdsProvider = InterstitialAdsProvider._();

/// One for the app's life, kept loaded between runs.

final class InterstitialAdsProvider
    extends
        $FunctionalProvider<InterstitialAds, InterstitialAds, InterstitialAds>
    with $Provider<InterstitialAds> {
  /// One for the app's life, kept loaded between runs.
  InterstitialAdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'interstitialAdsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$interstitialAdsHash();

  @$internal
  @override
  $ProviderElement<InterstitialAds> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  InterstitialAds create(Ref ref) {
    return interstitialAds(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InterstitialAds value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InterstitialAds>(value),
    );
  }
}

String _$interstitialAdsHash() => r'7c3a2d0dd019e47faf78a77d45736aa7063498a7';

/// One for the app's life, kept loaded for the next revive.

@ProviderFor(rewardedAds)
final rewardedAdsProvider = RewardedAdsProvider._();

/// One for the app's life, kept loaded for the next revive.

final class RewardedAdsProvider
    extends $FunctionalProvider<RewardedAds, RewardedAds, RewardedAds>
    with $Provider<RewardedAds> {
  /// One for the app's life, kept loaded for the next revive.
  RewardedAdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rewardedAdsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rewardedAdsHash();

  @$internal
  @override
  $ProviderElement<RewardedAds> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RewardedAds create(Ref ref) {
    return rewardedAds(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RewardedAds value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RewardedAds>(value),
    );
  }
}

String _$rewardedAdsHash() => r'3af76dc0440fd755afacce8b75942caabf42f0db';

/// Where every feature's events go: Firebase, and in a test build the
/// testers' on-device log too.

@ProviderFor(analyticsSink)
final analyticsSinkProvider = AnalyticsSinkProvider._();

/// Where every feature's events go: Firebase, and in a test build the
/// testers' on-device log too.

final class AnalyticsSinkProvider
    extends $FunctionalProvider<AnalyticsSink, AnalyticsSink, AnalyticsSink>
    with $Provider<AnalyticsSink> {
  /// Where every feature's events go: Firebase, and in a test build the
  /// testers' on-device log too.
  AnalyticsSinkProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsSinkProvider',
        isAutoDispose: false,
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

String _$analyticsSinkHash() => r'f4e94f8c43c83654c1d53023156f5eace57335aa';

/// One for the app's life, listening to the stores from launch so no
/// purchase is missed.

@ProviderFor(purchases)
final purchasesProvider = PurchasesProvider._();

/// One for the app's life, listening to the stores from launch so no
/// purchase is missed.

final class PurchasesProvider
    extends $FunctionalProvider<Purchases, Purchases, Purchases>
    with $Provider<Purchases> {
  /// One for the app's life, listening to the stores from launch so no
  /// purchase is missed.
  PurchasesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'purchasesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$purchasesHash();

  @$internal
  @override
  $ProviderElement<Purchases> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Purchases create(Ref ref) {
    return purchases(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Purchases value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Purchases>(value),
    );
  }
}

String _$purchasesHash() => r'582bc6336c51c6cddfda440516e6be020389cf27';

/// One for the app's life. None on a platform whose ids are still
/// placeholders: Game Center would ask a player to sign in for boards that
/// don't exist, and Play Games has no project to sign in to.

@ProviderFor(leaderboards)
final leaderboardsProvider = LeaderboardsProvider._();

/// One for the app's life. None on a platform whose ids are still
/// placeholders: Game Center would ask a player to sign in for boards that
/// don't exist, and Play Games has no project to sign in to.

final class LeaderboardsProvider
    extends $FunctionalProvider<Leaderboards, Leaderboards, Leaderboards>
    with $Provider<Leaderboards> {
  /// One for the app's life. None on a platform whose ids are still
  /// placeholders: Game Center would ask a player to sign in for boards that
  /// don't exist, and Play Games has no project to sign in to.
  LeaderboardsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'leaderboardsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$leaderboardsHash();

  @$internal
  @override
  $ProviderElement<Leaderboards> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Leaderboards create(Ref ref) {
    return leaderboards(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Leaderboards value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Leaderboards>(value),
    );
  }
}

String _$leaderboardsHash() => r'0de5276bf18ee46d2cc35357ac9c4b00e10ce8f9';

/// One for the app's life: the OS's rating prompt and the store page.

@ProviderFor(storeReview)
final storeReviewProvider = StoreReviewProvider._();

/// One for the app's life: the OS's rating prompt and the store page.

final class StoreReviewProvider
    extends $FunctionalProvider<StoreReview, StoreReview, StoreReview>
    with $Provider<StoreReview> {
  /// One for the app's life: the OS's rating prompt and the store page.
  StoreReviewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storeReviewProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storeReviewHash();

  @$internal
  @override
  $ProviderElement<StoreReview> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StoreReview create(Ref ref) {
    return storeReview(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StoreReview value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StoreReview>(value),
    );
  }
}

String _$storeReviewHash() => r'982c4fc268f8fca7bb0e2e904bf72349f3b2d03f';

/// One for the app's life: the daily reminder, a local notification.

@ProviderFor(dailyReminder)
final dailyReminderProvider = DailyReminderProvider._();

/// One for the app's life: the daily reminder, a local notification.

final class DailyReminderProvider
    extends $FunctionalProvider<DailyReminder, DailyReminder, DailyReminder>
    with $Provider<DailyReminder> {
  /// One for the app's life: the daily reminder, a local notification.
  DailyReminderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyReminderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyReminderHash();

  @$internal
  @override
  $ProviderElement<DailyReminder> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DailyReminder create(Ref ref) {
    return dailyReminder(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DailyReminder value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DailyReminder>(value),
    );
  }
}

String _$dailyReminderHash() => r'a729c44ea227a3fb3e9689c0986fda5ffa10125a';

/// One for the app's life: its sounds are loaded once, at launch.

@ProviderFor(gameSounds)
final gameSoundsProvider = GameSoundsProvider._();

/// One for the app's life: its sounds are loaded once, at launch.

final class GameSoundsProvider
    extends $FunctionalProvider<GameSounds, GameSounds, GameSounds>
    with $Provider<GameSounds> {
  /// One for the app's life: its sounds are loaded once, at launch.
  GameSoundsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameSoundsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameSoundsHash();

  @$internal
  @override
  $ProviderElement<GameSounds> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GameSounds create(Ref ref) {
    return gameSounds(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameSounds value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameSounds>(value),
    );
  }
}

String _$gameSoundsHash() => r'c35f0d8d6a659d469b30abe45014d2cbe6962b3b';

/// One for the app's life, so its writes stay in order. Its days are the
/// game's clock's.

@ProviderFor(playStats)
final playStatsProvider = PlayStatsProvider._();

/// One for the app's life, so its writes stay in order. Its days are the
/// game's clock's.

final class PlayStatsProvider
    extends $FunctionalProvider<LocalPlayStats, LocalPlayStats, LocalPlayStats>
    with $Provider<LocalPlayStats> {
  /// One for the app's life, so its writes stay in order. Its days are the
  /// game's clock's.
  PlayStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playStatsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playStatsHash();

  @$internal
  @override
  $ProviderElement<LocalPlayStats> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocalPlayStats create(Ref ref) {
    return playStats(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalPlayStats value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalPlayStats>(value),
    );
  }
}

String _$playStatsHash() => r'bfd028f255ae2f84003c617895f3db9a8a906fb7';

/// One for the app's life. A test build fetches every few minutes, so a value
/// published in the console reaches a tester's next run; a release build twice
/// a day, as Remote Config's quotas expect.

@ProviderFor(remoteValues)
final remoteValuesProvider = RemoteValuesProvider._();

/// One for the app's life. A test build fetches every few minutes, so a value
/// published in the console reaches a tester's next run; a release build twice
/// a day, as Remote Config's quotas expect.

final class RemoteValuesProvider
    extends $FunctionalProvider<RemoteValues, RemoteValues, RemoteValues>
    with $Provider<RemoteValues> {
  /// One for the app's life. A test build fetches every few minutes, so a value
  /// published in the console reaches a tester's next run; a release build twice
  /// a day, as Remote Config's quotas expect.
  RemoteValuesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remoteValuesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remoteValuesHash();

  @$internal
  @override
  $ProviderElement<RemoteValues> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RemoteValues create(Ref ref) {
    return remoteValues(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RemoteValues value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RemoteValues>(value),
    );
  }
}

String _$remoteValuesHash() => r'ab342150e1666424c2a6fdcc1101192d9fd741e3';

/// The launch's fetch, started at boot and kept: the update check waits for
/// it, briefly, before deciding.

@ProviderFor(remoteValuesFetched)
final remoteValuesFetchedProvider = RemoteValuesFetchedProvider._();

/// The launch's fetch, started at boot and kept: the update check waits for
/// it, briefly, before deciding.

final class RemoteValuesFetchedProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// The launch's fetch, started at boot and kept: the update check waits for
  /// it, briefly, before deciding.
  RemoteValuesFetchedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remoteValuesFetchedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remoteValuesFetchedHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return remoteValuesFetched(ref);
  }
}

String _$remoteValuesFetchedHash() =>
    r'ff6b71abd56498cac0306923798f52de5737b122';

/// Keeps the values current for the app's life: listening live once the
/// launch's fetch has settled (the web needs a fetch first), and fetching
/// again on every return to the app, which the minimum interval may answer
/// from what was already fetched.

@ProviderFor(remoteValuesKeptCurrent)
final remoteValuesKeptCurrentProvider = RemoteValuesKeptCurrentProvider._();

/// Keeps the values current for the app's life: listening live once the
/// launch's fetch has settled (the web needs a fetch first), and fetching
/// again on every return to the app, which the minimum interval may answer
/// from what was already fetched.

final class RemoteValuesKeptCurrentProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Keeps the values current for the app's life: listening live once the
  /// launch's fetch has settled (the web needs a fetch first), and fetching
  /// again on every return to the app, which the minimum interval may answer
  /// from what was already fetched.
  RemoteValuesKeptCurrentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remoteValuesKeptCurrentProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remoteValuesKeptCurrentHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return remoteValuesKeptCurrent(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$remoteValuesKeptCurrentHash() =>
    r'da4d20212d01885d0f9a7611c7454308387e45cf';

/// Counts every change of the values, so what reads them can recompute.

@ProviderFor(RemoteValuesRevision)
final remoteValuesRevisionProvider = RemoteValuesRevisionProvider._();

/// Counts every change of the values, so what reads them can recompute.
final class RemoteValuesRevisionProvider
    extends $NotifierProvider<RemoteValuesRevision, int> {
  /// Counts every change of the values, so what reads them can recompute.
  RemoteValuesRevisionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remoteValuesRevisionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remoteValuesRevisionHash();

  @$internal
  @override
  RemoteValuesRevision create() => RemoteValuesRevision();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$remoteValuesRevisionHash() =>
    r'dd4eafb9462b30da0a5fac0aa12471fbf09bd9dc';

/// Counts every change of the values, so what reads them can recompute.

abstract class _$RemoteValuesRevision extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// The values as they stand: a new function at every change, so whatever
/// watches it recomputes. A run on screen never watches it, so it keeps the
/// values it started with.

@ProviderFor(liveRemoteValue)
final liveRemoteValueProvider = LiveRemoteValueProvider._();

/// The values as they stand: a new function at every change, so whatever
/// watches it recomputes. A run on screen never watches it, so it keeps the
/// values it started with.

final class LiveRemoteValueProvider
    extends
        $FunctionalProvider<
          String? Function(String key),
          String? Function(String key),
          String? Function(String key)
        >
    with $Provider<String? Function(String key)> {
  /// The values as they stand: a new function at every change, so whatever
  /// watches it recomputes. A run on screen never watches it, so it keeps the
  /// values it started with.
  LiveRemoteValueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'liveRemoteValueProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$liveRemoteValueHash();

  @$internal
  @override
  $ProviderElement<String? Function(String key)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  String? Function(String key) create(Ref ref) {
    return liveRemoteValue(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? Function(String key) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String? Function(String key)>(value),
    );
  }
}

String _$liveRemoteValueHash() => r'a1fb93cbdb7f4ddf073b34a0d0a2965bde3eddf6';

/// Whether this is a test build: `TEST_TOOLS`, the app's to say.

@ProviderFor(testTools)
final testToolsProvider = TestToolsProvider._();

/// Whether this is a test build: `TEST_TOOLS`, the app's to say.

final class TestToolsProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether this is a test build: `TEST_TOOLS`, the app's to say.
  TestToolsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'testToolsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$testToolsHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return testTools(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$testToolsHash() => r'a7ebc1fc60064bcd31f69ad1aa8bae7a2c38e29d';
