import 'package:game_domain/src/entities/engagement.br.dart';
import 'package:game_domain/src/entities/interstitial_caps.dart';

/// Whether an interstitial may show as the player moves on from a run that
/// just ended, [engagement] already counting it. Never in the player's
/// [firstSession], never before [InterstitialCaps.minCompletedRuns] runs, at
/// most every [InterstitialCaps.everyNthRunEnd] run ends and at least
/// [InterstitialCaps.minGap] apart.
bool interstitialDue({
  required InterstitialCaps caps,
  required Engagement engagement,
  required bool firstSession,
  required DateTime now,
}) {
  final last = engagement.lastInterstitialAt;

  return !firstSession &&
      engagement.completedRuns >= caps.minCompletedRuns &&
      engagement.runEndsSinceInterstitial >= caps.everyNthRunEnd &&
      (last == null || now.difference(last) >= caps.minGap);
}
