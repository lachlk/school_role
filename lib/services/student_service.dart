import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_role/models/student.dart';

class StudentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> addStudent({
    required String schoolID,
    required String name,
    required String email,
    required int yearLevel,
  }) async {
    final docRef =
        _firestore.collection('schools').doc(schoolID).collection('students').doc();
    await docRef.set({
      'name': name,
      'email': email,
      'yearLevel': yearLevel,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  Future<void> updateStudent({
    required String schoolID,
    required String studentID,
    required String name,
    required String email,
    required int yearLevel,
    }) async {
      await _firestore
          .collection('schools')
          .doc(schoolID)
          .collection('students')
          .doc(studentID)
          .update({
        'name': name,
        'email': email,
        'yearLevel': yearLevel,
        'updatedAt': FieldValue.serverTimestamp(),
      });
  }
  
  Future<List<Student>> getAllStudents(String schoolID) async {
    final snapshot =
        await _firestore.collection('schools').doc(schoolID).collection('students').get();
    return snapshot.docs.map((doc) => Student.fromDocument(doc)).toList();
  }

  Future<List<Student>> getStudentsByIds(String schoolID, List<String> studentIDs) async {
    if (studentIDs.isEmpty) return [];

    const int chunkSize = 10;
    List<Student> results = [];

    for (int i = 0; i < studentIDs.length; i += chunkSize) {
      final chunk = studentIDs.sublist(
        i,
        i + chunkSize > studentIDs.length ? studentIDs.length : i + chunkSize,
      );

      final snapshot = await _firestore
          .collection('schools')
          .doc(schoolID)
          .collection('students')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      results.addAll(snapshot.docs.map((doc) => Student.fromDocument(doc)));
    }

    return results;
  }

  Stream<List<Student>> streamClassStudents(String schoolID, String classID) {
    return _firestore
        .collection('schools')
        .doc(schoolID)
        .collection('classes')
        .doc(classID)
        .snapshots()
        .asyncExpand((classDoc) async* {
      final classData = classDoc.data();
      if (classData == null || classData['studentIDs'] == null) {
        yield [];
        return;
      }

      final studentIDs =
          (classData['studentIDs'] as Map<String, dynamic>).keys.toList();
      if (studentIDs.isEmpty) {
        yield [];
        return;
      }

      const int chunkSize = 10;
      List<Student> allStudents = [];

      for (int i = 0; i < studentIDs.length; i += chunkSize) {
        final chunk = studentIDs.sublist(
          i,
          i + chunkSize > studentIDs.length ? studentIDs.length : i + chunkSize,
        );

        final snapshot = await _firestore
            .collection('schools')
            .doc(schoolID)
            .collection('students')
            .where(FieldPath.documentId, whereIn: chunk)
            .get();

        allStudents.addAll(snapshot.docs.map((doc) => Student.fromDocument(doc)));
      }

      yield allStudents;
    });
  }
}
