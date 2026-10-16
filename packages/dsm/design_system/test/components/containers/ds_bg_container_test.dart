import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('supplies the dark scheme to its subtree even in light mode', (
    tester,
  ) async {
    late ColorScheme inside;
    late TextSelectionThemeData selectionInside;

    await tester.pumpWidget(
      MaterialApp(
        theme: DSTheme.instance.lightTheme,
        home: DSBgContainer(
          child: Builder(
            builder: (context) {
              inside = Theme.of(context).colorScheme;
              selectionInside = Theme.of(context).textSelectionTheme;
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    // The gradient is charcoal in every theme, so light-surface roles would
    // render invisibly on it: onSurface would be charcoal-on-charcoal.
    expect(inside.brightness, Brightness.dark);
    expect(inside.onSurface, DSColor.white);

    // Material would otherwise default the caret to `primary` — a dark brand
    // colour on charcoal, effectively invisible.
    expect(selectionInside.cursorColor, DSColor.white);
  });
}
