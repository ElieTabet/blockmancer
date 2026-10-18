import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// ×[JokerTuning.twinFactor] mult when [JokerTuning.twinMinLines] or more
/// lines clear at once.
final class TwinLines extends JokerEffect {
  const TwinLines();

  @override
  JokerId get id => .twin;

  @override
  JokerKind get kind => .multiplicativeMult;

  @override
  JokerId get partner => .patience;

  @override
  ScoreStep onMultiplicative(MoveContext move, ScoreStep step) =>
      move.clear.lineCount >= move.tuning.twinMinLines
      ? step.multiplyMult(move.tuning.twinFactor, id)
      : step;
}
