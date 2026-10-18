import 'package:freezed_annotation/freezed_annotation.dart';

part 'engagement.br.freezed.dart';

/// How much the app has been played on this device, for pacing what it asks
/// of the player: interstitials, and the rating prompt.
@freezed
abstract class Engagement with _$Engagement {
  const factory Engagement({
    /// Runs played to their end, won or not; the tutorial never counts.
    @Default(0) int completedRuns,

    /// Local days the app was opened on, the first included.
    @Default(0) int daysOpened,

    /// The local day (`yyyymmdd`) of the first launch; null until then.
    int? firstOpenedOn,
    DateTime? lastInterstitialAt,

    /// The local day (`yyyymmdd`) of the latest launch.
    int? lastOpenedOn,

    /// Run ends since the last interstitial showed.
    @Default(0) int runEndsSinceInterstitial,
  }) = _Engagement;
}
