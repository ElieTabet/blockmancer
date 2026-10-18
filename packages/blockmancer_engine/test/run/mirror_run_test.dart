import 'package:blockmancer_engine/src/run/default_config.dart';
import 'package:blockmancer_engine/src/run/engine.dart';
import 'package:shared_domain/shared_domain.dart';
import 'package:test/test.dart';

import '../board_picture.dart';

const _seed = 20261016;

/// The Mirror boss under way on [board], an L of shape 14 (catalog index 13:
/// a column of 3 with a foot to the right) in hand.
RunState _mirrorBoss(Board board) {
  final beforeBoss = startRun(
    config: mirrorConfig,
    seed: _seed,
  ).copyWith(phase: const .pickingJoker(offers: [.combo]), pickIndex: 4);

  return pickJoker(
    beforeBoss,
    id: .combo,
  ).$1.copyWith(board: board, tray: [13, null, null], trayDealt: 1);
}

const _corner = Cell(col: 0, row: 0);

/// The L dropped in the top-left corner, mirrored: its column on the right
/// edge and its foot turned to the left.
const _mirroredL = [
  Cell(col: 7, row: 0),
  Cell(col: 7, row: 1),
  Cell(col: 7, row: 2),
  Cell(col: 6, row: 2),
];

void main() {
  group('the Mirror boss', () {
    test('lands an asymmetric piece mirrored, in place and in shape', () {
      // Given
      final state = _mirrorBoss(Board.empty());

      // When
      final (next, events) = place(state, anchor: _corner, trayIndex: 0);

      // Then
      expect(events.whereType<PiecePlaced>().single.cells, _mirroredL);
      for (final cell in _mirroredL) {
        expect(next.board.at(cell), isA<FilledCell>());
      }
      expect(next.board.at(_corner), isA<EmptyCell>());
    });

    test('previews the landing cells, the ones the piece then fills', () {
      // Given
      final state = _mirrorBoss(Board.empty());

      // When
      final shown = preview(state, anchor: _corner, trayIndex: 0);

      // Then
      expect(shown.fits, isTrue);
      expect(shown.cells, _mirroredL);
    });

    test('refuses a drop whose cells are free under the finger but taken on '
        'the mirrored side', () {
      // Given: the top-left corner free, the right edge taken at row 1
      final state = _mirrorBoss(boardFrom(['........', '.......#']));

      // When / Then
      expect(canPlace(state, anchor: _corner, trayIndex: 0), isFalse);
    });

    test('marks the collision on the mirrored side', () {
      // Given
      final state = _mirrorBoss(boardFrom(['........', '.......#']));

      // When
      final shown = preview(state, anchor: _corner, trayIndex: 0);

      // Then
      expect(shown.fits, isFalse);
      expect(shown.colliding, const [Cell(col: 7, row: 1)]);
    });
  });
}
