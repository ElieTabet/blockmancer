import 'package:blockmancer_engine/src/run/engine.dart';
import 'package:blockmancer_engine/src/worlds/world_rule.dart';
import 'package:blockmancer_engine/src/worlds/world_rules.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

import '../board_picture.dart';
import '../brief_config.dart';

/// Lands every piece one column right of where it is dropped, when it fits
/// there, and remembers every tray it is told about.
final class _FakeRule extends WorldRule {
  _FakeRule({this.losesOnTray = false});

  final bool losesOnTray;
  final trays = <bool>[];

  @override
  bool get bossOnly => false;

  @override
  Transition onTrayDealt(Transition transition, {required bool firstOfRound}) {
    trays.add(firstOfRound);

    if (!losesOnTray) return transition;

    final (state, events) = transition;

    return (
      state.copyWith(phase: const .roundLost(reason: .noRoom)),
      [...events, const .roundLost(reason: .noRoom)],
    );
  }

  @override
  List<Cell>? transformPlacement({
    required Board board,
    required List<Cell> cells,
  }) => super.transformPlacement(
    board: board,
    cells: [for (final cell in cells) Cell(col: cell.col + 1, row: cell.row)],
  );
}

/// A run of [config] in its first round, started with Twin Lines.
RunState _playing([RunConfig config = briefConfig]) {
  final start = startRun(config: config, seed: 20261016);

  return pickJoker(
    start.copyWith(phase: const .pickingJoker(offers: [.twin])),
    id: .twin,
  ).$1;
}

void main() {
  tearDown(() => worldRuleLookup = worldRule);

  test('a preview reads the same whether a fog cell hides a stone or not', () {
    // Given: the same board, its fog hiding a stone or nothing
    final playing = _playing().copyWith(tray: [9, null, null]);
    final hiding = playing.copyWith(board: boardFrom(['.H......', 'F.......']));
    final bare = playing.copyWith(board: boardFrom(['.F......', 'F.......']));

    // When / Then: over the fog, beside it and clear of it
    for (final anchor in const [
      Cell(col: 0, row: 0),
      Cell(col: 1, row: 1),
      Cell(col: 4, row: 4),
    ]) {
      expect(
        preview(hiding, anchor: anchor, trayIndex: 0),
        preview(bare, anchor: anchor, trayIndex: 0),
      );
    }
  });

  group('a world rule that moves where a piece lands', () {
    setUp(() => worldRuleLookup = (_) => _FakeRule());

    test('places, previews and checks fits where the piece lands', () {
      // Given: a single dropped in the top-left corner
      final state = _playing().copyWith(tray: [0, 0, 0]);

      // When
      final shown = preview(state, anchor: topLeft, trayIndex: 0);
      final (_, events) = place(state, anchor: topLeft, trayIndex: 0);

      // Then
      const landing = Cell(col: 1, row: 0);
      expect(shown.cells, [landing]);
      expect(
        events.whereType<PiecePlaced>().single,
        const GameEvent.piecePlaced(
          anchor: landing,
          cells: [landing],
          shapeId: 0,
          trayIndex: 0,
        ),
      );
      expect(
        canPlace(state, anchor: const Cell(col: 7, row: 0), trayIndex: 0),
        isFalse,
      );
    });
  });

  group('a world rule told about every tray', () {
    test('hears of the round\'s first tray, then of each later one', () {
      // Given
      final rule = _FakeRule();
      worldRuleLookup = (_) => rule;
      var state = _playing();

      // When: the three singles of the first tray are played
      for (var slot = 0; slot < 3; slot++) {
        state = place(
          state.copyWith(tray: [...state.tray]..[slot] = 0),
          anchor: Cell(col: slot, row: 0),
          trayIndex: slot,
        ).$1;
      }

      // Then
      expect(rule.trays, [true, false]);
      expect(state.trayDealt, 3);
    });

    test('can lose the round before the tray is dealt, and it stays lost', () {
      // Given
      worldRuleLookup = (_) => _FakeRule(losesOnTray: true);

      // When
      final state = _playing();

      // Then
      expect(state.phase, const RunPhase.roundLost(reason: .noRoom));
      expect(state.tray, everyElement(isNull));
    });
  });
}

const topLeft = Cell(col: 0, row: 0);
