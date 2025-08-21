import 'package:flutter/material.dart';
import 'package:school_role/services/class_service.dart';
import 'package:school_role/widgets/weekday_selector.dart';

class ClassBottomSheet extends StatefulWidget {
  const ClassBottomSheet({
    super.key,
    required this.controller,
    required this.uID,
    required this.classService,
    required this.onGetClasses,
    this.classId,
    this.initialSelection,
  });

  final String uID;
  final TextEditingController controller;
  final ClassService classService;
  final VoidCallback onGetClasses;
  final String? classId;
  final Map<String, int?>? initialSelection;

  @override
  State<ClassBottomSheet> createState() => _ClassBottomSheetState();
}

class _ClassBottomSheetState extends State<ClassBottomSheet> {
  late Map<String, int?> selectedDays;

  @override
  void initState() {
    super.initState();
    selectedDays = {
      "Mon": null,
      "Tue": null,
      "Wed": null,
      "Thu": null,
      "Fri": null,
    };

    if (widget.initialSelection != null) {
      for (var entry in widget.initialSelection!.entries) {
        selectedDays[entry.key] = entry.value;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                labelText: 'Class Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            WeekdaySelector(
              initialSelection: selectedDays,
              onSelectedChanged: (days) {
                setState(() {
                  selectedDays = days;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: const Text("Close"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: widget.controller,
                  builder: (context, value, child) {
                    final isEnabled = value.text.isNotEmpty;
                    return TextButton(
                      onPressed: isEnabled
                        ? () async {
                            final name = widget.controller.text.trim();
                            final filteredDays = Map.fromEntries(
                              selectedDays.entries.where((e) => e.value != null),
                            );

                            if (widget.classId == null) {
                              await widget.classService.addClass(name, filteredDays);
                            } else {
                              await widget.classService.updateClass(widget.classId!, name, filteredDays);
                            }

                            widget.onGetClasses();
                            if (!context.mounted) return;
                            Navigator.of(context).pop(true);
                          }
                        : null,
                      child: const Text("Submit"),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
