import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// The amber call to action of the game's sheets; dimmed, and deaf to taps,
/// when [onPressed] is null.
final class GameButton extends StatelessWidget {
  const GameButton({
    required this.label,
    required this.onPressed,
    this.icon,
    super.key,
  });

  static const _disabledOpacity = 0.4;
  static const _height = 54.0;

  /// Before the label, when it helps to say what the tap costs.
  final IconData? icon;
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
      child: Row(
        mainAxisSize: .min,
        spacing: DSSpace.xsmall,
        children: [
          if (icon case final icon?)
            Icon(icon, color: DSColor.primary, size: 22),
          Flexible(
            child: Text(
              label,
              textAlign: .center,
              style: DSFont.display(
                const TextStyle(
                  color: DSColor.primary,
                  fontSize: 18,
                  fontWeight: .w700,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
