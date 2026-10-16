import 'package:design_system/src/components/foundations/buttons/ds_back_button.dart';
import 'package:design_system/src/components/foundations/theme/ds_color.dart';
import 'package:flutter/material.dart';

/// The bar over every pushed page: the header band's charcoal, so the page's
/// top edge matches the tab shell's, and [DSBackButton] in place of Material's.
final class DSAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DSAppBar({this.actions, this.title, super.key});

  final List<Widget>? actions;
  final Widget? title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
    actions: actions,
    backgroundColor: DSColor.charcoal,
    elevation: 0,
    foregroundColor: DSColor.white,
    leading: const DSBackButton(),
    scrolledUnderElevation: 0,
    title: title,
  );
}
