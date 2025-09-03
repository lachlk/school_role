import 'package:flutter/material.dart';

/// A stateless widget that provides a segmented button for selecting a single day
/// from a list of scheduled days.
class SingleDaySelector extends StatelessWidget {
  const SingleDaySelector({
    super.key,
    required this.scheduledDays,
    required this.selectedDay,
    required this.onDaySelected,
  });

  /// The list of days to display as selectable segments.
  final List<String> scheduledDays;
  /// The currently selected day. Can be null if no day is selected.
  final String? selectedDay;
  /// A callback function that is triggered when a new day is selected.
  final ValueChanged<String?> onDaySelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SegmentedButton<String?>(
        showSelectedIcon: false,
        segments: scheduledDays.map((day) {
          return ButtonSegment<String>(
            value: day,
            label: Text(day),
          );
        }).toList(),
        selected: selectedDay != null ? {selectedDay!} : {},
        emptySelectionAllowed: true,
        onSelectionChanged: (newSelection) {
          onDaySelected(newSelection.firstOrNull);
        },
      ),
    );
  }
}