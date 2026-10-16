import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/src/widgets/board_view.dart';
import 'package:game_presentation/src/widgets/joker_chips.dart';
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
}
