import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_domain/src/entities/ads/ad_result.br.dart';
import 'package:shared_domain/src/entities/game/joker_id.dart';
import 'package:shared_domain/src/entities/game/world_id.dart';

part 'analytics_event.br.freezed.dart';

/// The kind of run a `runStart` names.
enum RunKind { daily, practice, world }

/// Something a player did that the testers' numbers, and later Firebase
/// Analytics, count. Each sink maps the cases to its own wire format.
@freezed
sealed class AnalyticsEvent with _$AnalyticsEvent {
  /// An ad of [kind] didn't show, for the reason [code].
  const factory AnalyticsEvent.adFailed({
    required String code,
    required AdKind kind,
  }) = AdFailedEvent;

  /// A rewarded ad watched to its reward.
  const factory AnalyticsEvent.adRewardEarned() = AdRewardEarnedEvent;

  const factory AnalyticsEvent.adShown({required AdKind kind}) = AdShownEvent;

  /// A joker taken, from the [offered] three.
  const factory AnalyticsEvent.jokerPick({
    required JokerId id,
    required List<JokerId> offered,
  }) = JokerPickEvent;

  const factory AnalyticsEvent.revive() = ReviveEvent;

  /// Round [round], from 1, ended: won, or lost and given up.
  const factory AnalyticsEvent.roundEnd({
    required int round,
    required int score,
    required bool won,
  }) = RoundEndEvent;

  const factory AnalyticsEvent.runEnd({
    /// The stars the run earned that its world hadn't awarded; 0 outside a
    /// world run.
    required int starsEarned,
    required int total,
    required bool won,
  }) = RunEndEvent;

  const factory AnalyticsEvent.runStart({
    required RunKind mode,
    required WorldId world,
  }) = RunStartEvent;

  const factory AnalyticsEvent.worldUnlock({required WorldId world}) =
      WorldUnlockEvent;
}
