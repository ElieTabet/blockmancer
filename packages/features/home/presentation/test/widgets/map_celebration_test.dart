import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_presentation/src/providers_di.br.dart';
import 'package:home_presentation/src/widgets/home_widget.dart';
import 'package:home_presentation/src/widgets/map_celebration_director.dart';
import 'package:home_presentation/src/widgets/world_node.dart';
import 'package:home_presentation/src/widgets/world_sheet.dart';
import 'package:shared_domain/shared_domain.dart';

import '../pump_home.dart';

Finder _node(WorldId world) => find.byWidgetPredicate(
  (widget) => widget is WorldNode && widget.world == world,
);

Finder _in(WorldId world, Finder matching) =>
    find.descendant(of: _node(world), matching: matching);

int _filledStars(WidgetTester tester, WorldId world) =>
    _in(world, find.byIcon(Icons.star_rounded)).evaluate().length;

bool _locked(WorldId world) =>
    _in(world, find.byIcon(Icons.lock_rounded)).evaluate().isNotEmpty;

bool _celebrating(WidgetTester tester) =>
    tester
        .widget<MapCelebrationScope>(find.byType(MapCelebrationScope))
        .celebration !=
    null;

/// The map shown to a new player, then left for a run that beat Rubble's
/// boss with no revive, and back: two stars to fill and Gravity to open.
Future<void> _returnFromBeatingRubble(
  WidgetTester tester, {
  required bool reduceMotion,
}) async {
  var progression = freshProgression();
  await pumpHome(
    tester,
    progression: () async => progression,
    reduceMotion: reduceMotion,
  );
  await tester.pump();

  progression = rubbleBeaten;
  ProviderScope.containerOf(
    tester.element(find.byType(HomeWidget)),
  ).invalidate(progressionProvider);

  // The progression is read again, then the map takes it in.
  for (var frame = 0; frame < 4; frame++) {
    await tester.pump(const Duration(milliseconds: 10));
  }
}

/// Past the wait for the covering route to leave.
const _settleDelay = Duration(milliseconds: 360);

void main() {
  testWidgets('Given a new player, When the map first shows, Then it '
      'celebrates nothing', (tester) async {
    // Given / When
    await pumpHome(tester, reduceMotion: false);
    await tester.pump();

    // Then
    expect(_celebrating(tester), isFalse);
  });

  testWidgets('Given a run that earned two stars and opened Gravity, When the '
      'map is back, Then the stars fill one after the other, then Gravity '
      'opens, once', (tester) async {
    // Given / When
    await _returnFromBeatingRubble(tester, reduceMotion: false);

    // Then: held as it stood until it starts
    expect(_celebrating(tester), isTrue);
    expect(_filledStars(tester, .rubble), 0);
    expect(_locked(.gravity), isTrue);

    // When: the first star's turn
    await tester.pump(_settleDelay);
    await tester.pump(const Duration(milliseconds: 100));

    // Then
    expect(_filledStars(tester, .rubble), 1);

    // When: both stars filled, the trail drawing
    await tester.pump(const Duration(milliseconds: 600));

    // Then
    expect(_filledStars(tester, .rubble), 2);
    expect(_locked(.gravity), isTrue);

    // When: Gravity pops open
    await tester.pump(const Duration(milliseconds: 500));

    // Then
    expect(_locked(.gravity), isFalse);

    // When: it ends, and the map is read again
    await tester.pump(const Duration(milliseconds: 400));
    expect(_celebrating(tester), isFalse);
    ProviderScope.containerOf(
      tester.element(find.byType(HomeWidget)),
    ).invalidate(progressionProvider);
    for (var frame = 0; frame < 4; frame++) {
      await tester.pump(const Duration(milliseconds: 10));
    }

    // Then: nothing plays again
    expect(_celebrating(tester), isFalse);
    expect(_filledStars(tester, .rubble), 2);
    expect(_locked(.gravity), isFalse);
  });

  testWidgets('Given reduce motion, When the map is back from a run that '
      'earned something, Then it shows the map as it now stands at once', (
    tester,
  ) async {
    // Given / When
    await _returnFromBeatingRubble(tester, reduceMotion: true);

    // Then
    expect(_celebrating(tester), isFalse);
    expect(_filledStars(tester, .rubble), 2);
    expect(_locked(.gravity), isFalse);
    expect(tester.binding.hasScheduledFrame, isFalse);
  });

  testWidgets('Given the celebration playing, When the map is tapped, Then it '
      'skips to the end and opens no world', (tester) async {
    // Given
    await _returnFromBeatingRubble(tester, reduceMotion: false);
    await tester.pump(_settleDelay);
    await tester.pump(const Duration(milliseconds: 100));

    // When
    await tester.tap(_node(.gravity));
    await tester.pump();

    // Then
    expect(_celebrating(tester), isFalse);
    expect(_filledStars(tester, .rubble), 2);
    expect(_locked(.gravity), isFalse);
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(WorldSheet), findsNothing);
  });

  for (final (name, reduceMotion) in [
    ('shakes lightly', false),
    ('keeps still under reduce motion', true),
  ]) {
    testWidgets('Given a locked world, When it is tapped, Then it $name', (
      tester,
    ) async {
      // Given
      await pumpHome(tester, reduceMotion: reduceMotion);
      final badge = _in(.gravity, find.byType(WorldBadge));
      final before = tester.getCenter(badge);

      // When
      await tester.tap(_node(.gravity));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 40));

      // Then
      final shift = (tester.getCenter(badge).dx - before.dx).abs();
      expect(shift, reduceMotion ? 0 : greaterThan(0.5));
      await tester.pump(const Duration(seconds: 1));
    });
  }
}
