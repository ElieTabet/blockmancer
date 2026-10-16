import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// The clock and the battery, in the strip above the app.
///
/// `light` means light *content* — white icons, for the dark surface every bar
/// in this app sits on.
///
/// All `testWidgets`, even where nothing is pumped: building a DSTheme reaches
/// for google_fonts, and only the widget binding stubs the network it would
/// otherwise go to.
void main() {
  group('The status bar over an app bar', () {
    // Light mode is the one that would go wrong unnoticed: left to itself
    // Material reads the contrast off the scheme's surface, which is pale
    // there, and would put dark icons over a charcoal bar.
    testWidgets(
      'Given the app is in light mode '
      'When a bar is drawn '
      'Then the status bar over it is asked for light content',
      (tester) async => expect(
        DSTheme.instance.lightTheme.appBarTheme.systemOverlayStyle,
        SystemUiOverlayStyle.light,
      ),
    );

    testWidgets(
      'Given the app is in dark mode '
      'When a bar is drawn '
      'Then the status bar over it is asked for light content',
      (tester) async => expect(
        DSTheme.instance.darkTheme.appBarTheme.systemOverlayStyle,
        SystemUiOverlayStyle.light,
      ),
    );

    // What a bar ends up applying is the property that matters, not what the
    // theme holds: an AppBar naming no style of its own has to inherit it.
    testWidgets('Given a bar that names no style of its own '
        'When it is on screen '
        'Then the clock and battery are still drawn light', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: DSTheme.instance.lightTheme,
          home: Scaffold(appBar: AppBar(title: const Text('Home'))),
        ),
      );

      final bar = tester.widget<AppBar>(find.byType(AppBar));
      final inherited = Theme.of(
        tester.element(find.byType(AppBar)),
      ).appBarTheme.systemOverlayStyle;

      expect(bar.systemOverlayStyle ?? inherited, SystemUiOverlayStyle.light);
    });
  });
}
