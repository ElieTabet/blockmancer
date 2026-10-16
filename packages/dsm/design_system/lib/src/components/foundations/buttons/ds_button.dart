import 'dart:io';
import 'package:design_system/src/components/foundations/theme/ds_corner_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

enum DSButtonSize { small, medium, large }

class DSButton extends StatelessWidget {
  // Private Properties
  final VoidCallback _onPressedAction;
  final Widget _child;
  final bool _enabled;
  final EdgeInsets? _padding;
  final Color? _backgroundColor;
  final Alignment _alignment;
  final bool _isLoading;
  final BorderRadius _borderRadius;
  final Color _borderColor;
  final double _borderWidth;
  final TextStyle? _textStyle;
  final double? _height;
  final double _spinnerSize;

  // Main constructor
  DSButton({
    super.key,
    required VoidCallback onPressed,
    required Widget child,
    bool enabled = true,
    EdgeInsets? padding,
    Color? backgroundColor,
    Alignment alignment = Alignment.center,
    bool isLoading = false,
    BorderRadius? borderRadius,
    double? borderWidth,
    Color borderColor = Colors.transparent,
    TextStyle? textStyle,
    DSButtonSize size = DSButtonSize.medium,
  }) : _enabled = enabled,
       _onPressedAction = onPressed,
       _child = child,
       _padding = padding ?? _paddingFor(size),
       _backgroundColor = backgroundColor,
       _alignment = alignment,
       _isLoading = isLoading,
       _borderRadius =
           borderRadius ?? BorderRadius.circular(DSCornerRadius.intermediate),
       _borderWidth = borderWidth ?? 1.0,
       _borderColor = borderColor,
       _textStyle = textStyle,
       _height = _sizeFor(size),
       _spinnerSize = _spinnerSizeFor(size);

  // Named constructor for text-only buttons
  DSButton.text({
    Key? key,
    required BuildContext context,
    required VoidCallback onPressed,
    required String title,
    required DSButtonSize size,
    bool enabled = true,
    Color? backgroundColor,
    Color textColor = Colors.black,
    Alignment alignment = Alignment.center,
    bool isLoading = false,
    BorderRadius? borderRadius,
    double? borderWidth,
    Color borderColor = Colors.transparent,
    TextStyle? textStyle,
  }) : this(
         key: key,
         onPressed: onPressed,
         child: Text(
           title,
           style: _textStyleFor(
             context: context,
             size: size,
             textColor: textColor.withValues(alpha: enabled ? 1.0 : 0.38),
             textStyle: textStyle,
           ),
         ),
         enabled: enabled,
         backgroundColor: backgroundColor,
         alignment: alignment,
         isLoading: isLoading,
         borderRadius: borderRadius,
         borderWidth: borderWidth,
         borderColor: borderColor,
         textStyle: textStyle,
         size: size,
       );

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ? _buildCupertino() : _buildMaterial();
  }

  Widget _buildCupertino() {
    return SizedBox(
      height: _height,
      child: _borderColor == Colors.transparent
          ? CupertinoButton(
              onPressed: _onPressed(),
              disabledColor: _backgroundColor ?? Colors.grey,
              padding: _padding,
              color: _backgroundColor,
              alignment: _alignment,
              borderRadius: _borderRadius,
              child: _buildChild(),
            )
          : Container(
              decoration: BoxDecoration(
                color: _backgroundColor,
                borderRadius: _borderRadius,
                border: Border.all(color: _borderColor, width: _borderWidth),
              ),
              child: CupertinoButton(
                onPressed: _onPressed(),
                disabledColor: Colors.transparent,
                padding: _padding,
                color: Colors.transparent,
                alignment: _alignment,
                child: _buildChild(),
              ),
            ),
    );
  }

  Widget _buildMaterial() {
    return TextButton(
      onPressed: _onPressed(),
      style: TextButton.styleFrom(
        padding: _padding,
        tapTargetSize: MaterialTapTargetSize
            .shrinkWrap, // To remove the extra bottom padding
        backgroundColor: _backgroundColor,
        alignment: _alignment,
        shape: RoundedRectangleBorder(
          borderRadius: _borderRadius,
          side: BorderSide(color: _borderColor, width: _borderWidth),
        ),
      ),
      child: _buildChild(),
    );
  }

  Widget _buildChild() {
    if (!_isLoading) return _child;

    // The label stays in the layout, invisible, so the button keeps the width it
    // had the frame before. Handing the spinner over on its own shrinks the
    // button to spinner-width the moment it is pressed, which reads as the
    // control darting away from the finger that pressed it — and in a row of
    // buttons, shoves its neighbours sideways too.
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(opacity: 0.0, child: _child),
        SizedBox(
          height: _spinnerSize,
          width: _spinnerSize,
          child: CircularProgressIndicator(
            color: _textStyle?.color ?? Colors.white,
            // Scaled with the ring, so a small button's spinner does not read as
            // a thick blob.
            strokeWidth: _spinnerSize / 10,
          ),
        ),
      ],
    );
  }

  VoidCallback? _onPressed() {
    return _enabled && !_isLoading ? _onPressedAction : null;
  }

  // Size helpers
  static EdgeInsets _paddingFor(DSButtonSize size) {
    switch (size) {
      case DSButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0);
      case DSButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);
      case DSButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);
    }
  }

  static TextStyle? _textStyleFor({
    required TextStyle? textStyle,
    required BuildContext context,
    required DSButtonSize size,
    Color? textColor = Colors.white,
  }) {
    final TextStyle? newTextStyle;
    switch (size) {
      case DSButtonSize.small:
        newTextStyle = Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: textColor);
      case DSButtonSize.medium:
        newTextStyle = Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(color: textColor);
      case DSButtonSize.large:
        newTextStyle = Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(color: textColor);
    }

    return newTextStyle?.copyWith(decoration: textStyle?.decoration);
  }

  /// Sized to fit inside the button rather than fixed: 8pt of vertical padding
  /// leaves a small button 16pt of room, which a 20pt ring overflows.
  static double _spinnerSizeFor(DSButtonSize size) {
    switch (size) {
      case DSButtonSize.small:
        return 14.0;
      case DSButtonSize.medium:
        return 16.0;
      case DSButtonSize.large:
        return 20.0;
    }
  }

  static double _sizeFor(DSButtonSize size) {
    switch (size) {
      case DSButtonSize.small:
        return 32.0;
      case DSButtonSize.medium:
        return 36.0;
      case DSButtonSize.large:
        return 44.0;
    }
  }
}
