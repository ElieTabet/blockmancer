import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// The amber call to action of the game's sheets.
final class GameButton extends StatelessWidget {
  const GameButton({required this.label, required this.onPressed, super.key});

  static const _height = 54.0;

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: _height,
    width: double.infinity,
    child: FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: DSColor.accent,
        foregroundColor: DSColor.primary,
        shape: RoundedRectangleBorder(
          borderRadius: .circular(DSCornerRadius.large),
        ),
      ),
      child: Text(
        label,
        style: DSFont.display(const TextStyle(fontSize: 18, fontWeight: .w700)),
      ),
    ),
  );
}
