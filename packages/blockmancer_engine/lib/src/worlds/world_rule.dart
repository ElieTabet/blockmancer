import 'package:blockmancer_engine/src/board/placement.br.dart';
import 'package:blockmancer_engine/src/jokers/joker_hooks.dart';
import 'package:blockmancer_engine/src/random/mulberry32.dart';
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

  /// The board a round the rule holds in starts on, once its stones are down,
  /// drawing from the stones stream [stonesRng]; with the events that say
  /// what it added.
  (Board, Mulberry32, List<GameEvent>) onBoardSetup(
    Board board,
    RoundSpec round,
    Mulberry32 stonesRng,
  ) => (board, stonesRng, const []);

  /// The board once a piece that filled [placed] has scored, cleared and had
  /// the jokers' say; with the events that say what changed.
  (Board, List<GameEvent>) afterPlacement({
    required Board board,
    required List<Cell> placed,
  }) => (board, const []);

  /// The run a new tray is about to be dealt into; [firstOfRound] for the
  /// round's first tray. A run it leaves lost is dealt nothing.
  Transition onTrayDealt(Transition transition, {required bool firstOfRound}) =>
      transition;

  /// Where a piece the player dropped on [cells] really lands, or null when it
  /// can't be placed from there. Fits, previews and the round's "no room" all
  /// ask this, so they agree with where the piece goes.
  List<Cell>? transformPlacement({
    required Board board,
    required List<Cell> cells,
  }) => cellsFit(board, cells) ? cells : null;

  /// Where the preview shows a piece dropped on [cells] going, whether it fits
  /// or not: where it lands, else where it was dropped.
  List<Cell> previewPlacement({
    required Board board,
    required List<Cell> cells,
  }) => transformPlacement(board: board, cells: cells) ?? cells;

  /// Where [shape] dropped at [anchor] lands, as the top-left of what it
  /// fills, or null when it can't be placed from there.
  Cell? transformAnchor({
    required Cell anchor,
    required Board board,
    required Shape shape,
  }) {
    final landing = transformPlacement(
      board: board,
      cells: [for (final offset in shape.cells) anchor + offset],
    );

    return landing == null ? null : topLeftOf(landing);
  }
}
