import 'package:flutter/material.dart';

class WeekdaySelector extends StatefulWidget {
  const WeekdaySelector({
    super.key,
    required this.initialSelection,
    required this.onSelectedChanged,
  });

  final Map<String, int?> initialSelection;
  final ValueChanged<Map<String, int?>> onSelectedChanged;

  @override
  State<WeekdaySelector> createState() => _WeekdaySelectorState();
}

class _WeekdaySelectorState extends State<WeekdaySelector> {
  late Map<String, int?> days;

  @override
  void initState() {
    super.initState();
    days = widget.initialSelection;
  }

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