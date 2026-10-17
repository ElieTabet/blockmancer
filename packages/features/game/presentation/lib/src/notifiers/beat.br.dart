import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_domain/shared_domain.dart';

part 'beat.br.freezed.dart';

/// A cleared cell as it stood before the clear emptied it, so its burst wears
/// its colour.
typedef ClearedCell = ({Cell cell, CellState state});

enum Shake { light, none, strong }

/// One step of a move played back, held for its duration before the next.
/// Built from the move's events by `beatsFor`: every value is the engine's.
@freezed
sealed class Beat with _$Beat {
  /// The cleared cells flash, then burst.
  const factory Beat.clearing({
    required List<ClearedCell> cells,
    required Duration duration,
    required Shake shake,
  }) = ClearingBeat;

  const factory Beat.combo({required Duration duration, required int streak}) =
      ComboBeat;

  const factory Beat.countingChips({
    required int chips,
    required Duration duration,
  }) = CountingChipsBeat;

  const factory Beat.countingMult({
    required Duration duration,
    required int mult,
  }) = CountingMultBeat;

  /// A joker that fired, in the order the engine applied it.
  const factory Beat.jokerPulse({
    required JokerDelta delta,
    required Duration duration,
    required JokerId joker,
  }) = JokerPulseBeat;

  /// The move's points fly into the round score, which counts up to [score]
  /// over [countUp] — past the beat, which only holds the queue.
  const factory Beat.landing({
    required Duration countUp,
    required Duration duration,
    required int score,
    required Shake shake,
  }) = LandingBeat;

  /// The piece squashes into [cells]. The board already shows the move done,
  /// so the cells about to clear are drawn standing over it.
  const factory Beat.placing({
    required List<Cell> cells,
    required List<ClearedCell> clearing,
    required int colorIndex,
    required Duration duration,
    required Shake shake,
  }) = PlacingBeat;

  /// A move that cleared nothing: its [points], shown for a moment past the
  /// playback. It holds nothing, so a quick player is never kept waiting.
  const factory Beat.points({required Duration duration, required int points}) =
      PointsBeat;

  /// `chips × mult` appears, with the move's flat [bonus].
  const factory Beat.product({
    required int bonus,
    required Duration duration,
    required int lineScore,
  }) = ProductBeat;
}
