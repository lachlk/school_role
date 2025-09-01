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
    this.onRemove,
  });

  final String classID;
  final String schoolID;
  final VoidCallback? onStudentAdded;
  final void Function(String)? onRemove;

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
  bool _isStudentInClass = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

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
      await _studentService.updateStudent(
        schoolID: widget.schoolID,
        studentID: _selectedStudent!.id,
        name: name,
        email: email,
        yearLevel: yearLevel,
      );

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

  Future<void> _confirmRemove() async {
    if (_selectedStudent == null) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Student'),
        content: Text('Are you sure you want to remove ${nameController.text}? This will not delete their profile.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true && widget.onRemove != null && _selectedStudent != null) {
      widget.onRemove!(_selectedStudent!.id);
      if (mounted) Navigator.of(context).pop();
    }
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
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        nameController.text = textEditingValue.text;
                        return _searchStudentNames(textEditingValue.text);
                      },
                      onSelected: (value) async {
                        final selectedStudent =
                            _searchResults.firstWhere((s) => s.name == value);
                        
                        final isInClass = await _classService.isStudentInClass(
                          schoolID: widget.schoolID,
                          classID: widget.classID,
                          studentID: selectedStudent.id,
                        );

                        setState(() {
                          nameController.text = selectedStudent.name;
                          emailController.text = selectedStudent.email;
                          selectedYearLevel = selectedStudent.yearLevel;
                          _selectedStudent = selectedStudent;
                          _isStudentInClass = isInClass;
                          showNewStudentForm = true;
                        });
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isStudentInClass
                        ? Icons.delete
                        : Icons.add,
                  ),
                  color: _isStudentInClass
                      ? Theme.of(context).colorScheme.onSurface
                      : null,
                  onPressed: () {
                    if (_isStudentInClass) {
                      _confirmRemove();
                    } else if (showNewStudentForm) {
                      _saveStudent();
                    } else {
                      setState(() {
                        showNewStudentForm = true;
                        _selectedStudent = null;
                        emailController.clear();
                        selectedYearLevel = null;
                      });
                    }
                  },
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
                    onPressed: () => setState(() {
                          showNewStudentForm = false;
                          _selectedStudent = null;
                          nameController.clear();
                        }),
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