import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('it is the charcoal band with the design system back button', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: DSTheme.instance.lightTheme,
        home: const Scaffold(appBar: DSAppBar(title: Text('Title'))),
      ),
    );

    final bar = tester.widget<AppBar>(find.byType(AppBar));

    expect(bar.backgroundColor, DSColor.charcoal);
    expect(bar.foregroundColor, DSColor.white);
    expect(find.byType(DSBackButton), findsOneWidget);
    expect(find.byType(BackButton), findsNothing);
    expect(find.text('Title'), findsOneWidget);
  });

  testWidgets('the status bar icons stay light over it', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: DSTheme.instance.lightTheme,
        home: const Scaffold(appBar: DSAppBar()),
      ),
    );

    final region = tester.widget<AnnotatedRegion<SystemUiOverlayStyle>>(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.byType(AnnotatedRegion<SystemUiOverlayStyle>),
      ),
    );

    expect(region.value.statusBarIconBrightness, Brightness.light);
  });
}
