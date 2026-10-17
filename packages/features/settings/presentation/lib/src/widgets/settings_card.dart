import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// The raised surface every row sits on, as Home's cards do.
final class SettingsCard extends StatelessWidget {
  const SettingsCard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const .all(DSSpace.medium),
    decoration: ShapeDecoration(
      color: DSColor.card,
      shape: RoundedRectangleBorder(
        borderRadius: .circular(DSCornerRadius.large),
        side: const BorderSide(color: DSColor.cardBorder, width: 2),
      ),
    ),
    child: child,
  );
}

/// A row's name, and what it does when the name alone doesn't say.
final class SettingLabel extends StatelessWidget {
  const SettingLabel({
    required this.title,
    this.color = DSColor.white,
    this.subtitle,
    super.key,
  });

  final Color color;
  final String? subtitle;
  final String title;

  @override
  Widget build(BuildContext context) {
    final subtitle = this.subtitle;

    return Column(
      crossAxisAlignment: .start,
      spacing: DSSpace.xxsmall,
      children: [
        Text(
          title,
          style: TextStyle(color: color, fontSize: 16, fontWeight: .w600),
        ),
        if (subtitle != null)
          Text(
            subtitle,
            style: const TextStyle(color: DSColor.textMuted, fontSize: 13),
          ),
      ],
    );
  }
}
