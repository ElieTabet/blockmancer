import 'package:blockmancer_engine/src/board/placement.br.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';
import 'package:shared_domain/shared_domain.dart';

/// A world's twist on the rules. Every hook defaults to the plain rules, so a
/// world overrides only what it changes.
abstract class WorldRule {
  const WorldRule();

  /// Whether the rule holds in the boss round only; the other rounds play by
  /// the plain rules.
  bool get bossOnly;

  /// How a round the rule holds in starts, before the jokers add to it.
  RoundSetup onRoundSetup(RoundSetup setup, RoundSpec round) => setup;

  /// Where a piece dropped at [anchor] lands, or null when it can't be placed
  /// from there. Fits, previews and the round's "no room" all ask this, so
  /// they agree with where [anchor] really puts the piece.
  Cell? transformAnchor({
    required Cell anchor,
    required Board board,
    required Shape shape,
  }) => fits(board, shape, anchor: anchor) ? anchor : null;
}
