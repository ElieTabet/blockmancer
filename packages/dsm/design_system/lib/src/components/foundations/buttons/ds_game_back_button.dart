import 'package:design_system/src/components/foundations/buttons/ds_game_icon_button.dart';
import 'package:flutter/material.dart';

/// [DSGameIconButton] with a back arrow, for leaving a screen that was pushed.
final class DSGameBackButton extends StatelessWidget {
  const DSGameBackButton({
    required this.onTap,
    required this.semanticLabel,
    super.key,
  });

  final VoidCallback? onTap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) => DSGameIconButton(
    icon: Icons.arrow_back_rounded,
    onTap: onTap,
    semanticLabel: semanticLabel,
  );
}
