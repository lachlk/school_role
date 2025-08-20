import 'package:flutter/material.dart';
import 'package:school_role/services/class_service.dart';

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
    return Container(
      padding: const EdgeInsets.all(16),
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                          await classService.addClass(name);
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
    );
  }
}
