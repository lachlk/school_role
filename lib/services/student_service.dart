import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_database_service.dart';

class StudentService extends BaseDatabaseService {
  Future<Map<String, dynamic>> getStudentIDList(String classID) async {
    Map<String, dynamic> studentIDs = {};

    final docs = await getDocuments(
      'attendance',
      queryBuilder: (q) => q.where('classID', isEqualTo: classID),
    );

    for (var doc in docs) {
      final presence = doc.get('presence');
      studentIDs.addAll(presence);
    }
    return studentIDs;
  }

  Future<List<Map<String, String>>> getStudentList(String classID) async {
    final studentIDs = await getStudentIDList(classID);

    if (studentIDs.isEmpty) return [];

    final docs = await getDocuments(
      'students',
      queryBuilder: (q) => q.where(FieldPath.documentId, whereIn: studentIDs.keys.toList()),
    );

    return docs.map((doc) => {
      'id': doc.id,
      'name': doc.get('name') as String,
    }).toList();
  }
}
