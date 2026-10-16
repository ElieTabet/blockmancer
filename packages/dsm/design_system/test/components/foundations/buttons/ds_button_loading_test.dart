import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A button sized by its own content, so what is measured is the button's
/// intrinsic width and not a box imposed on it.
Future<double> _widthOf(WidgetTester tester, {required bool isLoading}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: DSTheme.instance.lightTheme,
      home: Scaffold(
        body: Center(
          child: Builder(
            builder: (context) => DSPrimaryButton.small(
              context: context,
              title: 'Sign out',
              isLoading: isLoading,
              onPressed: () {},
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();

  return tester.getSize(find.byType(DSPrimaryButton)).width;
}

/// Every size, built the same way, so the spinner can be measured against the
/// button that has to contain it.
Future<void> _pumpSized(
  WidgetTester tester,
  DSPrimaryButton Function(BuildContext context) build,
) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: DSTheme.instance.lightTheme,
      home: Scaffold(
        body: Center(child: Builder(builder: build)),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  group('A spinner has to fit the button it is in', () {
    // 8pt of vertical padding leaves a small button 16pt of room. A fixed 20pt
    // ring overflows it, which is what a spinner spilling past a pill looks
    // like.
    testWidgets('Given a button of any size '
        'When it is loading '
        'Then the spinner fits inside it', (tester) async {
      for (final build in [
        (BuildContext context) => DSPrimaryButton.small(
          context: context,
          title: 'Sign out',
          isLoading: true,
          onPressed: () {},
        ),
        (BuildContext context) => DSPrimaryButton.medium(
          context: context,
          title: 'Sign out',
          isLoading: true,
          onPressed: () {},
        ),
        (BuildContext context) => DSPrimaryButton.large(
          context: context,
          title: 'Sign out',
          isLoading: true,
          onPressed: () {},
        ),
      ]) {
        await _pumpSized(tester, build);

        final button = tester.getSize(find.byType(DSPrimaryButton));
        final spinner = tester.getSize(find.byType(CircularProgressIndicator));

        expect(spinner.height, lessThan(button.height));
        expect(spinner.width, lessThan(button.width));
      }
    });
  });

  group('A button that is working', () {
    testWidgets(
      'Given a button with a label '
      'When it starts loading '
      'Then it keeps the width it had, rather than collapsing to the spinner',
      (tester) async {
        final resting = await _widthOf(tester, isLoading: false);
        final loading = await _widthOf(tester, isLoading: true);

        expect(loading, resting);
      },
    );

    testWidgets('Given a button that is loading '
        'When it is drawn '
        'Then the spinner is inside it and the label is not showing', (
      tester,
    ) async {
      await _widthOf(tester, isLoading: true);

      expect(
        find.descendant(
          of: find.byType(DSPrimaryButton),
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );
      // Still in the tree — that is what holds the width — but painted at
      // zero opacity.
      expect(
        tester
            .widget<Opacity>(
              find.ancestor(
                of: find.text('Sign out'),
                matching: find.byType(Opacity),
              ),
            )
            .opacity,
        0.0,
      );
    });

    testWidgets('Given a button that is loading '
        'When it is pressed '
        'Then nothing is triggered, so the work cannot be started twice', (
      tester,
    ) async {
      var presses = 0;

      await tester.pumpWidget(
        MaterialApp(
          theme: DSTheme.instance.lightTheme,
          home: Scaffold(
            body: Builder(
              builder: (context) => DSPrimaryButton.small(
                context: context,
                title: 'Sign out',
                isLoading: true,
                onPressed: () => presses++,
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(DSPrimaryButton), warnIfMissed: false);
      await tester.pump();

      expect(presses, 0);
    });
  });
}
