import 'dart:async';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:screen_header/src/widgets/session_action_button.dart';
import 'package:shared_domain/shared_domain.dart';

import '../fake_session.dart';

/// The control alone — the header around it, and the screen around that, are
/// irrelevant to every question here.
Future<void> _pump(
  WidgetTester tester, {
  bool? signedIn = false,
  FakeLogout? logout,
  FakeScreenHeaderRouting? routing,
  DSButtonSize size = DSButtonSize.medium,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: fakeSession(
        signedIn: signedIn,
        logout: logout,
        routing: routing,
      ),
      child: TranslationProvider(
        child: MaterialApp(
          theme: DSTheme.instance.lightTheme,
          home: Scaffold(body: SessionActionButton(size: size)),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// The confirm dialog's own "Sign out" — the control carries the same word, and
/// the dialog is pushed above it.
Finder _confirmAction() => find.text('Sign out').last;

void main() {
  group('Which session action the header offers', () {
    testWidgets('Given a guest browsing public titles '
        'When the header is drawn '
        'Then it offers a way in', (tester) async {
      await _pump(tester, signedIn: false);

      expect(find.text('Sign in'), findsOneWidget);
      expect(find.text('Sign out'), findsNothing);
    });

    testWidgets('Given a signed-in member '
        'When the header is drawn '
        'Then it offers a way out', (tester) async {
      await _pump(tester, signedIn: true);

      expect(find.text('Sign out'), findsOneWidget);
      expect(find.text('Sign in'), findsNothing);
    });

    // Otherwise the bar shows the wrong verb for a frame and then swaps it,
    // which reads as the app changing its mind about who you are.
    testWidgets('Given the session is not known yet '
        'When the header is drawn '
        'Then it offers neither, rather than guessing', (tester) async {
      await _pump(tester, signedIn: null);

      expect(find.text('Sign in'), findsNothing);
      expect(find.text('Sign out'), findsNothing);
    });
  });

  group('Signing in from the header', () {
    testWidgets('Given a guest '
        'When they press sign in '
        'Then the app navigates to login', (tester) async {
      final routing = FakeScreenHeaderRouting();

      await _pump(tester, signedIn: false, routing: routing);
      await tester.tap(find.text('Sign in'));
      await tester.pumpAndSettle();

      expect(routing.signInRequests, 1);
    });
  });

  group('Signing out', () {
    testWidgets('Given a signed-in member '
        'When they press sign out '
        'Then nothing happens until they confirm', (tester) async {
      final logout = FakeLogout();

      await _pump(tester, signedIn: true, logout: logout);
      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();

      expect(find.text('Sign out?'), findsOneWidget);
      expect(logout.calls, 0);
    });

    testWidgets('Given the confirmation is showing '
        'When the member decides to stay '
        'Then they are not signed out', (tester) async {
      final logout = FakeLogout();

      await _pump(tester, signedIn: true, logout: logout);
      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Stay signed in'));
      await tester.pumpAndSettle();

      expect(logout.calls, 0);
    });

    testWidgets('Given the confirmation is showing '
        'When the member confirms '
        'Then the session is ended', (tester) async {
      final logout = FakeLogout();

      await _pump(tester, signedIn: true, logout: logout);
      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();
      await tester.tap(_confirmAction());
      await tester.pumpAndSettle();

      expect(logout.calls, 1);
    });

    // A second tap while the first call is still out would sign out twice — and
    // the second would answer "already signed out" on a member who is mid-exit.
    testWidgets('Given a sign-out already in flight '
        'When the member presses again '
        'Then it is not sent twice', (tester) async {
      final gate = Completer<void>();
      final logout = FakeLogout(gate: gate);

      await _pump(tester, signedIn: true, logout: logout);
      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();
      await tester.tap(_confirmAction());
      await tester.pump();

      await tester.tap(find.byType(DSPrimaryButton), warnIfMissed: false);
      await tester.pump();

      expect(logout.calls, 1);

      gate.complete();
      await tester.pumpAndSettle();
    });
  });

  group('When signing out fails', () {
    testWidgets('Given no connection '
        'When the sign-out fails '
        'Then the member is told why and stays where they are', (tester) async {
      final logout = FakeLogout(failure: const AuthError.noConnection());

      await _pump(tester, signedIn: true, logout: logout);
      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();
      await tester.tap(_confirmAction());
      await tester.pumpAndSettle();

      expect(find.text("Couldn't sign out"), findsOneWidget);
      expect(
        find.text(
          'No internet connection. Check your connection and try again.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('Given a server fault '
        'When the sign-out fails '
        'Then the generic failure is shown '
        'and the control is usable again', (tester) async {
      final logout = FakeLogout(failure: const AuthError.unexpected());

      await _pump(tester, signedIn: true, logout: logout);
      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();
      await tester.tap(_confirmAction());
      await tester.pumpAndSettle();

      expect(
        find.text('Something went wrong signing you out. Please try again.'),
        findsOneWidget,
      );

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.text('Sign out'), findsOneWidget);
    });
  });

  group('How the sign-out control is presented', () {
    testWidgets('Given a signed-in member '
        'When the header is drawn '
        'Then leaving is offered as the primary action', (tester) async {
      await _pump(tester, signedIn: true);

      expect(find.byType(DSPrimaryButton), findsOneWidget);
    });

    // In the button, not beside it: a spinner somewhere else would leave the
    // control looking pressable while the sign-out is already on its way.
    testWidgets('Given a sign-out in flight '
        'When the member looks at the control '
        'Then the spinner is inside the button, where the label was', (
      tester,
    ) async {
      final gate = Completer<void>();

      await _pump(tester, signedIn: true, logout: FakeLogout(gate: gate));
      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();
      await tester.tap(_confirmAction());
      await tester.pump();

      expect(
        find.descendant(
          of: find.byType(DSPrimaryButton),
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );
      gate.complete();
      await tester.pumpAndSettle();
    });

    testWidgets('Given a guest '
        'When the header is drawn '
        'Then getting in is offered the same way, not as a lesser control', (
      tester,
    ) async {
      await _pump(tester, signedIn: false);

      expect(find.byType(DSPrimaryButton), findsOneWidget);
    });

    // A control that shrinks the instant it is pressed reads as darting away
    // from the finger that pressed it.
    testWidgets('Given a sign-out in flight '
        'When the label becomes a spinner '
        'Then the button is exactly as wide as it was', (tester) async {
      final gate = Completer<void>();

      await _pump(tester, signedIn: true, logout: FakeLogout(gate: gate));
      final resting = tester.getSize(find.byType(DSPrimaryButton)).width;

      await tester.tap(find.text('Sign out'));
      await tester.pumpAndSettle();
      await tester.tap(_confirmAction());
      await tester.pump();

      expect(tester.getSize(find.byType(DSPrimaryButton)).width, resting);

      gate.complete();
      await tester.pumpAndSettle();
    });
  });

  // The account page stands the same control full-width at the large size.
  //
  // These assert the verb, not the pixels, and deliberately so: DSButton only
  // applies its height in the Cupertino branch — `_buildMaterial` ignores
  // `_height` — so on Android every size renders at the same 40.0. It also
  // branches on `Platform.isIOS` rather than `defaultTargetPlatform`, which a
  // test cannot override. Sizing is therefore untestable here until the design
  // system is fixed; what is testable is that the parameter does not disturb
  // which control is offered.
  group('What the control offers at the large size', () {
    testWidgets('Given a guest '
        'When the control is drawn large '
        'Then it still offers a way in', (tester) async {
      await _pump(tester, signedIn: false, size: DSButtonSize.large);

      expect(find.text('Sign in'), findsOneWidget);
      expect(find.text('Sign out'), findsNothing);
    });

    testWidgets('Given a signed-in member '
        'When the control is drawn large '
        'Then it still offers a way out', (tester) async {
      await _pump(tester, signedIn: true, size: DSButtonSize.large);

      expect(find.text('Sign out'), findsOneWidget);
      expect(find.text('Sign in'), findsNothing);
    });
  });
}
