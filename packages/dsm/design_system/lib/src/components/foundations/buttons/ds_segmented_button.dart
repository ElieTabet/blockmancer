import 'package:flutter/material.dart';

/// A themed single-select segmented control: the selected segment fills with the
/// primary color, no press ripple/highlight overlay. Pass the segments as an
/// ordered `value → label` map (labels are already localized by the caller).
final class DSSegmentedButton<T> extends StatelessWidget {
  final ValueChanged<T> _onSelected;
  final Map<T, String> _segments;
  final T _selected;

  const DSSegmentedButton({
    required ValueChanged<T> onSelected,
    required Map<T, String> segments,
    required T selected,
    super.key,
  }) : _segments = segments,
       _selected = selected,
       _onSelected = onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SegmentedButton<T>(
      showSelectedIcon: false,
      style: ButtonStyle(
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary
              : Colors.transparent,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.onPrimary
              : colorScheme.onSurface,
        ),
      ),
      segments: [
        for (final entry in _segments.entries)
          ButtonSegment(value: entry.key, label: Text(entry.value)),
      ],
      selected: {_selected},
      onSelectionChanged: (selection) => _onSelected(selection.first),
    );
  }
}
