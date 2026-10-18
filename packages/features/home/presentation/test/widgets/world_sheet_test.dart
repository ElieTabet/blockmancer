import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_presentation/src/widgets/world_node.dart';
import 'package:home_presentation/src/widgets/world_sheet.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_home_routing.dart';
import '../pump_home.dart';

Finder _inSheet(Finder matching) =>
    find.descendant(of: find.byType(WorldSheet), matching: matching);

/// Mounts Home on [progression] and opens [world]'s sheet.
Future<FakeHomeRouting> _openSheet(
  WidgetTester tester,
  WorldId world, {
  Progression? progression,
}) async {
  final routing = await pumpHome(
    tester,
    progression: () async => progression ?? freshProgression(),
  );

  await tester.tap(
    find.byWidgetPredicate(
      (widget) => widget is WorldNode && widget.world == world,
    ),
  );
  await tester.pumpAndSettle();

  return routing;
}

void main() {
  testWidgets("Given a new player, When Rubble's sheet opens, "
      'Then it shows its boss, its three stars still to earn, the two jokers '
      'it unlocks with their numbers, and Start run', (tester) async {
    // Given / When
    await _openSheet(tester, .rubble);

    // Then
    expect(_inSheet(find.text('IN PROGRESS')), findsOne);
    expect(_inSheet(find.text('Rubble')), findsOne);
    expect(
      _inSheet(find.text('The boss starts with stones on the board.')),
      findsOne,
    );
    expect(_inSheet(find.text('Beat the boss: 1,500 points')), findsOne);
    expect(_inSheet(find.text('Beat the boss')), findsOne);
    expect(_inSheet(find.text('Beat the boss without reviving')), findsOne);
    expect(_inSheet(find.text('Reach 8,000 points in a run')), findsOne);
    expect(_inSheet(find.byIcon(Icons.star_rounded)), findsNothing);
    expect(_inSheet(find.byIcon(Icons.star_outline_rounded)), findsNWidgets(3));
    expect(_inSheet(find.text('Stonemason')), findsOne);
    expect(
      _inSheet(
        find.text(
          '+75 chips for each stone cleared. 4 extra stones every round.',
        ),
      ),
      findsOne,
    );
    expect(_inSheet(find.text('Quarry')), findsOne);
    expect(
      _inSheet(
        find.text('Every clear drops 3 new stones on random empty cells.'),
      ),
      findsOne,
    );
    expect(_inSheet(find.text('Unlocked')), findsNothing);
    expect(_inSheet(find.text('Start run')), findsOne);
  });

  testWidgets("Given a world's sheet, When the player asks how its boss "
      'plays, Then its boss card is asked for', (tester) async {
    // Given
    final routing = await _openSheet(tester, .rubble);

    // When
    await tester.tap(_inSheet(find.text('How the boss plays')));
    await tester.pump();

    // Then
    expect(routing.calls, ['bossCard:rubble']);
  });

  testWidgets("Given Rubble's boss beaten with two stars, "
      "When Rubble's sheet opens, "
      'Then it is done, two stars are filled, its jokers are unlocked and it '
      'offers a replay for the missing star', (tester) async {
    // Given / When
    await _openSheet(tester, .rubble, progression: rubbleBeaten);

    // Then
    expect(_inSheet(find.text('DONE')), findsOne);
    expect(_inSheet(find.byIcon(Icons.star_rounded)), findsNWidgets(2));
    expect(_inSheet(find.text('Unlocked')), findsNWidgets(2));
    expect(_inSheet(find.text('Replay for the missing star')), findsOne);
    expect(_inSheet(find.text('Start run')), findsNothing);
  });

  testWidgets("Given all of Rubble's stars earned, When its sheet opens, "
      'Then it offers Start run', (tester) async {
    // Given / When
    await _openSheet(
      tester,
      .rubble,
      progression: rubbleBeaten.copyWith(
        worlds: {
          ...rubbleBeaten.worlds,
          .rubble: const WorldProgress(
            bossBeaten: true,
            stars: WorldStars(
              bossBeaten: true,
              noRevive: true,
              scoreThreshold: true,
            ),
            unlocked: true,
          ),
        },
      ),
    );

    // Then
    expect(_inSheet(find.text('Start run')), findsOne);
    expect(_inSheet(find.text('Replay for the missing star')), findsNothing);
  });

  testWidgets("Given a new player, When Gravity's sheet opens, "
      'Then it is locked, says what opens it and offers no run', (
    tester,
  ) async {
    // Given / When
    await _openSheet(tester, .gravity);

    // Then
    expect(_inSheet(find.text('LOCKED')), findsOne);
    expect(
      _inSheet(
        find.text('In the boss round, every piece falls to the bottom.'),
      ),
      findsOne,
    );
    expect(_inSheet(find.text('Beat the boss: 2,000 points')), findsOne);
    expect(_inSheet(find.text('Beat the previous boss to unlock')), findsOne);
    expect(_inSheet(find.text('Start run')), findsNothing);
    expect(_inSheet(find.text('Replay for the missing star')), findsNothing);
  });

  testWidgets("Given a new player, When Fog's sheet opens, "
      'Then it is coming soon, with no boss, stars or run', (tester) async {
    // Given / When
    await _openSheet(tester, .fog);

    // Then
    expect(_inSheet(find.text('COMING SOON')), findsOne);
    expect(_inSheet(find.text('Fog')), findsOne);
    expect(_inSheet(find.textContaining('Beat the boss')), findsNothing);
    expect(_inSheet(find.byIcon(Icons.star_outline_rounded)), findsNothing);
    expect(_inSheet(find.text('Start run')), findsNothing);
  });

  for (final (label, progression) in [
    ('Start run', freshProgression()),
    ('Replay for the missing star', rubbleBeaten),
  ]) {
    testWidgets("Given Rubble's sheet, When $label is tapped, "
        "Then the sheet closes and Rubble's run is requested", (tester) async {
      // Given
      final routing = await _openSheet(
        tester,
        .rubble,
        progression: progression,
      );

      // When
      await tester.tap(_inSheet(find.text(label)));
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(WorldSheet), findsNothing);
      expect(routing.calls, ['world:rubble']);
    });
  }

  testWidgets("Given Rubble's sheet, When it is dismissed, "
      'Then no run is requested', (tester) async {
    // Given
    final routing = await _openSheet(tester, .rubble);

    // When
    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();

    // Then
    expect(find.byType(WorldSheet), findsNothing);
    expect(routing.calls, isEmpty);
  });
}
