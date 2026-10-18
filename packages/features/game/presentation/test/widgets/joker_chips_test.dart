import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/src/widgets/joker_chips.dart';

import '../fake_game_rules.dart';
import '../pump_game.dart';

void main() {
  testWidgets(
    "Given a run that retunes Hat Trick and plays a 4-piece tray, When its "
    "joker bar is read, Then Hat Trick's tooltip reads the run's numbers",
    (tester) async {
      // Given
      final run = runIn(const .playing(), jokers: const [.hattrick]).copyWith(
        config: testConfig.copyWith(
          jokers: testConfig.jokers.copyWith(hatTrickBonus: 650),
          traySize: 4,
        ),
        tray: const [0, 0, 0, 0],
      );

      // When
      await pumpGame(tester, run);

      // Then
      final tooltip = tester.widget<Tooltip>(
        find.descendant(
          of: find.byType(JokerChip),
          matching: find.byType(Tooltip),
        ),
      );
      expect(
        tooltip.message,
        '+650 points when each of the 4 pieces of a full tray clears a line.',
      );
    },
  );
}
