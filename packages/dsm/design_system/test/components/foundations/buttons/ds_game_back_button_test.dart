import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Given a game screen with a back button '
      'When the player taps it '
      'Then it goes back, and a screen reader names it without any text '
      'on screen', (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: DSGameBackButton(
            onTap: () => taps++,
            semanticLabel: 'Back to the menu',
          ),
        ),
      ),
    );

    await tester.tap(find.bySemanticsLabel('Back to the menu'));
    await tester.pumpAndSettle();

    expect(taps, 1);
    expect(find.text('Back to the menu'), findsNothing);
  });
}
