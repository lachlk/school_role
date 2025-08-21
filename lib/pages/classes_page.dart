import 'package:flutter/material.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:school_role/main.dart';
import 'package:school_role/services/class_service.dart';
import 'package:school_role/widgets/class_page_widgets/classes_list.dart';
import 'package:school_role/widgets/class_page_widgets/class_bottom_sheet.dart';

class ClassesPage extends StatefulWidget {
  const ClassesPage({
    super.key,
    required this.uID
  });

  final String uID;

  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  final ClassService classService = ClassService();
  late Future<List<Map<String, String>>> futureClasses;
  final List<DraggableGridItem> draggableItems = [];
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    loadClasses();
  }

  void loadClasses() {
    setState(() {
      draggableItems.clear();
      futureClasses = classService.getClassList(widget.uID);
    });
  }

    @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(onBackTap: null),
      body: ClassesList(
        uID: widget.uID,
        classService: classService,
        onRefresh: loadClasses,
      ),
      floatingActionButton: FloatingActionButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.all(Radius.circular(20)),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.add),
        onPressed: () async {
          final controller = TextEditingController();
          final shouldRefresh = await showModalBottomSheet<bool>(
            context: context,
            isScrollControlled: true,
            builder: (context) => ClassBottomSheet(
              controller: controller,
              uID: widget.uID,
              classService: classService,
              onGetClasses: loadClasses,
            ),
          );

          if (shouldRefresh == true) loadClasses();
        },
      ),
    );
  }
}