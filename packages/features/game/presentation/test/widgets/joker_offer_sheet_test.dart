import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/src/widgets/joker_offer_sheet.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_game_rules.dart';
import '../pump_game.dart';

/// The border colour of the offer card for [id].
Color _borderOf(WidgetTester tester, JokerId id) {
  final card = tester.widget<Container>(
    find
        .descendant(
          of: find.byWidgetPredicate(
            (widget) => widget is JokerOfferCard && widget.id == id,
          ),
          matching: find.byType(Container),
        )
        .first,
  );
  final decoration = card.decoration! as ShapeDecoration;

  return (decoration.shape as RoundedRectangleBorder).side.color;
}

void main() {
  testWidgets(
    'an offer that completes a pair with an owned joker is highlighted in amber',
    (tester) async {
      // Given / When: Patience is owned and pairs with Twin; Combo pairs with Twin
      await pumpGame(
        tester,
        runIn(
          const .pickingJoker(offers: [.twin, .combo]),
          jokers: const [.patience],
        ),
      );

      // Then
      expect(_borderOf(tester, .twin), DSColor.accent);
      expect(
        find.text('★ Completes a pair with your Patience'),
        findsOneWidget,
      );
      expect(_borderOf(tester, .combo), DSColor.joker);
      expect(find.text('Pairs with: Twin Lines'), findsOneWidget);
    },
  );

  testWidgets('the pick cannot be skipped by tapping beside it or going back', (
    tester,
  ) async {
    // Given
    final rules = await pumpGame(
      tester,
      runIn(const .pickingJoker(offers: [.twin, .combo, .saver]), pickIndex: 0),
    );

    // When
    await tester.tapAt(const Offset(195, 40));
    await tester.binding.handlePopRoute();
    await tester.pump();

    // Then
    expect(rules.calls, ['startRun 1']);
    expect(find.text('Pick your starting joker'), findsOneWidget);
    expect(find.byType(JokerOfferCard), findsNWidgets(3));
  });
}
