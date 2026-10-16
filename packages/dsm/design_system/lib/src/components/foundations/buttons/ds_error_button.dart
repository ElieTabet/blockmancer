import 'package:design_system/src/components/foundations/buttons/ds_button.dart';
import 'package:flutter/material.dart';

/// Filled destructive button — solid error background with onError text. For
/// destructive actions (log out, delete) that warrant the error color.
final class DSErrorButton extends DSButton {
  DSErrorButton._({
    required super.context,
    required super.enabled,
    required super.isLoading,
    required super.onPressed,
    required super.size,
    required super.title,
    super.key,
  }) : super.text(
         backgroundColor: Theme.of(context).colorScheme.error,
         textColor: Theme.of(context).colorScheme.onError,
       );

  DSErrorButton.small({
    required BuildContext context,
    required VoidCallback onPressed,
    required String title,
    bool enabled = true,
    bool isLoading = false,
    Key? key,
  }) : this._(
         key: key,
         title: title,
         isLoading: isLoading,
         enabled: enabled,
         onPressed: onPressed,
         context: context,
         size: DSButtonSize.small,
       );

  DSErrorButton.medium({
    required BuildContext context,
    required VoidCallback onPressed,
    required String title,
    bool enabled = true,
    bool isLoading = false,
    Key? key,
  }) : this._(
         key: key,
         title: title,
         isLoading: isLoading,
         enabled: enabled,
         onPressed: onPressed,
         context: context,
         size: DSButtonSize.medium,
       );

  DSErrorButton.large({
    required BuildContext context,
    required VoidCallback onPressed,
    required String title,
    bool enabled = true,
    bool isLoading = false,
    Key? key,
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
