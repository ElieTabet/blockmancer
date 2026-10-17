/// Shows a rewarded ad and says whether its reward was earned.
///
/// There is no ad network yet (phase 3 brings one), so every reward is
/// granted: what it gates is free until then, and callers already wait on it.
final class RewardedAds {
  const RewardedAds();

  Future<bool> show() async => true;
}
