import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// A sheet's main action, in the accent colour.
final class SheetButton extends StatelessWidget {
  const SheetButton({required this.label, required this.onTap, super.key});

  static const _height = 54.0;

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const .only(top: DSSpace.xsmall),
    child: DSPressable(
      onTap: onTap,
      child: Container(
        height: _height,
        alignment: .center,
        decoration: BoxDecoration(
          color: DSColor.accent,
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
    ),
  );
}
