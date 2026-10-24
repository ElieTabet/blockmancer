import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

/// The app's typefaces, by their Google Fonts family names. The one place they
/// are named: the theme builds every text style from [family].
final class DSFont {
  static const _licences = {
    displayFamily: 'packages/design_system/assets/fonts/Fredoka-OFL.txt',
    family: 'packages/design_system/assets/fonts/DMSans-OFL.txt',
  };

  /// Titles and scores.
  static const displayFamily = 'Fredoka';

  static const family = 'DM Sans';

  static TextStyle display(TextStyle? style) =>
      GoogleFonts.getFont(displayFamily, textStyle: style);

  /// Loads [display]'s bold from its bundled file, which happens on first use
  /// otherwise: text drawn before it lands shows in a fallback font for a frame.
  static Future<void> preloadDisplayBold() => GoogleFonts.pendingFonts([
    GoogleFonts.getFont(displayFamily, fontWeight: FontWeight.w700),
  ]);

  /// Draws every typeface from the files bundled in `assets/fonts/` and never
  /// downloads one: a download fails offline and behind TLS-inspecting
  /// networks. Call once at boot, before the first frame. A weight the theme
  /// starts using must be added there too — the font test catches a missing one.
  static void useBundledFonts() {
    GoogleFonts.config.allowRuntimeFetching = false;
    LicenseRegistry.addLicense(_licenceEntries);
  }

  static Stream<LicenseEntry> _licenceEntries() async* {
    for (final MapEntry(key: family, value: path) in _licences.entries) {
      yield LicenseEntryWithLineBreaks([
        family,
      ], await rootBundle.loadString(path));
    }
  }
}
