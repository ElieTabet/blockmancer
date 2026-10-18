import 'package:flutter_test/flutter_test.dart';

import '../pump_home.dart';

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
}
