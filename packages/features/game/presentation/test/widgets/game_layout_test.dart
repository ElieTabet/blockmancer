import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/src/widgets/board_view.dart';
import 'package:game_presentation/src/widgets/game_header.dart';
import 'package:game_presentation/src/widgets/joker_chips.dart';
import 'package:game_presentation/src/widgets/phase_overlay.dart';
import 'package:game_presentation/src/widgets/tray_view.dart';
import 'package:game_presentation/src/widgets/tutorial_coach.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_game_rules.dart';
import '../pump_game.dart';

const _fiveJokers = [
  JokerId.twin,
  JokerId.patience,
  JokerId.combo,
  JokerId.collector,
  JokerId.saver,
];

void main() {
  testWidgets('the board keeps its size as the build grows', (tester) async {
    // Given
    await pumpGame(tester, runIn(const .playing(), jokers: const [.twin]));
    final withOne = tester.getSize(find.byType(BoardView)).width;

    // When
    await pumpGame(tester, runIn(const .playing(), jokers: _fiveJokers));

    // Then
    expect(tester.getSize(find.byType(BoardView)).width, withOne);
  });

  testWidgets('owned jokers sit side by side, each as wide as its name', (
    tester,
  ) async {
    // Given / When
    await pumpGame(tester, runIn(const .playing(), jokers: _fiveJokers));

    // Then
    final chips = tester.widgetList(find.byType(JokerChip)).toList();
    final first = tester.getRect(find.byWidget(chips[0]));
    final second = tester.getRect(find.byWidget(chips[1]));
    expect(second.top, first.top);
    expect(first.width, lessThan(390 / 2));
  });

  for (final (name, size) in const [
    ('a 4-inch iPhone', Size(320, 568)),
    ('a small Android phone', Size(360, 640)),
  ]) {
    testWidgets('on $name, the boss round with five jokers stays playable', (
      tester,
    ) async {
      // Given / When
      await pumpGame(
        tester,
        runIn(
          const .playing(),
          jokers: _fiveJokers,
          roundIndex: 1,
          score: 1840,
        ),
        size: size,
      );

      // Then
      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(BoardView)).width,
        greaterThanOrEqualTo(200),
      );
    });
  }

  testWidgets('on a small phone, a sheet taller than the screen stops below '
      'the back button and scrolls', (tester) async {
    // Given / When: three offers, owned jokers to pair them with
    await pumpGame(
      tester,
      runIn(
        const .pickingJoker(offers: [.twin, .combo, .heavy]),
        jokers: const [.patience, .collector, .bigbox],
      ),
      size: const Size(320, 568),
    );

    // Then
    final sheet = tester.getRect(
      find.descendant(
        of: find.byType(PhaseOverlay),
        matching: find.byType(SingleChildScrollView),
      ),
    );
    expect(
      sheet.top,
      greaterThanOrEqualTo(tester.getRect(find.byType(LeaveButton)).bottom),
    );
  });

  testWidgets('on a small phone, the tutorial\'s line sits above the joker '
      'pick, never over it', (tester) async {
    // Given: a tutorial skipped to its starting pick, the line still up
    await pumpGame(
      tester,
      runIn(const .pickingJoker(offers: [.twin, .combo, .saver]), pickIndex: 0),
      launch: .tutorial,
      size: const Size(320, 568),
    );

    // When
    await tester.tap(find.text('Skip'));
    await tester.pump(const Duration(seconds: 1));

    // Then
    final sheet = tester.getRect(
      find.descendant(
        of: find.byType(PhaseOverlay),
        matching: find.byType(SingleChildScrollView),
      ),
    );
    expect(find.text('Pick your starting joker'), findsOneWidget);
    expect(
      sheet.top,
      greaterThanOrEqualTo(tester.getRect(find.byType(TutorialCoach)).bottom),
    );
  });

  testWidgets(
    'on an Android phone with gesture navigation, a piece is grabbed above the swipe home zone',
    (tester) async {
      // Given
      tester.view.systemGestureInsets = const FakeViewPadding(bottom: 32 * 3);
      addTearDown(tester.view.resetSystemGestureInsets);

      // When
      await pumpGame(tester, runIn(const .playing()));

      // Then
      final tray = tester.getRect(find.byType(TrayView));
      expect(tray.bottom, lessThanOrEqualTo(844 - 32));
    },
  );
}
