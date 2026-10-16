import 'package:design_system/src/components/foundations/buttons/ds_error_button.dart';
import 'package:design_system/src/components/foundations/buttons/ds_primary_button.dart';
import 'package:design_system/src/components/foundations/buttons/ds_secondary_button.dart';
import 'package:design_system/src/components/foundations/theme/ds_corner_radius.dart';
import 'package:design_system/src/components/foundations/theme/ds_space.dart';
import 'package:design_system/src/components/foundations/theme/ds_vertical_space.dart';
import 'package:flutter/material.dart';

/// Branded, reusable popups. Holds no copy — callers pass already-localized
/// strings. Two semantic entry points:
/// - [showError] for an error/acknowledge popup (single button).
/// - [showConfirm] for an interrogative confirm/cancel popup (returns the
///   user's choice as a `Future<bool>`; barrier/back dismissal resolves false).
abstract final class DSPopup {
  const DSPopup._();

  // A gentle overshoot ("bump") — a softened Curves.easeOutBack (which
  // overshoots ~10%); the lower final control point keeps the bump small.
  static const _entryCurve = Cubic(0.175, 0.885, 0.32, 1.1);
  static const _reverseTransitionDuration = Duration(milliseconds: 550);
  static const _transitionDuration = Duration(milliseconds: 400);

  static Future<void> showError(
    BuildContext context, {
    required String title,
    required String message,
    required String buttonLabel,
  }) => _show<void>(
    context,
    (context) => _DSPopupBody(
      icon: Icons.error_outline,
      iconColor: Theme.of(context).colorScheme.error,
      title: title,
      message: message,
      actions: [
        DSPrimaryButton.large(
          context: context,
          title: buttonLabel,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );

  static Future<bool> showConfirm(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required String cancelLabel,
    bool isDestructive = false,
  }) async {
    final confirmed = await _show<bool>(
      context,
      (context) => _DSPopupBody(
        title: title,
        message: message,
        actions: [
          if (isDestructive)
            DSErrorButton.large(
              context: context,
              title: confirmLabel,
              onPressed: () => Navigator.of(context).pop(true),
            )
          else
            DSPrimaryButton.large(
              context: context,
              title: confirmLabel,
              onPressed: () => Navigator.of(context).pop(true),
            ),
          DSSecondaryButton.large(
            context: context,
            title: cancelLabel,
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );

    return confirmed ?? false;
  }

  /// Shows the popup with a slide-up-from-bottom + fade transition. Dismissal is
  /// intentionally slower than entry (a custom route is needed because
  /// showGeneralDialog reuses transitionDuration for the reverse).
  static Future<T?> _show<T>(
    BuildContext callerContext,
    WidgetBuilder builder,
  ) => Navigator.of(callerContext).push<T>(
    _DSPopupRoute<T>(
      barrierLabel: MaterialLocalizations.of(
        callerContext,
      ).modalBarrierDismissLabel,
      // The popup is a route, so it renders as a sibling of the screen that
      // opened it and inherits the app theme rather than that screen's. Carrying
      // the caller's theme across keeps it consistent with what is behind it:
      // DSBgContainer forces its subtree dark because the gradient is charcoal
      // in every theme, and without this the popup would come up light on top of
      // it whenever the device is in light mode.
      //
      // Builder, not a direct call: [builder] must resolve Theme.of below the
      // wrapper, or the icon and buttons it builds keep the ambient scheme.
      pageBuilder: (context, _, _) => Theme(
        data: Theme.of(callerContext),
        child: Builder(builder: builder),
      ),
      transitionBuilder: (context, animation, _, child) {
        // easeOutBack overshoots past the final position (the "bump"), so
        // it drives the slide only — opacity must stay within [0, 1], so the
        // fade uses its own non-overshooting curve.
        final slide = CurvedAnimation(
          parent: animation,
          curve: _entryCurve,
          reverseCurve: Curves.easeInOutCubic,
        );
        final fade = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
          reverseCurve: Curves.easeInOut,
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(slide),
          child: FadeTransition(opacity: fade, child: child),
        );
      },
    ),
  );
}

/// A [RawDialogRoute] whose reverse (dismiss) transition runs longer than the
/// entry — [RawDialogRoute] otherwise reuses [transitionDuration] for both.
final class _DSPopupRoute<T> extends RawDialogRoute<T> {
  _DSPopupRoute({
    required super.barrierLabel,
    required super.pageBuilder,
    required super.transitionBuilder,
  }) : super(
         barrierColor: Colors.black54,
         transitionDuration: DSPopup._transitionDuration,
       );

  @override
  Duration get reverseTransitionDuration => DSPopup._reverseTransitionDuration;
}

final class _DSPopupBody extends StatelessWidget {
  const _DSPopupBody({
    required this.actions,
    required this.message,
    required this.title,
    this.icon,
    this.iconColor,
  });

  final List<Widget> actions;
  final IconData? icon;
  final Color? iconColor;
  final String message;
  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final icon = this.icon;

    return Dialog(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: DSSpace.xlarge,
        vertical: DSSpace.xxlarge,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DSCornerRadius.large),
      ),
      child: Padding(
        padding: const EdgeInsets.all(DSSpace.large),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .stretch,
          children: [
            if (icon != null) ...[
              Icon(icon, color: iconColor, size: DSSpace.xxxlarge),
              DSVerticalSpace.medium,
            ],
            Text(title, textAlign: .center, style: textTheme.titleLarge),
            DSVerticalSpace.small,
            Text(
              message,
              textAlign: .center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            DSVerticalSpace.xlarge,
            for (var index = 0; index < actions.length; index++) ...[
              if (index > 0) DSVerticalSpace.xsmall,
              actions[index],
            ],
          ],
        ),
      ),
    );
  }
}
