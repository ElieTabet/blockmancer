import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/game_presentation.dart';
import 'package:game_presentation/src/notifiers/playback_notifier.br.dart';
import 'package:game_presentation/src/painting/board_geometry.dart';
import 'package:game_presentation/src/widgets/board_view.dart';
import 'package:game_presentation/src/widgets/input_gate.dart';
import 'package:game_presentation/src/widgets/tray_view.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_game_rules.dart';
import '../game_overrides.dart';
import '../pump_game.dart';

void main() {
  // Played back in 1.3 s.
  const clear = <GameEvent>[
    GameEvent.linesCleared(cells: [Cell(col: 7, row: 0)], cols: [], rows: [0]),
    GameEvent.scoreAdded(
      bonusPoints: 0,
      chips: 80,
      lineScore: 80,
      mult: 1,
      piecePoints: 1,
      total: 81,
    ),
  ];

  ProviderContainer containerOf(WidgetTester tester) =>
      ProviderScope.containerOf(tester.element(find.byType(InputGate)));

  Future<void> playMove(WidgetTester tester, FakeGameRules rules) async {
    rules.next = (runIn(const .playing(), score: 81), clear);
    final board = tester.getRect(find.byType(BoardView));
    final target =
        board.topLeft +
        BoardGeometry(board.width).cellRect(const Cell(col: 7, row: 0)).center +
        const Offset(0, 60);
    final slot = tester.getCenter(find.byType(TraySlot).first);
    await tester.dragFrom(slot, target - slot);
    await tester.pump();
  }

  testWidgets('the game settles only once its move has played back and its '
      'save has landed', (tester) async {
    // Given
    final store = FakeRunStore()..gate = Completer<void>();
    final rules = await pumpGame(
      tester,
      runIn(const .playing()),
      runStore: store,
    );
    await playMove(tester, rules);
    final container = containerOf(tester);
    var settled = false;

    // When
    unawaited(
      container.read(whenGameSettledProvider)().then((_) => settled = true),
    );
    await tester.pump(const Duration(milliseconds: 200));

    // Then: still playing
    expect(settled, isFalse);

    await tester.pump(const Duration(milliseconds: 1400));
    expect(container.read(playbackProvider).isPlaying, isFalse);
    expect(settled, isFalse, reason: 'the save is still open');

    store.gate!.complete();
    await tester.pump();
    expect(store.saved, isNotNull);
    expect(settled, isTrue);
  });

  testWidgets('with no move under way, the game is settled at once', (
    tester,
  ) async {
    // Given
    await pumpGame(tester, runIn(const .playing()));
    var settled = false;

    // When
    unawaited(
      containerOf(
        tester,
      ).read(whenGameSettledProvider)().then((_) => settled = true),
    );
    await tester.pump();

    // Then
    expect(settled, isTrue);
  });

  test('with no game on screen, the game is settled at once', () async {
    // Given
    final container = ProviderContainer();
    addTearDown(container.dispose);

    // When / Then
    await expectLater(container.read(whenGameSettledProvider)(), completes);
  });
}
