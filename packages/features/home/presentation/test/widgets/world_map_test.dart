import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_presentation/src/providers_di.br.dart';
import 'package:home_presentation/src/widgets/home_widget.dart';
import 'package:home_presentation/src/widgets/world_node.dart';
import 'package:shared_domain/shared_domain.dart';

import '../pump_home.dart';

Finder _node(WorldId world) => find.byWidgetPredicate(
  (widget) => widget is WorldNode && widget.world == world,
);

Finder _in(WorldId world, Finder matching) =>
    find.descendant(of: _node(world), matching: matching);

Finder _marker(WorldId world) =>
    _in(world, find.byIcon(Icons.location_on_rounded));

void main() {
  testWidgets('Given a new player, When Home opens, '
      'Then Rubble is where they are, Gravity is locked and the rest are '
      'coming soon', (tester) async {
    // Given / When
    await pumpHome(tester);

    // Then
    expect(_marker(.rubble), findsOneWidget);
    expect(_in(.rubble, find.byIcon(Icons.lock_rounded)), findsNothing);
    expect(_in(.gravity, find.byIcon(Icons.lock_rounded)), findsOneWidget);
    expect(_marker(.gravity), findsNothing);
    for (final world in const [WorldId.fog, WorldId.tide, WorldId.mirror]) {
      expect(_in(world, find.text('Coming soon')), findsOneWidget);
    }
    expect(find.byIcon(Icons.location_on_rounded), findsOneWidget);
  });

  testWidgets('Given the worlds, When Home opens, '
      "Then each is numbered and named in the map's order", (tester) async {
    // Given / When
    await pumpHome(tester);

    // Then
    for (final (index, name) in const [
      'Rubble',
      'Gravity',
      'Fog',
      'Tide',
      'Mirror',
    ].indexed) {
      final world = mapWorlds[index].id;
      expect(_in(world, find.text('${index + 1}')), findsOneWidget);
      expect(_in(world, find.text(name)), findsOneWidget);
    }
  });

  testWidgets("Given Rubble's boss beaten without a revive, When Home opens, "
      'Then Rubble is done with two stars and Gravity is where they are', (
    tester,
  ) async {
    // Given / When
    await pumpHome(tester, progression: () async => rubbleBeaten);

    // Then
    expect(_in(.rubble, find.byIcon(Icons.check_rounded)), findsOneWidget);
    expect(_in(.rubble, find.byIcon(Icons.star_rounded)), findsNWidgets(2));
    expect(_marker(.rubble), findsNothing);
    expect(_marker(.gravity), findsOneWidget);
    expect(_in(.gravity, find.byIcon(Icons.lock_rounded)), findsNothing);
  });

  testWidgets('Given only Rubble\'s score star earned, When Home opens, '
      'Then one of its three stars is filled', (tester) async {
    // Given / When
    await pumpHome(
      tester,
      progression: () async => freshProgression(
        rubbleStars: const WorldStars(
          bossBeaten: false,
          noRevive: false,
          scoreThreshold: true,
        ),
      ),
    );

    // Then
    expect(_in(.rubble, find.byIcon(Icons.star_rounded)), findsOneWidget);
    expect(
      _in(.rubble, find.byIcon(Icons.star_outline_rounded)),
      findsNWidgets(2),
    );
    // Read as part of the node's own label.
    expect(find.bySemanticsLabel(RegExp('Stars: 1 of 3')), findsOneWidget);
  });

  testWidgets('Given Home on a new player\'s map, '
      'When the progression is refreshed with Rubble beaten, '
      'Then the map shows it at once', (tester) async {
    // Given
    var progression = freshProgression();
    await pumpHome(tester, progression: () async => progression);
    expect(_marker(.rubble), findsOneWidget);

    // When
    progression = rubbleBeaten;
    ProviderScope.containerOf(
      tester.element(find.byType(HomeWidget)),
    ).invalidate(progressionProvider);
    await tester.pump();
    await tester.pump();

    // Then
    expect(_in(.rubble, find.byIcon(Icons.check_rounded)), findsOneWidget);
    expect(_marker(.gravity), findsOneWidget);
  });

  testWidgets('Given motion allowed, When time passes, '
      'Then the "you are here" pin bobs', (tester) async {
    // Given
    await pumpHome(tester, reduceMotion: false);
    final before = tester.getCenter(_marker(.rubble));

    // When
    await tester.pump(const Duration(milliseconds: 350));

    // Then
    expect(tester.getCenter(_marker(.rubble)), isNot(before));
  });

  testWidgets("Given Settings' reduce motion on, When time passes, "
      'Then the "you are here" pin holds still', (tester) async {
    // Given
    await pumpHome(tester);
    final before = tester.getCenter(_marker(.rubble));

    // When
    await tester.pump(const Duration(milliseconds: 350));

    // Then
    expect(tester.getCenter(_marker(.rubble)), before);
    expect(tester.binding.hasScheduledFrame, isFalse);
  });

  testWidgets("Given the phone's reduce motion on, When time passes, "
      'Then the "you are here" pin holds still', (tester) async {
    // Given
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await pumpHome(tester, reduceMotion: false);
    final before = tester.getCenter(_marker(.rubble));

    // When
    await tester.pump(const Duration(milliseconds: 350));

    // Then
    expect(tester.getCenter(_marker(.rubble)), before);
  });
}
