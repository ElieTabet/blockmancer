import 'package:design_system/src/components/foundations/theme/ds_corner_radius.dart';
import 'package:design_system/src/components/foundations/theme/ds_space.dart';
import 'package:flutter/material.dart';

final class DSSectionContainer extends StatelessWidget {
  /// Private Properties
  final String _title;
  final String _description;

  const DSSectionContainer({
    super.key,
    required String title,
    required String description,
  }) : _title = title,
       _description = description;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DSCornerRadius.intermediate),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      padding: EdgeInsets.all(DSSpace.xlarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: DSSpace.medium,
        children: [
          Text(_title, style: Theme.of(context).textTheme.headlineSmall),
          Text(_description, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
