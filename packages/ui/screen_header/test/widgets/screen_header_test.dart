import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l10n_application/l10n_application.dart';
import 'package:screen_header/screen_header.dart';

import '../fake_session.dart';

Future<void> _pump(
  WidgetTester tester, {
  String title = 'News',
  String? organization,
  Widget? subtitle,
  bool showSessionAction = true,
  bool? signedIn = false,
  double textScale = 1,
  ScrollController? controller,
}) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: fakeSession(organization: organization, signedIn: signedIn),
      child: TranslationProvider(
        child: MaterialApp(
          theme: DSTheme.instance.lightTheme,
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
            child: Scaffold(
              body: Column(
                children: [
                  ScreenHeader(
                    title: title,
                    subtitle: subtitle,
                    showSessionAction: showSessionAction,
                  ),
                  Expanded(
                    child: ListView(
                      controller: controller,
                      children: const [SizedBox(height: 2000)],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('What the band says', () {
    testWidgets('Given a screen that names itself '
        'When its header is drawn '
        'Then the name is the first thing on it', (tester) async {
      await _pump(tester, title: 'Home');

      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('Given a screen that also names the organization '
        'When its header is drawn '
        'Then both lines are on it', (tester) async {
      await _pump(
        tester,
        title: 'News',
        organization: 'Acme Club',
        subtitle: const OrganizationLine(),
      );

      expect(find.text('News'), findsOneWidget);
      expect(find.text('Acme Club'), findsOneWidget);
    });

    // A first launch with no settings fetched yet: the line is asked for, but
    // there is no name to put on it.
    testWidgets(
      'Given a screen that names the organization before the name is known '
      'When its header is drawn '
      'Then the band has no second line',
      (tester) async {
        await _pump(tester, title: 'News', subtitle: const OrganizationLine());

        // The title and the button's label, as with no subtitle at all.
        expect(find.byType(Text), findsNWidgets(2));
      },
    );

    // A screen with nothing to say on the second line gets no second line —
    // the header never fills it in on the screen's behalf.
    testWidgets('Given a screen with only a name '
        'When its header is drawn '
        'Then nothing stands in for the missing line', (tester) async {
      await _pump(tester, title: 'News', subtitle: null);

      // The title and the button's label. A subtitle would make a third.
      expect(find.byType(Text), findsNWidgets(2));
    });
  });

  group('The session control', () {
    testWidgets('Given a main page '
        'When a guest looks at it '
        'Then the header offers a way in', (tester) async {
      await _pump(tester, signedIn: false);

      expect(find.byType(SessionActionButton), findsOneWidget);
      expect(find.text('Sign in'), findsOneWidget);
    });

    // Sign-out lives on the account page. Three copies of it across the tabs
    // was three places to answer one question, on two screens a member is only
    // passing through.
    testWidgets('Given a main page '
        'When a signed-in member looks at it '
        'Then the band offers nothing at the end of it', (tester) async {
      await _pump(tester, signedIn: true);

      expect(find.byType(SessionActionButton), findsNothing);
      expect(find.text('Sign out'), findsNothing);
      expect(find.text('Sign in'), findsNothing);
    });

    // Never the wrong verb for a frame, which is the reason nothing is drawn
    // until the session is known.
    testWidgets('Given the session is not known yet '
        'When the header is drawn '
        'Then the band offers nothing', (tester) async {
      await _pump(tester, signedIn: null);

      expect(find.byType(SessionActionButton), findsNothing);
    });

    // A screen reached from a main page already has a way back to one that
    // offers it, so it asks for a band with nothing on the right.
    testWidgets('Given a screen that does not want a session control '
        'When its header is drawn '
        'Then there is none on it', (tester) async {
      await _pump(tester, showSessionAction: false);

      expect(find.byType(SessionActionButton), findsNothing);
      expect(find.text('Sign in'), findsNothing);
    });
  });

  group('How the band holds together', () {
    // The band's height comes from its content. A Row that stretched its
    // children would hand the button an unbounded height instead, which is the
    // failure that leaves a whole widget unpainted.
    testWidgets('Given a header with a session control '
        'When it is laid out '
        'Then the control keeps its own height rather than filling the band', (
      tester,
    ) async {
      await _pump(
        tester,
        organization: 'Acme Club',
        subtitle: const OrganizationLine(),
      );

      expect(
        tester.getSize(find.byType(DSPrimaryButton)).height,
        lessThan(tester.getSize(find.byType(ScreenHeader)).height),
      );
      expect(tester.takeException(), isNull);
    });

    // The point of putting the band outside the scroll view: scrolling must
    // not take the title or the session control anywhere.
    testWidgets('Given a member who has scrolled down the screen '
        'When they look back at the top '
        'Then the band has not moved or changed', (tester) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);

      await _pump(
        tester,
        organization: 'Acme Club',
        subtitle: const OrganizationLine(),
        controller: controller,
      );

      final before = tester.getRect(find.byType(ScreenHeader));

      controller.jumpTo(500);
      await tester.pumpAndSettle();

      expect(tester.getRect(find.byType(ScreenHeader)), before);
      expect(find.text('Sign in'), findsOneWidget);
      expect(find.text('News'), findsOneWidget);
      expect(find.text('Acme Club'), findsOneWidget);
    });

    testWidgets('Given a member who has scaled text up '
        'When the header is drawn at twice the size '
        'Then nothing overflows', (tester) async {
      await _pump(
        tester,
        title: 'Home',
        organization: 'Acme Club',
        subtitle: const OrganizationLine(),
        textScale: 2,
      );

      expect(tester.takeException(), isNull);
    });
  });
}
