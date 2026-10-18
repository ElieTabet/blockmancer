import 'dart:async';
import 'dart:math';

import 'package:ads/src/full_screen_ads.dart';
import 'package:ads/src/package_name.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:timber/timber.dart';

/// Google's own test units, which every build but a release plays: tapping
/// one earns nothing and breaks no AdMob rule.
abstract final class TestAdUnits {
  static const interstitialAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static const interstitialIos = 'ca-app-pub-3940256099942544/4411468910';
  static const rewardedAndroid = 'ca-app-pub-3940256099942544/5224354917';
  static const rewardedIos = 'ca-app-pub-3940256099942544/1712485313';
}

/// What loading and showing share: waiting for consent, retrying a failed
/// load later and later, and the next ad loading as soon as one is shown.
abstract base class _KeptLoaded<T extends AdWithoutView> {
  _KeptLoaded({
    required Future<bool> Function() adsAllowed,
    required this.unitId,
  }) : _adsAllowed = adsAllowed;

  static const _firstRetry = Duration(seconds: 30);
  static const _lastRetry = Duration(minutes: 5);

  T? _ad;
  final Future<bool> Function() _adsAllowed;
  var _failures = 0;
  String? _lastError;
  var _loading = false;
  final _readiness = StreamController<bool>.broadcast();
  Timer? _retry;
  final String unitId;

  AdKind get kind;

  bool get isReady => _ad != null;

  Stream<bool> get readiness async* {
    yield isReady;
    yield* _readiness.stream;
  }

  void preload() {
    if (_ad != null || _loading) return;

    _loading = true;
    unawaited(_load());
  }

  void _loaded(T ad) {
    _ad = ad;
    _failures = 0;
    _loading = false;
    _readiness.add(true);
  }

  void _failed(LoadAdError error) {
    _loading = false;
    _lastError = '${error.code}';
    _failures++;
    Timber.e(
      tag: packageName,
      logMessage:
          'Loading the ${kind.name} ad failed: ${error.code} ${error.message}',
    );

    final delay = Duration(
      seconds: min(
        _lastRetry.inSeconds,
        _firstRetry.inSeconds * pow(2, _failures - 1).toInt(),
      ),
    );
    _retry?.cancel();
    _retry = Timer(delay, preload);
  }

  Future<void> _load() async {
    if (!await _adsAllowed()) {
      _loading = false;

      return;
    }

    try {
      request(onFailed: _failed, onLoaded: _loaded);
    } catch (error, stackTrace) {
      _loading = false;
      Timber.e(
        tag: packageName,
        logMessage: 'Requesting the ${kind.name} ad failed',
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }

  void request({
    required void Function(LoadAdError error) onFailed,
    required void Function(T ad) onLoaded,
  });

  /// Hears [ad]'s full-screen life: each ad type has its own setter.
  void listen(T ad, FullScreenContentCallback<T> callback);

  /// Shows the loaded ad until it is closed; [earned] says whether it earned
  /// its reward.
  Future<AdResult> showLoaded(
    void Function(T ad, void Function() onEarned) present,
  ) {
    final ad = _ad;

    if (ad == null) {
      preload();

      return Future.value(.failed(code: _lastError ?? 'not_loaded'));
    }

    _ad = null;
    _readiness.add(false);

    final result = Completer<AdResult>();
    var earned = false;

    listen(
      ad,
      FullScreenContentCallback<T>(
        onAdDismissedFullScreenContent: (shown) {
          shown.dispose();
          result.complete(earned ? const .earned() : const .closed());
          preload();
        },
        onAdFailedToShowFullScreenContent: (shown, error) {
          shown.dispose();
          result.complete(.failed(code: '${error.code}'));
          preload();
        },
      ),
    );

    try {
      present(ad, () => earned = true);
    } catch (error, stackTrace) {
      Timber.e(
        tag: packageName,
        logMessage: 'Showing the ${kind.name} ad failed',
        exception: error,
        stackTrace: stackTrace,
      );
      if (!result.isCompleted) result.complete(const .failed(code: 'show'));
      preload();
    }

    return result.future;
  }
}

/// [RewardedAds] over AdMob, from the unit [unitId].
final class AdMobRewardedAds extends _KeptLoaded<RewardedAd>
    implements RewardedAds {
  AdMobRewardedAds({required super.adsAllowed, required super.unitId});

  @override
  AdKind get kind => .rewarded;

  @override
  void listen(RewardedAd ad, FullScreenContentCallback<RewardedAd> callback) =>
      ad.fullScreenContentCallback = callback;

  @override
  void request({
    required void Function(LoadAdError error) onFailed,
    required void Function(RewardedAd ad) onLoaded,
  }) => RewardedAd.load(
    adUnitId: unitId,
    request: const AdRequest(),
    rewardedAdLoadCallback: RewardedAdLoadCallback(
      onAdFailedToLoad: onFailed,
      onAdLoaded: onLoaded,
    ),
  );

  @override
  Future<AdResult> show() => showLoaded(
    (ad, onEarned) => ad.show(onUserEarnedReward: (_, _) => onEarned()),
  );
}

/// [InterstitialAds] over AdMob, from the unit [unitId].
final class AdMobInterstitialAds extends _KeptLoaded<InterstitialAd>
    implements InterstitialAds {
  AdMobInterstitialAds({required super.adsAllowed, required super.unitId});

  @override
  AdKind get kind => .interstitial;

  @override
  void listen(
    InterstitialAd ad,
    FullScreenContentCallback<InterstitialAd> callback,
  ) => ad.fullScreenContentCallback = callback;

  @override
  void request({
    required void Function(LoadAdError error) onFailed,
    required void Function(InterstitialAd ad) onLoaded,
  }) => InterstitialAd.load(
    adUnitId: unitId,
    request: const AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdFailedToLoad: onFailed,
      onAdLoaded: onLoaded,
    ),
  );

  @override
  Future<AdResult> show() => showLoaded((ad, _) => ad.show());
}
