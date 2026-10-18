import 'package:freezed_annotation/freezed_annotation.dart';

part 'ad_result.br.freezed.dart';

/// The two ads the game shows.
enum AdKind { interstitial, rewarded }

/// What asking for an ad came to.
@freezed
sealed class AdResult with _$AdResult {
  /// Shown and closed: an interstitial's end, or a rewarded ad left before
  /// its reward.
  const factory AdResult.closed() = AdClosed;

  /// A rewarded ad watched to its reward.
  const factory AdResult.earned() = AdEarned;

  /// Not shown: none was loaded, or the network said why ([code]).
  const factory AdResult.failed({required String code}) = AdFailed;
}
