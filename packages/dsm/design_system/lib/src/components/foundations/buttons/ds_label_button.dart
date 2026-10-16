import 'package:design_system/src/components/foundations/buttons/ds_button.dart';
import 'package:flutter/material.dart';

final class DSLabelButton extends DSButton {
  // Private constructor - use factory constructors instead
  DSLabelButton._({
    super.key,
    required super.context,
    required super.title,
    required super.isLoading,
    required super.enabled,
    required super.onPressed,
    required super.size,
  }) : super.text(
         backgroundColor: Colors.transparent,
         textColor: Theme.of(context).colorScheme.onPrimary,
         textStyle: TextStyle(decoration: TextDecoration.underline).copyWith(),
       );

  DSLabelButton.small({
    Key? key,
    required String title,
    bool isLoading = false,
    bool enabled = true,
    required BuildContext context,
    required VoidCallback onPressed,
  }) : this._(
         key: key,
         title: title,
         isLoading: isLoading,
         enabled: enabled,
         onPressed: onPressed,
         context: context,
         size: DSButtonSize.small,
       );

  DSLabelButton.medium({
    Key? key,
    required String title,
    bool isLoading = false,
    bool enabled = true,
    required BuildContext context,
    required VoidCallback onPressed,
  }) : this._(
         key: key,
         title: title,
         isLoading: isLoading,
         enabled: enabled,
         onPressed: onPressed,
         context: context,
         size: DSButtonSize.medium,
       );

  DSLabelButton.large({
    Key? key,
    required String title,
    bool isLoading = false,
    bool enabled = true,
    required BuildContext context,
    required VoidCallback onPressed,
  }) : this._(
         key: key,
         title: title,
         isLoading: isLoading,
         enabled: enabled,
         onPressed: onPressed,
         context: context,
         size: DSButtonSize.large,
       );
}
