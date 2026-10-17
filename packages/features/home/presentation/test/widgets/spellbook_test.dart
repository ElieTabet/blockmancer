import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_presentation/src/widgets/joker_sheet.dart';
import 'package:home_presentation/src/widgets/spellbook_card.dart';
import 'package:home_presentation/src/widgets/spellbook_widget.dart';
import 'package:shared_domain/shared_domain.dart';

import '../pump_home.dart';

/// A player with the 12 jokers a new player has, a few runs played with Combo
/// King.
final _player = freshProgression().copyWith(
  jokerStats: const {
    .combo: JokerStats(bestRunTotal: 7200, runsWon: 1, timesPicked: 3),
  },
  unlockedJokers: {
    for (final pair in collection.pairs.take(6)) ...[pair.first, pair.second],
  },
);

Finder _card(JokerId joker) => find.byWidgetPredicate(
  (widget) => widget is SpellbookCard && widget.joker == joker,
);

Future<void> _pumpSpellbook(WidgetTester tester) => pumpHome(
  tester,
  progression: () async => _player,
  screen: const SpellbookWidget(),
  viewSize: const Size(390, 844),
);

void main() {
  testWidgets(
    'Given an unlocked joker, When the Spellbook opens, Then its card '
    'shows what it does, its partner and its stats',
    (tester) async {
      // Given / When
      await _pumpSpellbook(tester);

      // Then
      final card = _card(.combo);
      Finder inCard(String text) =>
          find.descendant(of: card, matching: find.text(text));
      expect(find.byType(UnlockedJokerCard), findsWidgets);
      expect(inCard('Combo King'), findsOneWidget);
      expect(
        inCard('+1 mult for every clearing move in a row.'),
        findsOneWidget,
      );
      expect(inCard('Pairs with Collector'), findsOneWidget);
      expect(inCard('Picked'), findsOneWidget);
      expect(inCard('3'), findsOneWidget);
      expect(inCard('1'), findsOneWidget);
      expect(inCard('7,200'), findsOneWidget);
    },
  );

  testWidgets(
    'Given a locked joker, When the Spellbook shows it, Then its card '
    'is a silhouette with the way to unlock it',
    (tester) async {
      // Given
      await _pumpSpellbook(tester);

      // When
      await tester.scrollUntilVisible(_card(.stonemason), 300);
      await tester.ensureVisible(_card(.stonemason));
      await tester.pumpAndSettle();

      // Then
      final card = _card(.stonemason);
      expect(
        find.descendant(of: card, matching: find.byType(LockedJokerCard)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: card, matching: find.text('Beat the Rubble boss')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: card, matching: find.text('Stonemason')),
        findsNothing,
      );
    },
  );

  testWidgets('Given the Spellbook, When it is scrolled to its end, Then all '
      '10 pairs show, the last two unlocked by stars', (tester) async {
    // Given
    await _pumpSpellbook(tester);
    expect(find.text('12 of 20 jokers unlocked'), findsOneWidget);

    // When
    await tester.fling(
      find.byType(SpellbookWidget),
      const Offset(0, -3000),
      3000,
    );
    await tester.pumpAndSettle();

    // Then
    expect(tester.takeException(), isNull);
    expect(
      find.descendant(
        of: _card(.finisher),
        matching: find.text('Collect 6 stars'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: _card(.brink),
        matching: find.text('Collect 4 stars'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Given a catalog of another size, When the Spellbook opens, '
      'Then it shows every card of it, pair by pair', (tester) async {
    // Given: 3 pairs, one of them unlocked
    const small = JokerCollection(
      pairs: [
        JokerPair(first: .combo, second: .collector, unlock: .starting()),
        JokerPair(
          first: .stonemason,
          second: .quarry,
          unlock: .boss(world: .rubble),
        ),
        JokerPair(first: .fullhouse, second: .brink, unlock: .stars(count: 4)),
      ],
      tuning: tuning,
    );

    // When
    await pumpHome(
      tester,
      jokerCollection: small,
      progression: () async => freshProgression().copyWith(
        unlockedJokers: const {.combo, .collector},
      ),
      screen: const SpellbookWidget(),
      viewSize: const Size(390, 1300),
    );

    // Then
    expect(find.byType(SpellbookCard), findsNWidgets(6));
    expect(find.byType(UnlockedJokerCard), findsNWidgets(2));
    expect(find.byType(LockedJokerCard), findsNWidgets(4));
    expect(find.text('2 of 6 jokers unlocked'), findsOneWidget);
  });

  testWidgets('Given an unlocked card, When it is tapped, Then its sheet '
      'opens in full', (tester) async {
    // Given
    await _pumpSpellbook(tester);

    // When
    await tester.tap(_card(.combo));
    await tester.pumpAndSettle();

    // Then
    final sheet = find.byType(JokerSheet);
    expect(sheet, findsOneWidget);
    expect(
      find.descendant(of: sheet, matching: find.text('Combo King')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: sheet, matching: find.text('7,200')),
      findsOneWidget,
    );
  });

  testWidgets('Given a locked card, When it is tapped, Then its sheet says '
      'how to unlock it and nothing more', (tester) async {
    // Given
    await _pumpSpellbook(tester);
    await tester.scrollUntilVisible(_card(.anchor), 300);
    await tester.ensureVisible(_card(.anchor));
    await tester.pumpAndSettle();

    // When
    await tester.tap(_card(.anchor));
    await tester.pumpAndSettle();

    // Then
    final sheet = find.byType(JokerSheet);
    expect(
      find.descendant(of: sheet, matching: find.text('Beat the Gravity boss')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: sheet, matching: find.text('Anchor')),
      findsNothing,
    );
  });

  testWidgets('Given the Spellbook, When close is tapped, Then it asks to '
      'close', (tester) async {
    // Given
    final routing = await pumpHome(
      tester,
      progression: () async => _player,
      screen: const SpellbookWidget(),
      viewSize: const Size(390, 844),
    );

    // When
    await tester.tap(find.bySemanticsLabel('Close'));

    // Then
    expect(routing.calls, ['spellbook:close']);
  });
}
