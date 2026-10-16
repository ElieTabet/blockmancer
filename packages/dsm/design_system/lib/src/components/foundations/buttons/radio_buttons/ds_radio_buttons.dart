import 'package:design_system/src/components/foundations/buttons/radio_buttons/ds_radio_button.dart';
import 'package:design_system/src/components/foundations/theme/ds_space.dart';
import 'package:flutter/material.dart';

final class DSRadioButtons extends StatefulWidget {
  /// Public Properties
  final ValueChanged<int> onSelectionChanged;

  /// Private Properties
  final List<String> _labels;

  /// Constructor
  const DSRadioButtons({
    super.key,
    required List<String> labels,
    required this.onSelectionChanged,
  }) : _labels = labels;

  @override
  State<DSRadioButtons> createState() => _DSRadioButtonsState();
}

class _DSRadioButtonsState extends State<DSRadioButtons> {
  /// Private Properties
  int? _selectedIndex;

  /// Layout
  @override
  Widget build(BuildContext context) {
    return Row(spacing: DSSpace.small, children: _radioButtons);
  }

  List<DSRadioButton> get _radioButtons => widget._labels
      .asMap()
      .entries
      .map(
        (entry) => DSRadioButton(
          key: ValueKey(entry.key),
          label: entry.value,
          value: entry.key == _selectedIndex,
          onSelected: () {
            setState(() {
              _selectedIndex = entry.key;
            });
            widget.onSelectionChanged.call(entry.key);
          },
        ),
      )
      .toList();
}
