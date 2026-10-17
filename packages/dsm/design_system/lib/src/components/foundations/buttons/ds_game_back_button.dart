import 'package:design_system/src/components/foundations/buttons/ds_pressable.dart';
import 'package:design_system/src/components/foundations/theme/ds_color.dart';
import 'package:design_system/src/components/foundations/theme/ds_corner_radius.dart';
import 'package:flutter/material.dart';

/// A chunky back arrow on a raised tile, for the game's screens. It shows no
/// text: [semanticLabel] is read to a screen reader only.
final class DSGameBackButton extends StatelessWidget {
  const DSGameBackButton({
    required this.onTap,
    required this.semanticLabel,
    super.key,
  });

  static const _depth = 4.0;
  static const _iconSize = 26.0;
  static const _tileSize = 40.0;

  final VoidCallback? onTap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) => DSPressable(
    onTap: onTap,
    semanticLabel: semanticLabel,
    child: SizedBox.square(
      dimension: kMinInteractiveDimension,
      child: Center(
        child: Container(
          width: _tileSize,
          height: _tileSize,
          decoration: BoxDecoration(
            color: DSColor.sheet,
            borderRadius: .circular(DSCornerRadius.intermediate),
            border: .all(color: DSColor.cardBorder, width: 2),
            // A hard ledge under the tile, so it reads as a key to press.
            boxShadow: const [
              BoxShadow(color: DSColor.primaryDark, offset: Offset(0, _depth)),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: DSColor.accent,
            size: _iconSize,
          ),
        ),
      ),
    ),
  );
}
