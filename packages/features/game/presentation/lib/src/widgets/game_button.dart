import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// The amber call to action of the game's sheets; dimmed, and deaf to taps,
/// when [onPressed] is null.
final class GameButton extends StatelessWidget {
  const GameButton({required this.label, required this.onPressed, super.key});

  static const _disabledOpacity = 0.4;
  static const _height = 54.0;

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => DSPressable(
    onTap: onPressed,
    child: Container(
      height: _height,
      width: double.infinity,
      alignment: .center,
      decoration: BoxDecoration(
        color: onPressed == null
            ? DSColor.accent.withValues(alpha: _disabledOpacity)
            : DSColor.accent,
        borderRadius: .circular(DSCornerRadius.large),
      ),
      child: Text(
        label,
        style: DSFont.display(
          const TextStyle(
            color: DSColor.primary,
            fontSize: 18,
            fontWeight: .w700,
          ),
        ),
      ),
    ),
  );
}
