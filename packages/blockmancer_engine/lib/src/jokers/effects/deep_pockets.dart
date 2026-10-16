import 'package:blockmancer_engine/src/jokers/joker_effect.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';
import 'package:blockmancer_engine/src/jokers/joker_id.dart';

/// +4 pieces every round.
final class DeepPockets extends JokerEffect {
  const DeepPockets();

  static const _extraPieces = 4;

  @override
  JokerId get id => .pockets;

  @override
  JokerId get partner => .saver;

  @override
  RoundSetup onRoundSetup(RoundSetup setup) =>
      setup.addPieces(id, _extraPieces);
}
