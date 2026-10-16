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

  // A popup is a route, so it renders as a sibling of the screen that opened it
  // rather than inside it. DSBgContainer forces its own subtree dark because the
  // gradient is charcoal in every theme — without carrying the caller's theme
  // across, an error popup came up light on top of a charcoal login screen
  // whenever the device was in light mode.
  testWidgets('takes its theme from the screen that opened it', (tester) async {
    final darkTheme = DSTheme.instance.darkTheme;

    await tester.pumpWidget(
      MaterialApp(
        theme: DSTheme.instance.lightTheme,
        home: Scaffold(
          body: Theme(
            data: darkTheme,
            child: Builder(
              builder: (context) => TextButton(
                onPressed: () => DSPopup.showError(
                  context,
                  title: 'Sign-in failed',
                  message: 'Incorrect email or password',
                  buttonLabel: 'OK',
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final dialog = tester.widget<Dialog>(find.byType(Dialog));

    expect(dialog.backgroundColor, darkTheme.colorScheme.surface);
    expect(
      dialog.backgroundColor,
      isNot(DSTheme.instance.lightTheme.colorScheme.surface),
    );
  });
}
