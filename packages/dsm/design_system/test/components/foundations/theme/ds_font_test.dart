import 'package:design_system/design_system.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(DSFont.useBundledFonts);

  test(
    'every typeface the app draws ships with it, so a launch without a network still shows them',
    () async {
      // Given: the theme's text styles and the display face, as the screens use them
      DSTheme.instance.lightTheme;
      DSFont.display(const TextStyle(fontWeight: FontWeight.w600));
      DSFont.display(const TextStyle(fontWeight: FontWeight.w700));

      // When / Then: each one loads from the app's own files
      await expectLater(GoogleFonts.pendingFonts(), completes);
    },
  );

  test('the bundled typefaces credit their licences', () async {
    // Given / When
    final packages = await LicenseRegistry.licenses
        .expand((entry) => entry.packages)
        .toList();

    // Then
    expect(
      packages,
      containsAll(<String>[DSFont.family, DSFont.displayFamily]),
    );
  });

  test('turning bundling on stops any download', () {
    // Given / When / Then
    expect(GoogleFonts.config.allowRuntimeFetching, isFalse);
  });
}
