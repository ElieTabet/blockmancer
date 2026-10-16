import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:screen_header/src/widgets/header_session_action.dart';

/// The band at the top of every main screen: what the screen is, whose
/// organization it belongs to, and — for a guest — the way in.
///
/// Fixed. It sits *above* a screen's scrolling content rather than inside it,
/// so it neither scrolls away nor resizes — the title and the session control
/// are in the same place at every scroll position. A sign-in a member has to
/// scroll back up for is one nobody finds.
///
/// A plain box, not a sliver: place it above the `CustomScrollView`, not in its
/// `slivers`.
final class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    required this.title,
    this.showSessionAction = true,
    this.subtitle,
    super.key,
  });

  /// Whether a guest is offered the way in at the end of the band.
  ///
  /// True by default because every screen that has a header today is a main
  /// page, and a guest has to be able to sign in from all of them. A screen
  /// reached *from* one of those — a detail, a form — passes false: it already
  /// has a way back to a screen that offers it. So does the account page, which
  /// carries its own.
  ///
  /// It has no bearing on a signed-in member, who is offered nothing here
  /// either way — see [HeaderSessionAction].
  final bool showSessionAction;

  /// Optional, and the screen's own — usually `OrganizationLine`. There is no
  /// default here: a header that filled its second line in on its own would be
  /// a surprise on the first screen that wanted only a title.
  ///
  /// A widget rather than a string so the line can watch what it shows; the
  /// band styles it, and the line brings its own gap.
  final Widget? subtitle;

  final String title;

  @override
  Widget build(BuildContext context) {
    final subtitle = this.subtitle;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      color: DSColor.charcoal,
      padding: EdgeInsets.fromLTRB(
        DSSpace.medium,
        // The band runs under the status bar, so its own padding is what keeps
        // the title clear of the clock.
        MediaQuery.paddingOf(context).top + DSSpace.small,
        DSSpace.medium,
        DSSpace.medium,
      ),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: textTheme.headlineMedium?.copyWith(
                    color: DSColor.white,
                    fontWeight: .w700,
                  ),
                ),
                if (subtitle != null)
                  DefaultTextStyle.merge(
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: DSColor.slateGray,
                    ),
                    child: subtitle,
                  ),
              ],
            ),
          ),
          // The row's default cross-axis alignment is what keeps the control
          // its own size. Stretching it would hand it the band's height —
          // unbounded here, since the band is sized by its content.
          if (showSessionAction) const HeaderSessionAction(),
        ],
      ),
    );
  }
}
