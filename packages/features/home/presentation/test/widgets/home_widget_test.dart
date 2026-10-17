import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_presentation/home_presentation.dart';
import 'package:home_presentation/src/widgets/home_widget.dart';
import 'package:l10n_application/l10n_application.dart';

import '../fake_home_routing.dart';

Future<FakeHomeRouting> _pumpHome(
  WidgetTester tester, {
  int? dailyBest,
  int? practiceBest,
}) async {
  final routing = FakeHomeRouting();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        ...bindProviders(
          dailyBest: (ref) async => dailyBest,
          practiceBest: (ref) async => practiceBest,
        ),
        ...bindRoutingProviders(homeRouting: (ref) => routing),
      ],
      child: TranslationProvider(
        child: MaterialApp(
          theme: DSTheme.instance.darkTheme,
          home: const HomeWidget(),
        ),
      ),
    ),
  );
  await tester.pump();

  return routing;
}

void main() {
  testWidgets('offers the daily run and practice, each with its best', (
    tester,
  ) async {
    // Given / When
    await _pumpHome(tester, dailyBest: 2400, practiceBest: 12345);

    // Then
    expect(find.text('Daily run'), findsOneWidget);
    expect(find.text('Best: 2,400'), findsOneWidget);
    expect(find.text('Practice'), findsOneWidget);
    expect(find.text('Best: 12,345'), findsOneWidget);
  });

  testWidgets('a mode not played yet says so', (tester) async {
    // Given / When
    await _pumpHome(tester, practiceBest: 900);

    // Then
    expect(find.text('No run yet'), findsOneWidget);
    expect(find.text('Best: 900'), findsOneWidget);
  });

  for (final (card, call) in const [
    ('Daily run', 'daily'),
    ('Practice', 'practice'),
  ]) {
    testWidgets('tapping $card starts that run', (tester) async {
      // Given
      final routing = await _pumpHome(tester);

      // When
      await tester.tap(find.text(card));
      await tester.pump();

      // Then
      expect(routing.calls, [call]);
    });
  }
}
