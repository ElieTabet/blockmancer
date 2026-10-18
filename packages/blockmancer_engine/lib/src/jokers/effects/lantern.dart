import 'package:shared_domain/shared_domain.dart';
import 'package:blockmancer_engine/src/board/placement.br.dart';
import 'package:blockmancer_engine/src/jokers/joker_effect.dart';

/// Stones and fog beside a cleared line are taken off the board with it,
/// scoring no chips of their own.
final class Lantern extends JokerEffect {
  const Lantern();

  @override
  JokerId get id => .lantern;

  @override
  JokerKind get kind => .boardEffect;

  @override
  JokerId get partner => .ember;

  @override
  ClearResult extendClear(ClearResult clear) => clearObstaclesBeside(clear);
}
