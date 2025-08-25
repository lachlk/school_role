import 'package:flutter/material.dart';
import 'package:school_role/services/class_service.dart';
import 'package:school_role/widgets/class_page_widgets/class_bottom_sheet.dart';
import 'package:school_role/widgets/class_page_widgets/classes_list.dart';
import 'package:school_role/widgets/custom_app_bar.dart';

class ClassesPage extends StatelessWidget {
  const ClassesPage({
    super.key,
    required this.uID
  });

  final String uID;

  Future<void> _showAddClassSheet(BuildContext context) async {
    final controller = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ClassBottomSheet(
        controller: controller,
        uID: uID,
        classService: ClassService(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(onBackTap: null),
      body: ClassesList(
        uID: uID,
        classService: ClassService(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddClassSheet(context),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }
}