import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_domain/src/entities/ads/ad_result.br.dart';
import 'package:shared_domain/src/entities/game/joker_id.dart';
import 'package:shared_domain/src/entities/game/world_id.dart';

part 'analytics_event.br.freezed.dart';

/// What paid for a revive: a rewarded ad watched, or Remove ads owned.
enum ReviveSource { ad, owned }

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

  /// Buying [product] reached the player's purchase: owned from now on.
  const factory AnalyticsEvent.purchaseCompleted({required String product}) =
      PurchaseCompletedEvent;

  /// Buying [product] didn't go through, for the reason [code] (`canceled`
  /// when the player backed out).
  const factory AnalyticsEvent.purchaseFailed({
    required String code,
    required String product,
  }) = PurchaseFailedEvent;

  /// [product] found again by a restore the player asked for.
  const factory AnalyticsEvent.purchaseRestored({required String product}) =
      PurchaseRestoredEvent;

  /// The player asked to buy [product].
  const factory AnalyticsEvent.purchaseStarted({required String product}) =
      PurchaseStartedEvent;

  /// The app asked the OS for its rating prompt; whether it showed is the
  /// OS's secret.
  const factory AnalyticsEvent.reviewPromptRequested() =
      ReviewPromptRequestedEvent;

  const factory AnalyticsEvent.revive({required ReviveSource source}) =
      ReviveEvent;

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
