import 'package:flutter/material.dart';
import 'package:school_role/services/class_service.dart';
import 'package:school_role/widgets/weekday_selector.dart';

class ClassBottomSheet extends StatelessWidget {
  const ClassBottomSheet({
    super.key,
    required this.controller,
    required this.uID,
    required this.classService,
    required this.onGetClasses,
  });

  final String uID;
  final TextEditingController controller;
  final ClassService classService;
  final VoidCallback onGetClasses;

  @override
  Widget build(BuildContext context) {
    Map<String, int?> selectedDays = {
      "Mon": null,
      "Tue": null,
      "Wed": null,
      "Thu": null,
      "Fri": null,
    };
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
              controller: controller,
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
                selectedDays = days;
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
                  valueListenable: controller,
                  builder: (context, value, child) {
                    final isEnabled = value.text.isNotEmpty;
                    return TextButton(
                      onPressed: isEnabled
                        ? () async {
                            final name = controller.text.trim();
                            final filteredDays = Map.fromEntries(
                              selectedDays.entries.where((e) => e.value != null),
                            );

                            await classService.addClass(name, filteredDays);
                            onGetClasses();
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
