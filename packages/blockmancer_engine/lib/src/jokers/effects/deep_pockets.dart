import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';

/// +[JokerTuning.pocketsExtraPieces] pieces every round.
final class DeepPockets extends JokerEffect {
  const DeepPockets();

  @override
  JokerId get id => .pockets;

  @override
  JokerKind get kind => .boardEffect;

  @override
  JokerId get partner => .saver;

  @override
  RoundSetup onRoundSetup(RoundSetup setup, JokerTuning tuning) =>
      setup.addPieces(tuning.pocketsExtraPieces, id);
}
