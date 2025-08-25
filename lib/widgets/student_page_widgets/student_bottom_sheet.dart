import 'package:flutter/material.dart';

class StudentBottomSheet extends StatefulWidget {
  const StudentBottomSheet({super.key});

  @override
  State<StudentBottomSheet> createState() => _StudentBottomSheetState();
}

class _StudentBottomSheetState extends State<StudentBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            borderRadius: BorderRadius.circular(8.0),
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<String>.empty();
                        }
                        return ['Option 1', 'Option 2', 'Option 3']
                            .where((String option) {
                          return option.contains(textEditingValue.text.toLowerCase());
                        });
                      },
                    ),
                  ),
                ),
                IconButton(
                  color: Theme.of(context).colorScheme.onSurface,
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.person),
              label: Text('New Student'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Close"),
              ),
              TextButton(
                onPressed: () {},
                child: const Text("Save"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}