import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// [points] grouped the reader's way: 12,345 in English, 12 345 in French.
String pointsText(BuildContext context, int points) =>
    NumberFormat.decimalPattern(
      Localizations.localeOf(context).toLanguageTag(),
    ).format(points);
