import 'package:flutter/material.dart';

class SingleDaySelector extends StatelessWidget {
  const SingleDaySelector({
    super.key,
    required this.scheduledDays,
    required this.selectedDay,
    required this.onDaySelected,
  });

  final List<String> scheduledDays;
  final String? selectedDay;
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