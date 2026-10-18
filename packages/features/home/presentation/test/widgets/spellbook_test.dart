import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_presentation/src/widgets/joker_sheet.dart';
import 'package:home_presentation/src/widgets/spellbook_card.dart';
import 'package:home_presentation/src/widgets/spellbook_widget.dart';
import 'package:shared_domain/shared_domain.dart';

import '../pump_home.dart';

/// A player with the 12 jokers of the first six pairs, all seen by the
/// Spellbook, having won 1 run with Combo King, 5 with Collector, and 15 with
/// both Patience and Twin Lines.
final _player = freshProgression().copyWith(
  jokerStats: const {
    .collector: JokerStats(bestRunTotal: 8100, runsWon: 5, timesPicked: 9),
    .combo: JokerStats(bestRunTotal: 7200, runsWon: 1, timesPicked: 3),
    .patience: JokerStats(bestRunTotal: 9900, runsWon: 15, timesPicked: 20),
    .twin: JokerStats(bestRunTotal: 9800, runsWon: 15, timesPicked: 18),
  },
  spellbookSeen: _firstSix,
  unlockedJokers: _firstSix,
);

final _firstSix = {
  for (final pair in collection.pairs.take(6)) ...[pair.first, pair.second],
};

Finder _card(JokerId joker) => find.byWidgetPredicate(
  (widget) => widget is SpellbookCard && widget.joker == joker,
);

Finder _inCard(JokerId joker, Finder finder) =>
    find.descendant(of: _card(joker), matching: finder);

/// The number of [joker]'s mastery dots that are filled.
int _dotsOn(WidgetTester tester, JokerId joker) => [
  for (var dot = 1; dot <= 3; dot++)
    if (_inCard(
      joker,
      find.byKey(ValueKey('dot-$dot-on')),
    ).evaluate().isNotEmpty)
      dot,
].length;

Future<void> _pumpSpellbook(
  WidgetTester tester, {
  Progression Function()? progression,
  void Function()? markSeen,
}) => pumpHome(
  tester,
  markSpellbookSeen: () async => markSeen?.call(),
  progression: () async => progression?.call() ?? _player,
  screen: const SpellbookWidget(),
  viewSize: const Size(390, 844),
);

