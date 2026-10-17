import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(
  WidgetTester tester, {
  required VoidCallback onPress,
  VoidCallback? onTap,
}) => tester.pumpWidget(
  DSPressFeedback(
    onPress: onPress,
    child: MaterialApp(
      home: Center(
        child: DSPressable(
          onTap: onTap,
          child: const SizedBox.square(dimension: 100),
        ),
      ),
    ),
  ),
);

void main() {
  testWidgets('Given the app plays a sound on every tap '
      'When the player taps a card '
      'Then the sound plays before the card acts', (tester) async {
    final heard = <String>[];

    await _pump(
      tester,
      onPress: () => heard.add('sound'),
      onTap: () => heard.add('action'),
    );
    await tester.tap(find.byType(DSPressable));

    expect(heard, ['sound', 'action']);
  });

  testWidgets('Given the app plays a sound on every tap '
      'When the player taps a card with nothing to do '
      'Then nothing plays', (tester) async {
    var sounds = 0;

    await _pump(tester, onPress: () => sounds++);
    await tester.tap(find.byType(DSPressable), warnIfMissed: false);

    expect(sounds, 0);
  });

  testWidgets('Given the app plays a sound on every tap '
      'When the player lifts the finger off the card before letting go '
      'Then nothing plays', (tester) async {
    var sounds = 0;

    await _pump(tester, onPress: () => sounds++, onTap: () {});
    final finger = await tester.startGesture(
      tester.getCenter(find.byType(DSPressable)),
    );
    await finger.moveBy(const Offset(0, 300));
    await finger.up();
    await tester.pumpAndSettle();

    expect(sounds, 0);
  });
}
