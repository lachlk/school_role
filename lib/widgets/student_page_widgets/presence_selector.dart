import 'package:flutter/material.dart';

/// An enumeration representing the possible presence states of a student.
/// Each state has an associated string `value`.
enum Presence {
  present('present'),
  late('late'),
  absent('absent');

  const Presence(this.value);
  final String value;
}

/// A `StatefulWidget` that provides a segmented button for selecting a students
/// presence status: present, late, or absent.
class PresenceSelector extends StatefulWidget {
  const PresenceSelector({
    super.key,
    required this.selectedPresence,
    required this.onPresenceChanged,
  });

  /// The initial or currently selected presence status as a `String`.
  final String selectedPresence;
  /// A callback function that is triggered when the presence status is changed.
  final ValueChanged<String> onPresenceChanged;

  @override
  State<PresenceSelector> createState() => _PresenceSelectorState();
}

class _PresenceSelectorState extends State<PresenceSelector> {
  late Presence presenceView;

  /// Initializes the state.
  ///
  /// This method is called once when the widget is inserted into the widget tree.
  /// It initializes `presenceView` based on the `selectedPresence` string passed
  /// to the widget, defaulting to `Presence.absent` if the string doesn't match.
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