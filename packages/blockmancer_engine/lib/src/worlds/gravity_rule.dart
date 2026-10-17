import 'package:blockmancer_engine/src/board/placement.br.dart';
import 'package:blockmancer_engine/src/worlds/world_rule.dart';
import 'package:shared_domain/shared_domain.dart';

/// In the boss, a piece falls straight down from where it is dropped, as one
/// rigid shape, until one more row would leave the board or hit a filled cell
/// or a stone. A drop point it doesn't fit at is not a placement.
final class GravityRule extends WorldRule {
  const GravityRule();

  static const _oneRowDown = Cell(col: 0, row: 1);

  @override
  bool get bossOnly => true;

  @override
  Cell? transformAnchor({
    required Cell anchor,
    required Board board,
    required Shape shape,
  }) {
    if (!fits(board, shape, anchor: anchor)) return null;

    var landing = anchor;

    while (fits(board, shape, anchor: landing + _oneRowDown)) {
      landing += _oneRowDown;
    }

    return landing;
  }
}
