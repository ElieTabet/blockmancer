import 'package:freezed_annotation/freezed_annotation.dart';

part 'joker_stats.br.freezed.dart';

/// How the player's runs went with one joker owned, counted when each run
/// ends: the tutorial aside, every mode counts.
@freezed
abstract class JokerStats with _$JokerStats {
  const factory JokerStats({
    /// The best run total of a run that owned it, boss beaten or not.
    required int bestRunTotal,

    /// Runs won, the boss beaten, with it owned.
    required int runsWon,

    /// Finished runs it was picked in.
    required int timesPicked,
  }) = _JokerStats;

  static const none = JokerStats(bestRunTotal: 0, runsWon: 0, timesPicked: 0);
}
