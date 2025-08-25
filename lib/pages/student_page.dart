import 'package:flutter/material.dart';
import 'package:school_role/main.dart';
import 'package:school_role/widgets/custom_app_bar.dart';
import 'package:school_role/widgets/student_page_widgets/student_bottom_sheet.dart';
import 'package:school_role/widgets/student_page_widgets/student_list.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key, required this.classID});

  final String classID;

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(onBackTap: () {
        Navigator.pop(
          context,
          MaterialPageRoute<FirstRoute>(
            builder: (context) => ThirdRoute(classID: widget.classID,),
          ),
        );
      }), // Setting MyAppBar as appBar widget
      body: StudentList(classID: widget.classID), // Setting StudentList as body
      floatingActionButton: FloatingActionButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.all(Radius.circular(20)),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.add),
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (context) {
            return const StudentBottomSheet();
          },
        ),
      ),
    );
  }
}