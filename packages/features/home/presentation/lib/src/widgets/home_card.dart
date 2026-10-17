import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// A raised card edged in [accent], opening a run when tapped.
final class HomeCard extends StatelessWidget {
  const HomeCard({
    required this.accent,
    required this.child,
    required this.onTap,
    super.key,
  });

  final Color accent;
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => DSPressable(
    onTap: onTap,
    child: Container(
      padding: const .all(DSSpace.medium),
      decoration: ShapeDecoration(
        color: DSColor.card,
        shape: RoundedRectangleBorder(
          borderRadius: .circular(DSCornerRadius.large),
          side: BorderSide(color: accent, width: 2),
        ),
      ),
      child: child,
    ),
  );
}
