import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

/// The app's typefaces, by their Google Fonts family names. The one place they
/// are named: the theme builds every text style from [family].
final class DSFont {
  /// Titles and scores.
  static const displayFamily = 'Fredoka';
  static const family = 'DM Sans';

  static TextStyle display(TextStyle? style) =>
      GoogleFonts.getFont(displayFamily, textStyle: style);
}
