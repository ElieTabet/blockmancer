import 'package:blockmancer_engine/src/bot/greedy_policy.dart';
import 'package:blockmancer_engine/src/run/default_config.dart';
import 'package:blockmancer_engine/src/run/engine.dart';
import 'package:blockmancer_engine/src/run/replay.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

typedef _Placement = ({Board board, PiecePlaced placed});

/// The pieces the bot set down in the run of [seed] under [config], split
/// into the rounds before the boss and the boss itself, each with the board
/// it was dropped on.
({List<_Placement> beforeBoss, List<_Placement> boss}) _placements(
  RunConfig config,
  int seed,
) {
  const build = [JokerId.patience, JokerId.twin];
  final beforeBoss = <_Placement>[];
  final boss = <_Placement>[];
  var state = startRun(config: config, seed: seed);

  for (
    var move = greedyMove(state, build: build);
    move != null;
    move = greedyMove(state, build: build)
  ) {
    final (next, events) = applyMove(state, move);

    for (final placed in events.whereType<PiecePlaced>()) {
      (state.round.isBoss ? boss : beforeBoss).add((
        board: state.board,
        placed: placed,
      ));
    }

    state = next;
  }

  return (beforeBoss: beforeBoss, boss: boss);
}

/// Whether [placed] lies on the floor, a filled cell or a stone of [board]:
/// one row lower, some cell of it would leave the board or overlap.
bool _rests(_Placement placement) => placement.placed.cells.any((cell) {
  final below = Cell(col: cell.col, row: cell.row + 1);

  return !placement.board.contains(below) ||
      placement.board.at(below) is! EmptyCell;
});

List<String> _log(List<_Placement> placements) => [
  for (final (board: _, :placed) in placements)
    '${placed.shapeId}@${placed.anchor}',
];

void main() {
  // Seed 2 reaches the boss in both worlds.
  const seed = 2;

  test('the same seed plays the same rounds before the boss in Rubble and '
      'Gravity, then a different boss', () {
    // Given / When
    final rubble = _placements(defaultConfig, seed);
    final gravity = _placements(gravityConfig, seed);

    // Then
    expect(rubble.boss, isNotEmpty);
    expect(gravity.boss, isNotEmpty);
    expect(_log(gravity.beforeBoss), _log(rubble.beforeBoss));
    expect(_log(gravity.boss), isNot(_log(rubble.boss)));
  });

  test('in Gravity\'s boss, every piece the bot places comes to rest on the '
      'floor, a filled cell or a stone', () {
    // Given / When
    final boss = [
      for (var seed = 1; seed <= 20; seed++)
        ..._placements(gravityConfig, seed).boss,
    ];

    // Then
    expect(boss, isNotEmpty);
    expect(boss.where((placement) => !_rests(placement)), isEmpty);
  });

  test('in Rubble\'s boss, where nothing falls, the bot leaves pieces '
      'hanging', () {
    // Given / When
    final boss = [
      for (var seed = 1; seed <= 20; seed++)
        ..._placements(defaultConfig, seed).boss,
    ];

    // Then
    expect(boss.where((placement) => !_rests(placement)), isNotEmpty);
  });

  test('Rubble\'s boss starts with 6 more stones than Gravity\'s, whose '
      'only stones are the jokers\'', () {
    // Given / When
    final rubble = _placements(defaultConfig, seed).boss.first.board;
    final gravity = _placements(gravityConfig, seed).boss.first.board;

    // Then
    int stones(Board board) => [
      for (var row = 0; row < Board.size; row++)
        for (var col = 0; col < Board.size; col++)
          if (board.at(Cell(col: col, row: row)) is StoneCell) 1,
    ].length;

    expect(stones(rubble) - stones(gravity), defaultConfig.rounds.last.stones);
  });
}
