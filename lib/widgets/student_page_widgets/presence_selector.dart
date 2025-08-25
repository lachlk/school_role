import 'package:flutter/material.dart';

enum Presence {
  present('present'), late('late'), absent('absent');

  const Presence(this.value);
  final String value;
} // Values for presence status

class PresenceSelector extends StatefulWidget {
  final String selectedPresence;
  const PresenceSelector({super.key, required this.selectedPresence}); // Presence selector widget

  @override
  State<PresenceSelector> createState() =>
      _PresenceSelectorState(); // Create state for presence selector
}

class _PresenceSelectorState extends State<PresenceSelector> {
  // Presence presenceView = Presence.absent; // Defualt status
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
      // Segmented button for presence
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
      selected: {presenceView}, // Selected presence
      onSelectionChanged: (newSelection) {
        setState(() {
          presenceView = newSelection.first; // Updates presence for selected
        });
      },
    );
  }
}
