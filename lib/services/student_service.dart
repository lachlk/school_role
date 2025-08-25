import 'base_database_service.dart';

class StudentService extends BaseDatabaseService {
  Future<Map<String, String>> getStudentIDList(String classID) async {
    final Map<String, String> studentIDs = {};

    final docs = await getDocuments(
      'attendance',
      queryBuilder: (q) => q.where('classID', isEqualTo: classID),
    );

    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>? ?? {};
      final presence = data['presence'];
      if (presence is Map<String, dynamic>) {
        presence.forEach((key, value) {
          studentIDs[key] = value.toString();
        });
      }
    }

    return studentIDs;
  }

  Future<List<Map<String, String>>> getStudentList(String classID) async {
    final studentIDs = await getStudentIDList(classID);
    if (studentIDs.isEmpty) return [];

    final List<Map<String, String>> results = [];

    for (var entry in studentIDs.entries) {
      final doc = await db.collection('students').doc(entry.key).get();
      final name = doc.exists
          ? (doc.data()?['name'] as String? ?? 'Unnamed')
          : 'Unnamed';
      results.add({
        'id': entry.key,
        'name': name,
        'presence': entry.value,
      });
    }

    return results;
  }
}