void main() {
  testWidgets(
    'Given an unlocked joker, When the Spellbook opens, Then its card '
    'shows its emblem, short name and mastery, and nothing more',
    (tester) async {
      // Given / When
      await _pumpSpellbook(tester);

      // Then
      expect(_inCard(.combo, find.text('Combo')), findsOneWidget);
      expect(_inCard(.combo, find.byIcon(Icons.bolt_rounded)), findsOneWidget);
      expect(_inCard(.combo, find.textContaining('mult')), findsNothing);
      expect(_inCard(.combo, find.textContaining('Pairs with')), findsNothing);
      expect(_inCard(.combo, find.text('Picked')), findsNothing);
    },
  );

  testWidgets('Given wins with each joker, When the Spellbook opens, Then '
      'their dots show bronze at 1 win, silver at 5 and gold at 15', (
    tester,
  ) async {
    // Given / When
    await _pumpSpellbook(tester);

    // Then
    expect(_dotsOn(tester, .combo), 1);
    expect(_dotsOn(tester, .collector), 2);
    expect(_dotsOn(tester, .patience), 3);
    expect(_dotsOn(tester, .precision), 0);
  });

  testWidgets('Given both partners gold, When the Spellbook opens, Then the '
      'pair counts as mastered', (tester) async {
    // Given / When: Patience and Twin Lines are partners, both at 15 wins
    await _pumpSpellbook(tester);

    // Then
    expect(find.text('12 / 20 collected'), findsOneWidget);
    expect(find.text('Pairs mastered 1 / 10'), findsOneWidget);
  });

  testWidgets(
    'Given a locked joker, When the Spellbook shows it, Then its card '
    'is a dark silhouette with "?" and a lock, its name hidden',
    (tester) async {
      // Given
      await _pumpSpellbook(tester);

      // When
      await tester.scrollUntilVisible(_card(.stonemason), 300);
      await tester.pumpAndSettle();

      // Then
      expect(_inCard(.stonemason, find.byType(LockedCardFace)), findsOneWidget);
      expect(_inCard(.stonemason, find.text('?')), findsOneWidget);
      expect(
        _inCard(.stonemason, find.byIcon(Icons.lock_rounded)),
        findsOneWidget,
      );
      expect(_inCard(.stonemason, find.text('Stonemason')), findsNothing);
    },
  );

  testWidgets('Given jokers unlocked since the last visit, When the Spellbook '
      'opens, Then they wear NEW; When it is opened again, Then they no '
      'longer do', (tester) async {
    // Given: Stonemason and Quarry unlocked, not yet seen
    var progression = _player.copyWith(
      unlockedJokers: {..._firstSix, .stonemason, .quarry},
    );
    var marked = 0;

    // When
    await _pumpSpellbook(
      tester,
      markSeen: () {
        marked++;
        progression = progression.copyWith(
          spellbookSeen: progression.unlockedJokers,
        );
      },
      progression: () => progression,
    );
    await tester.scrollUntilVisible(_card(.stonemason), 300);
    await tester.pumpAndSettle();

    // Then
    expect(_inCard(.stonemason, find.text('NEW')), findsOneWidget);
    expect(_inCard(.quarry, find.text('NEW')), findsOneWidget);
    expect(find.text('NEW'), findsNWidgets(2));
    expect(marked, 1);

    // When: left, then opened again
    await tester.pumpWidget(const SizedBox());
    await _pumpSpellbook(tester, progression: () => progression);
    await tester.scrollUntilVisible(_card(.stonemason), 300);
    await tester.pumpAndSettle();

    // Then
    expect(find.text('NEW'), findsNothing);
  });

  testWidgets('Given an unlocked card, When it is tapped, Then its sheet shows '
      'the joker in full, with the wins to its next tier', (tester) async {
    // Given
    await _pumpSpellbook(tester);

    // When
    await tester.tap(_card(.combo));
    await tester.pumpAndSettle();

    // Then
    final sheet = find.byType(JokerSheet);
    Finder inSheet(Finder finder) =>
        find.descendant(of: sheet, matching: finder);
    expect(inSheet(find.text('Combo King')), findsOneWidget);
    expect(inSheet(find.text('+ Mult')), findsOneWidget);
    expect(
      inSheet(
        find.text(
          '+1 mult for every clearing move in a row.',
          findRichText: true,
        ),
      ),
      findsOneWidget,
    );
    expect(inSheet(find.text('7,200')), findsOneWidget);
    expect(inSheet(find.text('1 / 5 wins to silver')), findsOneWidget);
  });

  testWidgets("Given a joker's sheet, When its partner is tapped, Then the "
      "sheet shows the partner", (tester) async {
    // Given
    await _pumpSpellbook(tester);
    await tester.tap(_card(.combo));
    await tester.pumpAndSettle();
    final sheet = find.byType(JokerSheet);

    // When
    await tester.ensureVisible(
      find.descendant(of: sheet, matching: find.byType(PartnerTile)),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(of: sheet, matching: find.byType(PartnerTile)),
    );
    await tester.pumpAndSettle();

    // Then: Collector's sheet, at silver, five wins
    expect(
      find.descendant(of: sheet, matching: find.text('Collector')),
      findsWidgets,
    );
    expect(
      find.descendant(of: sheet, matching: find.text('5 / 15 wins to gold')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: sheet, matching: find.text('Combo King')),
      findsOneWidget,
    );
  });

  testWidgets('Given a gold joker, When its sheet opens, Then it is fully '
      'mastered', (tester) async {
    // Given
    await _pumpSpellbook(tester);

    // When
    await tester.tap(_card(.patience));
    await tester.pumpAndSettle();

    // Then
    expect(find.text('Gold: fully mastered'), findsOneWidget);
  });

  testWidgets('Given a locked card, When it is tapped, Then its sheet says how '
      'to unlock it and nothing more', (tester) async {
    // Given
    await _pumpSpellbook(tester);
    await tester.scrollUntilVisible(_card(.anchor), 300);
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

  testWidgets("Given rules that retune Combo King, When its sheet opens, Then "
      "it reads the rules' numbers", (tester) async {
    // Given
    await pumpHome(
      tester,
      jokerCollection: collection.copyWith(
        tuning: tuning.copyWith(comboMultPerStreak: 3),
      ),
      progression: () async => _player,
      screen: const SpellbookWidget(),
      viewSize: const Size(390, 844),
    );

    // When
    await tester.tap(_card(.combo));
    await tester.pumpAndSettle();

    // Then
    expect(
      find.text(
        '+3 mult for every clearing move in a row.',
        findRichText: true,
      ),
      findsOneWidget,
    );
  });

  testWidgets('Given a screen reader, When it reaches the cards, Then each '
      'says its name, kind and tier, or that it is locked', (tester) async {
    // Given
    final semantics = tester.ensureSemantics();

    // When
    await _pumpSpellbook(tester);

    // Then
    expect(find.bySemanticsLabel('Combo King, + Mult, Bronze'), findsOneWidget);
    expect(find.bySemanticsLabel('Twin Lines, × Mult, Gold'), findsOneWidget);

    // When
    await tester.scrollUntilVisible(_card(.stonemason), 300);
    await tester.pumpAndSettle();

    // Then
    expect(
      find.bySemanticsLabel('Locked joker. Beat the Rubble boss'),
      findsWidgets,
    );
    semantics.dispose();
  });

  testWidgets('Given the Spellbook, When it is flung to its end, Then every '
      'pair shows without a layout error', (tester) async {
    // Given
    await _pumpSpellbook(tester);

    // When
    await tester.fling(
      find.byType(SpellbookWidget),
      const Offset(0, -3000),
      3000,
    );
    await tester.pumpAndSettle();

    // Then
    expect(tester.takeException(), isNull);
    expect(_card(.hattrick), findsOneWidget);
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
