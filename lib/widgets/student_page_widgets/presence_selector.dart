import 'package:flutter/material.dart';

enum Presence {
  present('present'),
  late('late'),
  absent('absent');

  const Presence(this.value);
  final String value;
}

class PresenceSelector extends StatefulWidget {
  final String selectedPresence;
  final ValueChanged<String> onPresenceChanged;

  const PresenceSelector({
    super.key,
    required this.selectedPresence,
    required this.onPresenceChanged,
  });

  @override
  State<PresenceSelector> createState() => _PresenceSelectorState();
}

class _PresenceSelectorState extends State<PresenceSelector> {
  late Presence presenceView;

  @override
  void initState() {
    super.initState();
    presenceView = Presence.values.firstWhere(
      (p) => p.value == widget.selectedPresence,
      orElse: () => Presence.absent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Presence>(
      showSelectedIcon: false,
      segments: const <ButtonSegment<Presence>>[
        ButtonSegment<Presence>(
          value: Presence.present,
          label: Text('Present'),
        ),
        ButtonSegment<Presence>(
          value: Presence.late,
          label: Text('Late'),
        ),
        ButtonSegment<Presence>(
          value: Presence.absent,
          label: Text('Absent'),
        ),
      ],
      selected: {presenceView},
      onSelectionChanged: (newSelection) {
        setState(() {
          presenceView = newSelection.first;
        });
        widget.onPresenceChanged(presenceView.value);
      },
    );
  }
}