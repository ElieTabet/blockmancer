import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _card = Key('card');

Future<void> _pump(WidgetTester tester, {VoidCallback? onTap}) =>
    tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: DSPressable(
            onTap: onTap,
            child: const SizedBox.square(key: _card, dimension: 100),
          ),
        ),
      ),
    );

/// How large the card is drawn, 1 being its full size.
double _scaleOf(WidgetTester tester) => tester
    .widget<ScaleTransition>(
      find.ancestor(
        of: find.byKey(_card),
        matching: find.byType(ScaleTransition),
      ),
    )
    .scale
    .value;

void main() {
  testWidgets('Given a card that can be tapped '
      'When the player holds a finger on it '
      'Then it shrinks, and nothing happens until the finger lifts', (
    tester,
  ) async {
    var taps = 0;

    await _pump(tester, onTap: () => taps++);

    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(_card)),
    );
    await tester.pumpAndSettle();

    expect(_scaleOf(tester), lessThan(1));
    expect(taps, 0);

    await gesture.up();
    await tester.pumpAndSettle();

    expect(_scaleOf(tester), 1);
    expect(taps, 1);
  });

  testWidgets('Given a card that can be tapped '
      'When the player taps it quickly '
      'Then it still visibly shrinks before springing back', (tester) async {
    await _pump(tester, onTap: () {});

    await tester.tap(find.byType(DSPressable));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));

    expect(_scaleOf(tester), lessThan(1));

    await tester.pumpAndSettle();

    expect(_scaleOf(tester), 1);
  });

  testWidgets('Given a card with nothing to do '
      'When the player holds a finger on it '
      'Then it stays as it is', (tester) async {
    await _pump(tester);

    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(_card)),
    );
    await tester.pumpAndSettle();

    expect(_scaleOf(tester), 1);

    await gesture.up();
  });

  testWidgets('Given a gear with no text, alone in a tab '
      'When a screen reader reads it '
      'Then it is a button of its own size, not the whole screen', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(
      MaterialApp(
        home: Semantics(
          container: true,
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                child: DSPressable(
                  onTap: () {},
                  semanticLabel: 'Settings',
                  child: const SizedBox.square(key: _card, dimension: 48),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final node = tester.getSemantics(find.byKey(_card));

    expect(node.label, 'Settings');
    expect(node.rect.size, const Size.square(48));

    semantics.dispose();
  });
}
