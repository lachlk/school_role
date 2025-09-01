import 'package:flutter/material.dart';
import 'package:school_role/widgets/student_page_widgets/student_list.dart';
import 'package:school_role/widgets/student_page_widgets/student_bottom_sheet.dart';
import 'package:school_role/widgets/custom_app_bar.dart';
import 'package:school_role/services/class_service.dart';
import 'package:school_role/widgets/student_page_widgets/single_day_selector.dart';
import 'package:school_role/services/attendance_service.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({
    super.key,
    required this.classID,
    required this.schoolID,
    required this.className,
  });

  final String classID;
  final String schoolID;
  final String className;

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final ClassService _classService = ClassService();
  final AttendanceService _attendanceService = AttendanceService();
  final Map<String, String> _attendanceRecords = {};

  void _onAttendanceChanged(String studentID, String presence) {
    setState(() {
      _attendanceRecords[studentID] = presence;
    });
  }

  Future<void> _submitPresence() async {
    final classData = await _classService.getClassById(widget.classID);
    final schedule = classData?['schedule'] as Map<String, dynamic>?;

    if (schedule == null || schedule.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No schedule found for this class.')),
      );
      return;
    }

    final List<String> scheduledDays = schedule.keys.toList();
    final selectedDayNotifier = ValueNotifier<String?>(null);

    if (!context.mounted) return;
    final selectedDay = await showDialog<String?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select a day for the roll'),
          content: ValueListenableBuilder<String?>(
            valueListenable: selectedDayNotifier,
            builder: (context, selectedDay, child) {
              return SingleDaySelector(
                scheduledDays: scheduledDays,
                selectedDay: selectedDay,
                onDaySelected: (day) {
                  selectedDayNotifier.value = day;
                },
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ValueListenableBuilder<String?>(
              valueListenable: selectedDayNotifier,
              builder: (context, selectedDay, child) {
                return ElevatedButton(
                  onPressed: selectedDay != null
                      ? () => Navigator.of(context).pop(selectedDay)
                      : null,
                  child: const Text('Submit'),
                );
              },
            ),
          ],
        );
      },
    );

    if (selectedDay != null) {
      final selectedPeriod = schedule[selectedDay] as int?;

      if (selectedPeriod != null) {
        try {
          await _attendanceService.addAttendanceForDay(
            classID: widget.classID,
            schoolID: widget.schoolID,
            records: _attendanceRecords,
            selectedDay: selectedDay,
            selectedPeriod: selectedPeriod,
          );

          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Presence for $selectedDay submitted!')),
          );
        } catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error submitting attendance: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onBackTap: () => Navigator.of(context).pop(),
        title: widget.className,
        actions: [
          TextButton(
            onPressed: _submitPresence,
            child: const Text('Submit'),
          ),
        ],
      ),
      body: StudentList(
        classID: widget.classID,
        schoolID: widget.schoolID,
        onAttendanceChanged: _onAttendanceChanged,
      ),
      floatingActionButton: FloatingActionButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.add),
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => StudentBottomSheet(
            classID: widget.classID,
            schoolID: widget.schoolID,
            onStudentAdded: () => setState(() {}),
            onRemove: (studentID) async {
              final classService = ClassService();
              await classService.removeStudentFromClass(
                schoolID: widget.schoolID,
                classID: widget.classID,
                studentID: studentID,
              );
              setState(() {});
            },
          ),
        ),
      ),
    );
  }
}