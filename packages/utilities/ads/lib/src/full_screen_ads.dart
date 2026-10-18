import 'package:shared_domain/shared_domain.dart';

/// A rewarded ad kept loaded, so a revive never waits on the network.
abstract interface class RewardedAds {
  /// Whether one is loaded and would show now.
  bool get isReady;

  /// [isReady] as it changes.
  Stream<bool> get readiness;

  /// Loads one if none is loaded or loading. Idempotent.
  void preload();

  /// Shows the loaded ad and says what came of it; the next one loads
  /// straight after. Never throws.
  Future<AdResult> show();
}

/// An interstitial kept loaded, so a run's end never waits on the network.
abstract interface class InterstitialAds {
  void preload();

  /// Never throws.
  Future<AdResult> show();
}

/// No ads: tests, and a build that may not request any.
final class NoAds implements InterstitialAds, RewardedAds {
  const NoAds();

  @override
  bool get isReady => false;

  @override
  Stream<bool> get readiness => Stream.value(false);

  @override
  void preload() {}

  @override
  Future<AdResult> show() async => const .failed(code: 'no_ads');
}
