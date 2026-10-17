import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_domain/src/entities/game/joker_id.dart';
import 'package:shared_domain/src/entities/game/joker_tuning.br.dart';
import 'package:shared_domain/src/entities/game/world_id.dart';

part 'world_summary.br.freezed.dart';

/// What the map shows of one world before it is played, read from the rules.
@freezed
abstract class WorldSummary with _$WorldSummary {
  const factory WorldSummary({
    /// The points its boss round asks for; 0 for a world that isn't
    /// [playable].
    required int bossTarget,
    required WorldId id,

    /// The numbers [unlocks] play with, for describing them.
    required JokerTuning jokerTuning,

    /// Whether it has its rules yet; the others are "coming soon".
    required bool playable,

    /// The run total that earns its third star; 0 for a world that isn't
    /// [playable].
    required int starThreshold,

    /// The jokers beating its boss unlocks.
    required List<JokerId> unlocks,
  }) = _WorldSummary;
}
