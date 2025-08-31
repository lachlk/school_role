import 'package:flutter/material.dart';
import 'package:school_role/services/student_service.dart';
import 'package:school_role/services/class_service.dart';
import 'package:school_role/models/student.dart';

class StudentBottomSheet extends StatefulWidget {
  const StudentBottomSheet({
    super.key,
    required this.schoolID,
    required this.classID,
    this.onStudentAdded,
  });

  final String classID;
  final String schoolID;
  final VoidCallback? onStudentAdded;

  @override
  State<StudentBottomSheet> createState() => _StudentBottomSheetState();
}

class _StudentBottomSheetState extends State<StudentBottomSheet> {
  final StudentService _studentService = StudentService();
  final ClassService _classService = ClassService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  int? selectedYearLevel;
  bool showNewStudentForm = false;
  List<Student> _searchResults = [];
  Student? _selectedStudent;

  Future<List<String>> _searchStudentNames(String query) async {
    if (query.isEmpty) return [];
    final allStudents = await _studentService.getAllStudents(widget.schoolID);
    _searchResults = allStudents
        .where((s) => s.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return _searchResults.map((s) => s.name).toList();
  }

  Future<void> _saveStudent() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final yearLevel = selectedYearLevel ?? 0;

    if (name.isEmpty || email.isEmpty || yearLevel <= 0) return;

    if (_selectedStudent != null) {
      await _classService.addStudentToClass(
        schoolID: widget.schoolID,
        classID: widget.classID,
        studentID: _selectedStudent!.id,
      );
    } else {
      final newStudentId = await _studentService.addStudent(
        schoolID: widget.schoolID,
        name: name,
        email: email,
        yearLevel: yearLevel,
      );
      await _classService.addStudentToClass(
        schoolID: widget.schoolID,
        classID: widget.classID,
        studentID: newStudentId,
      );
    }
    widget.onStudentAdded?.call();
    if (mounted) Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Search Student", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Material(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) =>
                          _searchStudentNames(textEditingValue.text),
                      onSelected: (value) async {
                        final selectedStudent =
                            _searchResults.firstWhere((s) => s.name == value);
                        
                        setState(() {
                          nameController.text = selectedStudent.name;
                          emailController.text = selectedStudent.email;
                          selectedYearLevel = selectedStudent.yearLevel;
                          _selectedStudent = selectedStudent;
                          showNewStudentForm = true;
                        });
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => setState(() {
                    showNewStudentForm = true;
                    _selectedStudent = null;
                    nameController.clear();
                    emailController.clear();
                    selectedYearLevel = null;
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (showNewStudentForm) ...[
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
                prefixIcon: Icon(Icons.person),
              ),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
              ),
            ),
            DropdownButton<int>(
              value: selectedYearLevel,
              hint: const Text("Select Year Level"),
              items: List.generate(13, (index) => index + 1)
                  .map((y) => DropdownMenuItem(value: y, child: Text("Year $y")))
                  .toList(),
              onChanged: (value) => setState(() => selectedYearLevel = value),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () => setState(() => showNewStudentForm = false),
                    child: const Text("Cancel")),
                ElevatedButton(onPressed: _saveStudent, child: const Text("Save")),
              ],
            ),
          ],
        ],
      ),
    );
  }
}