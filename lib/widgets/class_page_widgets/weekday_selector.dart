import 'package:flutter/material.dart';

/// A `StatefulWidget` that allows users to select weekdays and associate a
/// "period" with each selected day.
///
/// This widget is useful for setting up a class schedule. It displays a row
/// of `FilterChip` widgets for each weekday. When a day is selected, a
/// `DropdownButton` appears below it to assign a period.
class WeekdaySelector extends StatefulWidget {
  const WeekdaySelector({
    super.key,
    required this.initialSelection,
    required this.onSelectedChanged,
  });

  /// A map representing the initial selection of days and their associated periods.
  final Map<String, int?> initialSelection;
  /// A callback function that is triggered whenever the selection of days or
  /// periods changes.
  final ValueChanged<Map<String, int?>> onSelectedChanged;

  @override
  State<WeekdaySelector> createState() => _WeekdaySelectorState();
}

class _WeekdaySelectorState extends State<WeekdaySelector> {
  late Map<String, int?> days;

  /// Initializes the state.
  ///
  /// This method is called once when the widget is inserted into the widget tree.
  /// It copies the `initialSelection` map to the local `days` state variable.
  @override
  void initState() {
    super.initState();
    days = widget.initialSelection;
  }

  /// A helper function to call the `onSelectedChanged` callback from the parent widget.
  void updateParent() {
    widget.onSelectedChanged(days);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          children: days.keys.map((day) {
            return FilterChip(
              label: Text(day),
              selected: days[day] != null,
              onSelected: (bool selected) {
                setState(() {
                  days[day] = selected ? 1 : null;
                });
                updateParent();
              },
            );
          }).toList(),
        ),
        Column(
          children: days.entries
            .where((e) => e.value != null)
            .map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Text('${e.key}: '),
                  DropdownButton<int>(
                    value: e.value,
                    items: List.generate(3, (i) => i + 1)
                      .map((period) => DropdownMenuItem(
                        value: period,
                        child: Text('Period $period'),
                      )).toList(),
                    onChanged: (value) {
                      setState(() {
                        days[e.key] = value;
                      });
                      updateParent();
                    },
                  ),
                ],
              ),
            ),
          ).toList(),
        ),
      ],
    );
  }
}