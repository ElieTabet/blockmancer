import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps a screen with a button that opens [onOpen] and returns the button
/// finder. Tap it to show the popup.
Future<void> _pumpOpener(
  WidgetTester tester,
  void Function(BuildContext context) onOpen,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => onOpen(context),
            child: const Text('open'),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('DSPopup.showConfirm', () {
    testWidgets('renders the title and message', (tester) async {
      await _pumpOpener(
        tester,
        (context) => DSPopup.showConfirm(
          context,
          title: 'Log out?',
          message: 'You will need to sign in again.',
          confirmLabel: 'Log out',
          cancelLabel: 'Cancel',
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Log out?'), findsOneWidget);
      expect(find.text('You will need to sign in again.'), findsOneWidget);
    });

    testWidgets('resolves true when the confirm button is tapped', (
      tester,
    ) async {
      late Future<bool> result;

      await _pumpOpener(
        tester,
        (context) => result = DSPopup.showConfirm(
          context,
          title: 'Log out?',
          message: 'm',
          confirmLabel: 'Log out',
          cancelLabel: 'Cancel',
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Log out'));
      await tester.pumpAndSettle();

      expect(await result, isTrue);
    });

    testWidgets('resolves false when the cancel button is tapped', (
      tester,
    ) async {
      late Future<bool> result;

      await _pumpOpener(
        tester,
        (context) => result = DSPopup.showConfirm(
          context,
          title: 'Log out?',
          message: 'm',
          confirmLabel: 'Log out',
          cancelLabel: 'Cancel',
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(await result, isFalse);
    });
  });

  group('DSPopup.showError', () {
    testWidgets('renders the title/message and dismisses on the button', (
      tester,
    ) async {
      await _pumpOpener(
        tester,
        (context) => DSPopup.showError(
          context,
          title: 'Something went wrong',
          message: 'Please try again.',
          buttonLabel: 'OK',
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Please try again.'), findsOneWidget);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.text('Something went wrong'), findsNothing);
    });
  });

  group('DSPopup.showInfo', () {
    testWidgets('renders the title/message with a check, and dismisses on the '
        'button', (tester) async {
      await _pumpOpener(
        tester,
        (context) => DSPopup.showInfo(
          context,
          title: 'Purchases restored',
          message: 'Ads are removed on this device.',
          buttonLabel: 'OK',
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Purchases restored'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.text('Purchases restored'), findsNothing);
    });
  });

  // The game is dark by design, so the popup keeps the game's palette even
  // under a light theme rather than coming up as a white system dialog.
  testWidgets('a confirmation looks like the game, whatever the theme', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: DSTheme.instance.lightTheme,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => DSPopup.showConfirm(
                context,
                title: 'Reset progress?',
                message: 'Your bests and saved run will be gone.',
                confirmLabel: 'Reset',
                cancelLabel: 'Cancel',
                isDestructive: true,
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final dialog = tester.widget<Dialog>(find.byType(Dialog));
    final shape = dialog.shape! as RoundedRectangleBorder;

    expect(dialog.backgroundColor, DSColor.card);
    expect(shape.side.color, DSColor.cardBorder);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            (widget.decoration as BoxDecoration?)?.color == DSColor.negative,
      ),
      findsOneWidget,
    );
  });
}
