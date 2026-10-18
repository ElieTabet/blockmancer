import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:l10n_application/l10n_application.dart';

enum SettingsSectionKind { game, help, privacy, purchases, testers }

/// A section: its name in small capitals, then its rows on one card.
final class SettingsSection extends StatelessWidget {
  const SettingsSection({required this.kind, required this.rows, super.key});

  final SettingsSectionKind kind;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    final sections = context.t.settings.sections;
    final title = switch (kind) {
      .game => sections.game,
      .help => sections.help,
      .privacy => sections.privacy,
      .purchases => sections.purchases,
      .testers => sections.testers,
    };

    return Column(
      crossAxisAlignment: .stretch,
      spacing: DSSpace.xsmall,
      children: [
        Padding(
          padding: const .symmetric(horizontal: DSSpace.medium),
          child: Semantics(
            header: true,
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(
                color: DSColor.textMuted,
                fontSize: 13,
                fontWeight: .w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
        SettingsGroup(rows: rows),
      ],
    );
  }
}

/// One card holding [rows], a hairline between each two.
final class SettingsGroup extends StatelessWidget {
  const SettingsGroup({required this.rows, super.key});

  final List<Widget> rows;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: ShapeDecoration(
      color: DSColor.card,
      shape: RoundedRectangleBorder(
        borderRadius: .circular(DSCornerRadius.large),
        side: const BorderSide(color: DSColor.cardBorder),
      ),
    ),
    child: ClipRRect(
      borderRadius: .circular(DSCornerRadius.large),
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          for (var index = 0; index < rows.length; index++) ...[
            if (index > 0) const SettingsDivider(),
            rows[index],
          ],
        ],
      ),
    ),
  );
}

/// The hairline between two rows, inset like the rows' titles.
final class SettingsDivider extends StatelessWidget {
  const SettingsDivider({super.key});

  @override
  Widget build(BuildContext context) => Divider(
    color: DSColor.cardBorder,
    height: 1,
    indent: DSSpace.medium,
    thickness: 1 / MediaQuery.devicePixelRatioOf(context),
  );
}

/// Where a row leads: a screen of the app, or out of it (the store, mail,
/// the web).
enum SettingsRowLink { inApp, outside }

/// A row: its title, and what sits at its end. At least 52 high, taller when
/// a large text size wraps the title.
final class SettingsRow extends StatelessWidget {
  const SettingsRow({
    required this.title,
    this.link,
    this.onTap,
    this.semanticLabel,
    this.titleColor = DSColor.white,
    this.trailing,
    super.key,
  });

  static const _minHeight = 52.0;

  /// Shows "›" or the leave-the-app icon at the end, unless [trailing] is
  /// given.
  final SettingsRowLink? link;

  /// Null for a row that only says something.
  final VoidCallback? onTap;

  /// What a screen reader says for the row; its title unless given.
  final String? semanticLabel;
  final String title;
  final Color titleColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final trailing =
        this.trailing ??
        switch (link) {
          .inApp => const Icon(
            Icons.chevron_right_rounded,
            color: DSColor.textMuted,
          ),
          .outside => const Icon(
            Icons.open_in_new_rounded,
            color: DSColor.textMuted,
            size: 20,
          ),
          null => null,
        };
    final content = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: _minHeight),
      child: Padding(
        padding: const .symmetric(
          horizontal: DSSpace.medium,
          vertical: DSSpace.small,
        ),
        child: Row(
          spacing: DSSpace.small,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 16,
                  fontWeight: .w600,
                ),
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
    final onTap = this.onTap;

    if (onTap == null) {
      return Semantics(
        label: semanticLabel ?? title,
        child: ExcludeSemantics(child: content),
      );
    }

    return DSPressable(
      onTap: onTap,
      pressedScale: 0.98,
      semanticHint: link == .outside ? context.t.settings.opensOutside : null,
      semanticLabel: semanticLabel ?? title,
      child: ExcludeSemantics(child: content),
    );
  }
}
