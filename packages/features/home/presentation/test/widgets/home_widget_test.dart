import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_presentation/home_presentation.dart';
import 'package:home_presentation/src/widgets/home_widget.dart';

import '../pump_home.dart';

/// What today's best is read from: Remote Config's values, which a return to
/// the app may renew.
final _readFrom = NotifierProvider<_Revision, int>(_Revision.new);

final class _Revision extends Notifier<int> {
  @override
  int build() => 0;

  void renew() => state++;
}

void main() {
  testWidgets('Given both bests, When Home opens, '
      "Then the daily card shows today's date and best, and practice its own", (
    tester,
  ) async {
    // Given / When
    await pumpHome(tester, dailyBest: 2400, practiceBest: 12345);

    // Then
    expect(find.text('Saturday, October 17'), findsOneWidget);
    expect(find.text('Daily run'), findsOneWidget);
    expect(find.text('Best: 2,400'), findsOneWidget);
    expect(find.text('Practice'), findsOneWidget);
    expect(find.text('Best: 12,345'), findsOneWidget);
  });

  testWidgets("Given today's best on the daily card, When the app comes back "
      'to the front and the best is read again, Then it stays on screen, so '
      'nothing below it moves', (tester) async {
    // Given: the first read answers at once, the next one takes its time
    var reads = 0;
    await pumpHome(
      tester,
      loadDailyBest: (ref) {
        ref.watch(_readFrom);

        return reads++ == 0 ? Future.value(2400) : Completer<int?>().future;
      },
    );
    expect(find.text('Best: 2,400'), findsOneWidget);

    // When
    ProviderScope.containerOf(
      tester.element(find.byType(HomeWidget)),
    ).read(_readFrom.notifier).renew();
    await tester.pump();

    // Then
    expect(reads, 2);
    expect(find.text('Best: 2,400'), findsOneWidget);
  });

  testWidgets('Given no daily run today, When Home opens, '
      'Then the daily card says so', (tester) async {
    // Given / When
    await pumpHome(tester, practiceBest: 900);

    // Then
    expect(find.text('No run yet'), findsOneWidget);
    expect(find.text('Best: 900'), findsOneWidget);
  });

  testWidgets('Given a saved run, When Home opens, '
      'Then it is offered to continue', (tester) async {
    // Given / When
    await pumpHome(tester, hasSavedRun: true);

    // Then
    expect(find.text('Continue run'), findsOneWidget);
  });

  testWidgets('Given no saved run, When Home opens, '
      'Then nothing is offered to continue', (tester) async {
    // Given / When
    await pumpHome(tester);

    // Then
    expect(find.text('Continue run'), findsNothing);
  });

  for (final (entry, call) in const [
    ('Continue run', 'continue'),
    ('Daily run', 'daily'),
    ('Practice', 'practice'),
  ]) {
    testWidgets('Given Home, When $entry is tapped, Then that run opens', (
      tester,
    ) async {
      // Given
      final routing = await pumpHome(tester, hasSavedRun: true);

      // When
      await tester.tap(find.text(entry));
      await tester.pump();

      // Then
      expect(routing.calls, [call]);
    });
  }

  testWidgets('Given daily runs on 3 days in a row, When Home opens, Then the '
      'daily card shows the streak', (tester) async {
    // Given / When
    await pumpHome(tester, dailyStreak: 3);
    await tester.pump();

    // Then
    expect(find.text('3-day streak'), findsOneWidget);
  });

  testWidgets('Given no daily run yet, When Home opens, Then no streak shows', (
    tester,
  ) async {
    // Given / When
    await pumpHome(tester);
    await tester.pump();

    // Then
    expect(find.textContaining('streak'), findsNothing);
  });

  testWidgets("Given Home, When the daily card's Leaderboard is tapped, Then "
      "today's board opens and no run does", (tester) async {
    // Given
    var shown = 0;
    final routing = await pumpHome(
      tester,
      showDailyLeaderboard: () async => shown++,
    );

    // When
    await tester.tap(find.text('Leaderboard'));
    await tester.pump();

    // Then
    expect(shown, 1);
    expect(routing.calls, isEmpty);
  });

  testWidgets('Given Home, When the gear is tapped, Then Settings opens', (
    tester,
  ) async {
    // Given
    final routing = await pumpHome(tester);

    // When
    await tester.tap(find.bySemanticsLabel('Settings'));
    await tester.pump();

    // Then
    expect(routing.calls, ['settings']);
  });

  testWidgets('Given Home scrolled down the map, When a daily reminder is '
      'tapped, Then Home scrolls back to the daily run', (tester) async {
    // Given
    // A phone's height, so the map runs below the fold
    await pumpHome(tester, viewSize: const Size(390, 700));
    ScrollPosition position() => tester
        .state<ScrollableState>(
          find
              .descendant(
                of: find.byType(SingleChildScrollView),
                matching: find.byType(Scrollable),
              )
              .first,
        )
        .position;
    position().jumpTo(position().maxScrollExtent);
    await tester.pump();
    expect(position().pixels, greaterThan(0));

    // When
    ProviderScope.containerOf(
      tester.element(find.byType(HomeWidget)),
    ).read(revealDailyCardProvider)();
    await tester.pumpAndSettle();

    // Then
    expect(position().pixels, 0);
  });
}
