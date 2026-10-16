import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('pressing it pops the page it sits on', (tester) async {
    final navigator = GlobalKey<NavigatorState>();

    await tester.pumpWidget(
      MaterialApp(navigatorKey: navigator, home: const Text('home')),
    );

    navigator.currentState!.push(
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(appBar: AppBar(leading: const DSBackButton())),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DSBackButton));
    await tester.pumpAndSettle();

    expect(find.text('home'), findsOneWidget);
    expect(find.byType(DSBackButton), findsNothing);
  });

  testWidgets('screen readers hear it named, with no tooltip', (tester) async {
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: DSBackButton())),
    );

    expect(find.bySemanticsLabel('Back'), findsOneWidget);
    expect(find.byType(Tooltip), findsNothing);

    semantics.dispose();
  });
}
