import 'package:game_presentation/src/notifiers/beat.br.dart';
import 'package:shared_domain/shared_domain.dart';

const _chips = Duration(milliseconds: 250);
const _clear = Duration(milliseconds: 350);
const _combo = Duration(milliseconds: 300);

/// A streak this long or longer pops a combo over the board.
const _comboFrom = 3;

/// How long the round score and its bar take to reach a landed score.
const _countUp = Duration(milliseconds: 400);
const _land = Duration(milliseconds: 250);
const _mult = Duration(milliseconds: 200);
const _place = Duration(milliseconds: 120);
const _product = Duration(milliseconds: 250);
const _pulse = Duration(milliseconds: 180);
const _reveal = Duration(milliseconds: 260);

/// Every beat's length with reduce motion on: long enough to read the numbers
/// arrive in order, too short to be motion.
const _still = Duration(milliseconds: 100);

/// The beats that play a move back, in order: the piece landing, the lines
/// bursting (with what Lantern took beside them), the fog it lifted puffing
/// away, then the score counted up — chips, mult, each joker that fired
/// on the way, the product — and landing in the round score. Jokers that fire
/// once the score is in, such as a won round's bonus, pulse after it lands.
///
/// Every value is read from [events] and the runs either side of the move.
/// With [reduceMotion] the squash, the burst, the puff and the shakes are left
/// out and
/// the rest is brief, but the same numbers land in the same order.
List<Beat> beatsFor({
  required RunState after,
  required RunState before,
  required List<GameEvent> events,
  required bool reduceMotion,
  required GameRules rules,
}) {
  Duration paced(Duration lively) => reduceMotion ? _still : lively;

  List<Beat> pulsesIn(Iterable<GameEvent> span) => [
    for (final fired in span.whereType<JokerFired>())
      Beat.jokerPulse(
        delta: fired.delta,
        duration: paced(_pulse),
        joker: fired.joker,
      ),
  ];

  final placed = events.whereType<PiecePlaced>().firstOrNull;
  final cleared = events.whereType<LinesCleared>().firstOrNull;
  final scoredAt = events.indexWhere((event) => event is ScoreAdded);
  final score = scoredAt < 0 ? null : events[scoredAt] as ScoreAdded;
  final won = events.whereType<RoundWon>().firstOrNull;
  final colorIndex = placed == null
      ? 0
      : rules.shape(placed.shapeId).colorIndex;
  final bossBeaten = won != null && before.config.rounds[won.roundIndex].isBoss;
  final win = bossBeaten && !reduceMotion ? Shake.strong : Shake.none;
  final scoring = pulsesIn(events.take(scoredAt < 0 ? 0 : scoredAt));
  final afterwards = pulsesIn(events.skip(scoredAt + 1));
  final revealed = [
    for (final event in events.whereType<FogRevealed>()) event.cell,
  ];
  final revealing = [
    if (revealed.isNotEmpty && !reduceMotion)
      Beat.revealing(cells: revealed, duration: _reveal),
  ];

  if (cleared == null || score == null) {
    return [
      if (score != null) .points(duration: .zero, points: score.total),
      if (placed != null && !reduceMotion)
        .placing(
          cells: placed.cells,
          clearing: const [],
          colorIndex: colorIndex,
          duration: _place,
          shake: win,
        ),
      ...revealing,
      ...scoring,
      ...afterwards,
    ];
  }

  final clearing = [
    for (final cell in [
      ...cleared.cells,
      for (final fired in events.whereType<JokerFired>())
        if (fired.delta case ObstaclesRemoved(:final cells)) ...cells,
    ])
      (
        cell: cell,
        state: switch (before.board.at(cell)) {
          // Empty before the move: the piece just placed filled it.
          EmptyCell() => CellState.filled(colorIndex: colorIndex),
          final state => state,
        },
      ),
  ];
  final lines = cleared.rows.length + cleared.cols.length;

  return [
    if (placed != null && !reduceMotion)
      .placing(
        cells: placed.cells,
        clearing: clearing,
        colorIndex: colorIndex,
        duration: _place,
        shake: .none,
      ),
    if (!reduceMotion)
      .clearing(
        cells: clearing,
        duration: _clear,
        shake: lines >= 2 ? .light : .none,
      ),
    ...revealing,
    if (after.streak >= _comboFrom)
      .combo(duration: paced(_combo), streak: after.streak),
    .countingChips(chips: score.chips, duration: paced(_chips)),
    .countingMult(duration: paced(_mult), mult: score.mult),
    ...scoring,
    .product(
      bonus: score.bonusPoints,
      duration: paced(_product),
      lineScore: score.lineScore,
    ),
    .landing(
      countUp: paced(_countUp),
      duration: paced(_land),
      score: won?.score ?? after.score,
      shake: win,
    ),
    ...afterwards,
  ];
}
