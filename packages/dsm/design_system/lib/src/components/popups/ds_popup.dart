import 'package:design_system/src/components/foundations/buttons/ds_pressable.dart';
import 'package:design_system/src/components/foundations/theme/ds_color.dart';
import 'package:design_system/src/components/foundations/theme/ds_corner_radius.dart';
import 'package:design_system/src/components/foundations/theme/ds_font.dart';
import 'package:design_system/src/components/foundations/theme/ds_space.dart';
import 'package:design_system/src/components/foundations/theme/ds_vertical_space.dart';
import 'package:flutter/material.dart';

/// Popups in the game's palette: a raised card on the scrim, game buttons. Holds no copy — callers pass already-localized
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
      iconColor: DSColor.negative,
      title: title,
      message: message,
      actions: [
        _DSPopupButton(
          label: buttonLabel,
          onTap: () => Navigator.of(context).pop(),
          style: .primary,
        ),
      ],
    ),
  );

  /// Something done, said with one button: a success, or nothing to do.
  static Future<void> showInfo(
    BuildContext context, {
    required String title,
    required String message,
    required String buttonLabel,
  }) => _show<void>(
    context,
    (context) => _DSPopupBody(
      icon: Icons.check_circle_outline,
      iconColor: DSColor.accent,
      title: title,
      message: message,
      actions: [
        _DSPopupButton(
          label: buttonLabel,
          onTap: () => Navigator.of(context).pop(),
          style: .primary,
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
        // Destroying is never the default: backing out leads, and the
        // destroying button follows it, outlined in red.
        actions: isDestructive
            ? [
                _DSPopupButton(
                  label: cancelLabel,
                  onTap: () => Navigator.of(context).pop(false),
                  style: .primary,
                ),
                _DSPopupButton(
                  label: confirmLabel,
                  onTap: () => Navigator.of(context).pop(true),
                  style: .destructive,
                ),
              ]
            : [
                _DSPopupButton(
                  label: confirmLabel,
                  onTap: () => Navigator.of(context).pop(true),
                  style: .primary,
                ),
                _DSPopupButton(
                  label: cancelLabel,
                  onTap: () => Navigator.of(context).pop(false),
                  style: .secondary,
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
      pageBuilder: (context, _, _) => Builder(builder: builder),
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
         barrierColor: DSColor.scrim,
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
    final icon = this.icon;

    return Dialog(
      backgroundColor: DSColor.card,
      elevation: 0,
      insetPadding: const .symmetric(
        horizontal: DSSpace.xlarge,
        vertical: DSSpace.xxlarge,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: .circular(DSCornerRadius.large),
        side: const BorderSide(color: DSColor.cardBorder, width: 2),
      ),
      child: Padding(
        padding: const .all(DSSpace.large),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .stretch,
          children: [
            if (icon != null) ...[
              Icon(icon, color: iconColor, size: DSSpace.xxxlarge),
              DSVerticalSpace.medium,
            ],
            Text(
              title,
              textAlign: .center,
              style: DSFont.display(
                const TextStyle(
                  color: DSColor.white,
                  fontSize: 22,
                  fontWeight: .w600,
                ),
              ),
            ),
            DSVerticalSpace.small,
            Text(
              message,
              textAlign: .center,
              style: const TextStyle(color: DSColor.textMuted, fontSize: 14),
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

enum _DSPopupButtonStyle { destructive, primary, secondary }

/// A game button: amber to go ahead, outlined to back out, outlined in red
/// to destroy.
final class _DSPopupButton extends StatelessWidget {
  const _DSPopupButton({
    required this.label,
    required this.onTap,
    required this.style,
  });

  static const _minHeight = 54.0;

  final String label;
  final VoidCallback onTap;
  final _DSPopupButtonStyle style;

  @override
  Widget build(BuildContext context) {
    final (background, border, text) = switch (style) {
      .destructive => (DSColor.sheet, DSColor.negative, DSColor.negative),
      .primary => (DSColor.accent, DSColor.accent, DSColor.primary),
      .secondary => (DSColor.sheet, DSColor.cardBorder, DSColor.white),
    };

    return DSPressable(
      onTap: onTap,
      child: Container(
        // At least this tall, and taller for a label that wraps at a large
        // text size rather than clipping it.
        constraints: const BoxConstraints(minHeight: _minHeight),
        padding: const .symmetric(
          horizontal: DSSpace.medium,
          vertical: DSSpace.xsmall,
        ),
        alignment: .center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: .circular(DSCornerRadius.large),
          border: .all(color: border, width: 2),
        ),
        child: Text(
          label,
          textAlign: .center,
          style: DSFont.display(
            TextStyle(color: text, fontSize: 18, fontWeight: .w700),
          ),
        ),
      ),
    );
  }
}
