import 'package:flutter/widgets.dart';

/// Whether the screen is short enough that the fixed rows around the board
/// must give up height for it (4-inch iPhones, small Android phones).
bool isCompactScreen(BuildContext context) =>
    MediaQuery.sizeOf(context).height < _compactHeight;

const _compactHeight = 700.0;
