import 'package:design_system/src/components/foundations/theme/ds_space.dart';
import 'package:flutter/material.dart';

final class DSRadioButton extends StatelessWidget {
  /// Private Properties
  final bool _value;
  final String _labelValue;
  final Function() _onSelected;

  /// Constructor
  const DSRadioButton({
    required super.key,
    required bool value,
    required String label,
    required Function() onSelected,
  }) : _value = value,
       _labelValue = label,
       _onSelected = onSelected;

  /// Layout
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_value) {
          _onSelected();
        }
      },
      child: Row(
        spacing: DSSpace.xsmall,
        children: [_radioButton(context), _label(context)],
      ),
    );
  }

  Widget _radioButton(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 250),
      width: 15.0,
      height: 15.0,
      decoration: BoxDecoration(
        color: _value ? Theme.of(context).colorScheme.primary : Colors.white,
        borderRadius: BorderRadius.circular(7.5),
      ),
    );
  }

  Widget _label(BuildContext context) {
    return Text(
      _labelValue,
      textAlign: TextAlign.left,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
